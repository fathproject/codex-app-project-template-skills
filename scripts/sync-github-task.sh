#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  sync-github-task.sh [options]

Options:
  --repo owner/name
  --project-owner OWNER
  --project-number NUMBER
  --issue-number NUMBER
  --status STATUS
  --field-name NAME
  --comment TEXT
  --close-issue
  --dry-run
  --help
EOF
}

repo=""
project_owner=""
project_number=""
issue_number=""
status=""
field_name="Status"
comment=""
close_issue=0
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="${2:?missing value for --repo}"
      shift 2
      ;;
    --project-owner)
      project_owner="${2:?missing value for --project-owner}"
      shift 2
      ;;
    --project-number)
      project_number="${2:?missing value for --project-number}"
      shift 2
      ;;
    --issue-number)
      issue_number="${2:?missing value for --issue-number}"
      shift 2
      ;;
    --status)
      status="${2:?missing value for --status}"
      shift 2
      ;;
    --field-name)
      field_name="${2:?missing value for --field-name}"
      shift 2
      ;;
    --comment)
      comment="${2:?missing value for --comment}"
      shift 2
      ;;
    --close-issue)
      close_issue=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$issue_number" || -z "$status" || -z "$project_number" ]]; then
  echo "sync-github-task.sh requires --issue-number, --status, and --project-number" >&2
  exit 1
fi

derive_repo() {
  local remote_url
  if ! remote_url="$(git remote get-url origin 2>/dev/null)"; then
    return 1
  fi

  case "$remote_url" in
    git@github.com:*.git)
      remote_url="${remote_url#git@github.com:}"
      remote_url="${remote_url%.git}"
      ;;
    git@github.com:*)
      remote_url="${remote_url#git@github.com:}"
      ;;
    https://github.com/*.git)
      remote_url="${remote_url#https://github.com/}"
      remote_url="${remote_url%.git}"
      ;;
    https://github.com/*)
      remote_url="${remote_url#https://github.com/}"
      ;;
    *)
      return 1
      ;;
  esac

  printf '%s\n' "$remote_url"
}

normalize_status() {
  case "$1" in
    done|Done|completed|Completed|closed|Closed)
      echo "Done"
      ;;
    backlog|Backlog)
      echo "Backlog"
      ;;
    ready|Ready)
      echo "Ready"
      ;;
    in_progress|in-progress|In\ Progress|progress)
      echo "In Progress"
      ;;
    in_review|in-review|review|Review)
      echo "In Review"
      ;;
    in_qa|in-qa|qa|QA)
      echo "In QA"
      ;;
    in_handover|in-handover|handover|Handover)
      echo "In Handover"
      ;;
    blocked|Blocked)
      echo "Blocked"
      ;;
    *)
      echo "$1"
      ;;
  esac
}

if [[ -z "$repo" ]]; then
  if ! repo="$(derive_repo)"; then
    echo "Could not derive GitHub repo from git remote. Pass --repo owner/name." >&2
    exit 1
  fi
fi

repo_owner="${repo%%/*}"
repo_name="${repo#*/}"

if [[ -z "$project_owner" ]]; then
  project_owner="$repo_owner"
fi

normalized_status="$(normalize_status "$status")"

if [[ "$dry_run" -eq 1 ]]; then
  echo "GitHub sync dry run"
  echo "- Repo: $repo"
  echo "- Project owner: $project_owner"
  echo "- Project number: $project_number"
  echo "- Issue: #$issue_number"
  echo "- Field: $field_name"
  echo "- Status: $normalized_status"
  if [[ -n "$comment" ]]; then
    echo "- Comment: $comment"
  fi
  if [[ "$close_issue" -eq 1 ]]; then
    echo "- Close issue: yes"
  fi
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "sync-github-task.sh requires gh to be installed." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "sync-github-task.sh requires an authenticated gh session." >&2
  exit 1
fi

project_id_query='query($owner: String!, $number: Int!) {
  organization(login: $owner) {
    projectV2(number: $number) { id }
  }
  user(login: $owner) {
    projectV2(number: $number) { id }
  }
}'

field_query='query($owner: String!, $number: Int!) {
  organization(login: $owner) {
    projectV2(number: $number) {
      fields(first: 50) {
        nodes {
          ... on ProjectV2FieldCommon { id name }
          ... on ProjectV2SingleSelectField {
            id
            name
            options { id name }
          }
        }
      }
    }
  }
  user(login: $owner) {
    projectV2(number: $number) {
      fields(first: 50) {
        nodes {
          ... on ProjectV2FieldCommon { id name }
          ... on ProjectV2SingleSelectField {
            id
            name
            options { id name }
          }
        }
      }
    }
  }
}'

item_query='query($owner: String!, $number: Int!) {
  organization(login: $owner) {
    projectV2(number: $number) {
      items(first: 100) {
        nodes {
          id
          content {
            __typename
            ... on Issue { number }
          }
        }
      }
    }
  }
  user(login: $owner) {
    projectV2(number: $number) {
      items(first: 100) {
        nodes {
          id
          content {
            __typename
            ... on Issue { number }
          }
        }
      }
    }
  }
}'

issue_node_query='query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    issue(number: $number) { id }
  }
}'

add_item_mutation='mutation($project: ID!, $content: ID!) {
  addProjectV2ItemById(input: {projectId: $project, contentId: $content}) {
    item { id }
  }
}'

update_status_mutation='mutation($project: ID!, $item: ID!, $field: ID!, $option: String!) {
  updateProjectV2ItemFieldValue(input: {
    projectId: $project
    itemId: $item
    fieldId: $field
    value: { singleSelectOptionId: $option }
  }) {
    projectV2Item { id }
  }
}'

project_id="$(
  gh api graphql \
    -f query="$project_id_query" \
    -F owner="$project_owner" \
    -F number="$project_number" \
    --jq '.data.organization.projectV2.id // .data.user.projectV2.id'
)"

if [[ -z "$project_id" || "$project_id" == "null" ]]; then
  echo "Could not resolve GitHub Project V2 #$project_number for owner $project_owner." >&2
  exit 1
fi

field_id="$(
  gh api graphql \
    -f query="$field_query" \
    -F owner="$project_owner" \
    -F number="$project_number" \
    --jq "((.data.organization.projectV2.fields.nodes // .data.user.projectV2.fields.nodes) // [])[] | select(.name == \"$field_name\") | .id"
)"

option_id="$(
  gh api graphql \
    -f query="$field_query" \
    -F owner="$project_owner" \
    -F number="$project_number" \
    --jq "((.data.organization.projectV2.fields.nodes // .data.user.projectV2.fields.nodes) // [])[] | select(.name == \"$field_name\") | .options[]? | select(.name == \"$normalized_status\") | .id"
)"

if [[ -z "$field_id" || "$field_id" == "null" ]]; then
  echo "Could not find project field named '$field_name' on GitHub Project #$project_number." >&2
  exit 1
fi

if [[ -z "$option_id" || "$option_id" == "null" ]]; then
  echo "Could not find status option '$normalized_status' in field '$field_name'." >&2
  exit 1
fi

item_id="$(
  gh api graphql \
    -f query="$item_query" \
    -F owner="$project_owner" \
    -F number="$project_number" \
    --jq "((.data.organization.projectV2.items.nodes // .data.user.projectV2.items.nodes) // [])[] | select(.content.__typename == \"Issue\" and .content.number == $issue_number) | .id"
)"

if [[ -z "$item_id" || "$item_id" == "null" ]]; then
  issue_node_id="$(
    gh api graphql \
      -f query="$issue_node_query" \
      -F owner="$repo_owner" \
      -F repo="$repo_name" \
      -F number="$issue_number" \
      --jq '.data.repository.issue.id'
  )"

  if [[ -z "$issue_node_id" || "$issue_node_id" == "null" ]]; then
    echo "Could not resolve issue #$issue_number in $repo." >&2
    exit 1
  fi

  item_id="$(
    gh api graphql \
      -f query="$add_item_mutation" \
      -F project="$project_id" \
      -F content="$issue_node_id" \
      --jq '.data.addProjectV2ItemById.item.id'
  )"
fi

if [[ -n "$comment" ]]; then
  comment_file="$(mktemp)"
  printf '%s\n' "$comment" > "$comment_file"
  gh issue comment "$issue_number" --repo "$repo" --body-file "$comment_file" >/dev/null
  rm -f "$comment_file"
fi

gh api graphql \
  -f query="$update_status_mutation" \
  -F project="$project_id" \
  -F item="$item_id" \
  -F field="$field_id" \
  -F option="$option_id" \
  --silent

if [[ "$close_issue" -eq 1 ]]; then
  gh issue close "$issue_number" --repo "$repo" >/dev/null
fi

echo "Synced GitHub issue #$issue_number and project card to '$normalized_status' in $repo."
