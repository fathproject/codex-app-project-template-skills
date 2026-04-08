#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  check-memory-github-drift.sh [options]

Options:
  --project-root PATH
  --tracking-mode github_enabled|local_only
  --task-id ID
  --issue-number NUMBER
  --expected-status STATUS
  --repo owner/name
  --project-owner OWNER
  --project-number NUMBER
  --field-name NAME
  --github-snapshot PATH
  --help
EOF
}

project_root="$PWD"
tracking_mode="local_only"
task_id=""
issue_number=""
expected_status=""
repo=""
project_owner=""
project_number=""
field_name="Status"
github_snapshot=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="${2:?missing value for --project-root}"
      shift 2
      ;;
    --tracking-mode)
      tracking_mode="${2:?missing value for --tracking-mode}"
      shift 2
      ;;
    --task-id)
      task_id="${2:?missing value for --task-id}"
      shift 2
      ;;
    --issue-number)
      issue_number="${2:?missing value for --issue-number}"
      shift 2
      ;;
    --expected-status)
      expected_status="${2:?missing value for --expected-status}"
      shift 2
      ;;
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
    --field-name)
      field_name="${2:?missing value for --field-name}"
      shift 2
      ;;
    --github-snapshot)
      github_snapshot="${2:?missing value for --github-snapshot}"
      shift 2
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

if [[ -z "$task_id" ]]; then
  echo "check-memory-github-drift.sh requires --task-id." >&2
  exit 1
fi

case "$tracking_mode" in
  github_enabled|local_only) ;;
  *)
    echo "Invalid tracking mode: $tracking_mode" >&2
    exit 1
    ;;
esac

if [[ ! -d "$project_root" ]]; then
  echo "Project root does not exist: $project_root" >&2
  exit 1
fi

project_root="$(cd "$project_root" && pwd -P)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "check-memory-github-drift.sh requires python3." >&2
  exit 1
fi

resolve_memory_root() {
  local root="$1"
  if [[ -f "$root/memory/PROJECT.md" || -f "$root/memory/TEMPLATE.md" ]]; then
    printf '%s\n' "$root/memory"
  else
    printf '%s\n' "$root"
  fi
}

normalize_status() {
  case "$1" in
    done|Done|completed|Completed|closed|Closed)
      printf '%s\n' "Done"
      ;;
    backlog|Backlog)
      printf '%s\n' "Backlog"
      ;;
    ready|Ready)
      printf '%s\n' "Ready"
      ;;
    in_progress|in-progress|In\ Progress|progress)
      printf '%s\n' "In Progress"
      ;;
    in_review|in-review|review|Review)
      printf '%s\n' "In Review"
      ;;
    in_qa|in-qa|qa|QA)
      printf '%s\n' "In QA"
      ;;
    in_handover|in-handover|handover|Handover)
      printf '%s\n' "In Handover"
      ;;
    blocked|Blocked)
      printf '%s\n' "Blocked"
      ;;
    "")
      printf '%s\n' ""
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}

extract_line() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  grep -F "| $task_id |" "$file" | tail -1 || true
}

extract_status() {
  local line="$1"
  if [[ -z "$line" ]]; then
    return 0
  fi
  printf '%s\n' "$line" | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}'
}

memory_root="$(resolve_memory_root "$project_root")"
project_md="$memory_root/PROJECT.md"
backlog_md="$memory_root/backlog/BACKLOG.md"
roadmap_md="$memory_root/timeline/ROADMAP.md"

project_line="$(extract_line "$project_md")"
backlog_line="$(extract_line "$backlog_md")"
roadmap_line="$(extract_line "$roadmap_md")"

project_status="$(normalize_status "$(extract_status "$project_line")")"
backlog_status="$(normalize_status "$(extract_status "$backlog_line")")"
expected_status_norm="$(normalize_status "$expected_status")"

findings=()

if [[ -z "$project_line" ]]; then
  findings+=("Missing $task_id in PROJECT.md")
fi

if [[ -z "$backlog_line" ]]; then
  findings+=("Missing $task_id in BACKLOG.md")
fi

if [[ -n "$project_status" && -n "$backlog_status" && "$project_status" != "$backlog_status" ]]; then
  findings+=("Local status mismatch: PROJECT.md=$project_status, BACKLOG.md=$backlog_status")
fi

if [[ -n "$expected_status_norm" ]]; then
  if [[ -n "$project_status" && "$project_status" != "$expected_status_norm" ]]; then
    findings+=("PROJECT.md status drift: expected $expected_status_norm, got $project_status")
  fi
  if [[ -n "$backlog_status" && "$backlog_status" != "$expected_status_norm" ]]; then
    findings+=("BACKLOG.md status drift: expected $expected_status_norm, got $backlog_status")
  fi
fi

github_state=""
github_project_status=""

if [[ "$tracking_mode" == "github_enabled" ]]; then
  if [[ -z "$issue_number" ]]; then
    findings+=("GitHub drift check requires --issue-number in github_enabled mode")
  fi

  github_raw="$(mktemp)"
  if [[ -n "$github_snapshot" ]]; then
    if [[ ! -f "$github_snapshot" ]]; then
      findings+=("GitHub snapshot not found: $github_snapshot")
    else
      cp "$github_snapshot" "$github_raw"
    fi
  else
    if [[ -z "$project_owner" || -z "$project_number" ]]; then
      findings+=("Live GitHub drift check requires --project-owner and --project-number")
    elif ! command -v gh >/dev/null 2>&1; then
      findings+=("Missing gh for live GitHub drift check")
    elif ! gh auth status >/dev/null 2>&1; then
      findings+=("Missing authenticated gh session for live GitHub drift check")
    else
      graphql_query='query($owner: String!, $number: Int!) {
        organization(login: $owner) {
          projectV2(number: $number) {
            items(first: 100) {
              nodes {
                content {
                  __typename
                  ... on Issue { number state title }
                }
                fieldValues(first: 50) {
                  nodes {
                    ... on ProjectV2ItemFieldSingleSelectValue {
                      name
                      field { ... on ProjectV2FieldCommon { name } }
                    }
                  }
                }
              }
            }
          }
        }
        user(login: $owner) {
          projectV2(number: $number) {
            items(first: 100) {
              nodes {
                content {
                  __typename
                  ... on Issue { number state title }
                }
                fieldValues(first: 50) {
                  nodes {
                    ... on ProjectV2ItemFieldSingleSelectValue {
                      name
                      field { ... on ProjectV2FieldCommon { name } }
                    }
                  }
                }
              }
            }
          }
        }
      }'
      gh api graphql \
        -f query="$graphql_query" \
        -F owner="$project_owner" \
        -F number="$project_number" > "$github_raw"
    fi
  fi

  if [[ -f "$github_raw" && -n "$issue_number" ]]; then
    github_values="$(
      python3 - "$github_raw" "$issue_number" "$field_name" <<'PY'
import json
import sys

path, issue_number, field_name = sys.argv[1:4]
issue_number = int(issue_number)

with open(path, "r", encoding="utf-8") as handle:
    data = json.load(handle)

issues = None
if isinstance(data, dict) and isinstance(data.get("issues"), list):
    issues = data["issues"]
else:
    project = (((data.get("data") or {}).get("organization") or {}).get("projectV2"))
    if project is None:
        project = (((data.get("data") or {}).get("user") or {}).get("projectV2"))
    issues = []
    for item in (((project or {}).get("items") or {}).get("nodes") or []):
        content = item.get("content") or {}
        if content.get("__typename") != "Issue":
            continue
        project_status = None
        for field_value in ((item.get("fieldValues") or {}).get("nodes") or []):
            field = field_value.get("field") or {}
            if field.get("name") == field_name:
                project_status = field_value.get("name")
                break
        issues.append(
            {
                "issue_number": content.get("number"),
                "state": content.get("state"),
                "project_status": project_status,
            }
        )

match = None
for issue in issues:
    if issue.get("issue_number") == issue_number:
        match = issue
        break

if match is None:
    sys.exit(2)

print((match.get("state") or "") + "\t" + (match.get("project_status") or ""))
PY
    )" || github_values=""

    if [[ -z "$github_values" ]]; then
      findings+=("GitHub issue #$issue_number not found in the selected project")
    else
      github_state="${github_values%%$'\t'*}"
      github_project_status="$(normalize_status "${github_values#*$'\t'}")"
      if [[ -n "$project_status" && -n "$github_project_status" && "$project_status" != "$github_project_status" ]]; then
        findings+=("GitHub project status drift: local=$project_status, github=$github_project_status")
      fi
      if [[ -n "$expected_status_norm" && -n "$github_project_status" && "$github_project_status" != "$expected_status_norm" ]]; then
        findings+=("GitHub project status drift: expected $expected_status_norm, got $github_project_status")
      fi
    fi
  fi

  rm -f "${github_raw:-}"
fi

echo "# AI TEAM Drift Report"
echo
echo "## Task"
echo "- $task_id"
if [[ -n "$issue_number" ]]; then
  echo "- GitHub issue #$issue_number"
fi
echo
echo "## Local Memory State"
echo "- PROJECT.md: ${project_status:-missing}"
echo "- BACKLOG.md: ${backlog_status:-missing}"
if [[ -n "$roadmap_line" ]]; then
  echo "- ROADMAP.md: tracked"
else
  echo "- ROADMAP.md: not referenced"
fi

if [[ "$tracking_mode" == "github_enabled" ]]; then
  echo
  echo "## GitHub State"
  echo "- Issue state: ${github_state:-unknown}"
  echo "- Project status: ${github_project_status:-unknown}"
fi

echo
echo "## Findings"
if [[ "${#findings[@]}" -eq 0 ]]; then
  echo "- No drift detected"
else
  for finding in "${findings[@]}"; do
    echo "- $finding"
  done
fi

if [[ "${#findings[@]}" -gt 0 ]]; then
  exit 1
fi
