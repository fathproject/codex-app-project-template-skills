#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  validate-worker-ownership.sh [options]

Options:
  --project-root PATH
  --worker NAME
  --task-id ID
  --branch NAME
  --commit-ref REF
  --managed-by NAME
  --allow-main
  --help
EOF
}

project_root="$PWD"
worker=""
task_id=""
branch=""
commit_ref="HEAD"
managed_by="ai-project-manager"
allow_main=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="${2:?missing value for --project-root}"
      shift 2
      ;;
    --worker)
      worker="${2:?missing value for --worker}"
      shift 2
      ;;
    --task-id)
      task_id="${2:?missing value for --task-id}"
      shift 2
      ;;
    --branch)
      branch="${2:?missing value for --branch}"
      shift 2
      ;;
    --commit-ref)
      commit_ref="${2:?missing value for --commit-ref}"
      shift 2
      ;;
    --managed-by)
      managed_by="${2:?missing value for --managed-by}"
      shift 2
      ;;
    --allow-main)
      allow_main=1
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

if [[ -z "$worker" ]]; then
  echo "validate-worker-ownership.sh requires --worker." >&2
  exit 1
fi

if ! git -C "$project_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "validate-worker-ownership.sh requires a git repository at $project_root." >&2
  exit 1
fi

project_root="$(cd "$project_root" && pwd -P)"

if [[ -z "$branch" ]]; then
  branch="$(git -C "$project_root" rev-parse --abbrev-ref HEAD)"
fi

worker_branch="${worker#ai-}"
expected_prefix="ai/$worker_branch/"
branch_ok=1
trailer_ok=1
findings=()

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  if [[ "$allow_main" -eq 0 ]]; then
    branch_ok=0
    findings+=("Branch must not stay on $branch for worker-owned execution")
  fi
elif [[ "$branch" != "$expected_prefix"* ]]; then
  branch_ok=0
  findings+=("Branch '$branch' does not match expected prefix '$expected_prefix'")
fi

if [[ -n "$task_id" ]]; then
  task_fragment="${task_id#TASK-}"
  if [[ "$branch" != *"$task_id"* && "$branch" != *"$task_fragment"* ]]; then
    branch_ok=0
    findings+=("Branch '$branch' does not include task identifier '$task_id'")
  fi
fi

commit_message="$(git -C "$project_root" log -1 --pretty=%B "$commit_ref" 2>/dev/null || true)"
if [[ -z "$commit_message" ]]; then
  trailer_ok=0
  findings+=("Commit ref '$commit_ref' is not available")
else
  if ! printf '%s\n' "$commit_message" | grep -Eq "^AI-Worker:[[:space:]]+$worker$"; then
    trailer_ok=0
    findings+=("Latest commit is missing 'AI-Worker: $worker'")
  fi
  if [[ -n "$task_id" ]] && ! printf '%s\n' "$commit_message" | grep -Eq "^Task-ID:[[:space:]]+$task_id$"; then
    trailer_ok=0
    findings+=("Latest commit is missing 'Task-ID: $task_id'")
  fi
  if ! printf '%s\n' "$commit_message" | grep -Eq "^Managed-By:[[:space:]]+$managed_by$"; then
    trailer_ok=0
    findings+=("Latest commit is missing 'Managed-By: $managed_by'")
  fi
fi

echo "# AI TEAM Ownership Report"
echo
echo "## Worker"
echo "- $worker"
if [[ -n "$task_id" ]]; then
  echo "- Task: $task_id"
fi
echo
echo "## Branch Check"
echo "- Branch: $branch"
echo "- Expected prefix: $expected_prefix"
echo "- Result: $([[ "$branch_ok" -eq 1 ]] && echo pass || echo fail)"
echo
echo "## Commit Trailer Check"
echo "- Commit ref: $commit_ref"
echo "- Result: $([[ "$trailer_ok" -eq 1 ]] && echo pass || echo fail)"
echo
echo "## Findings"
if [[ "${#findings[@]}" -eq 0 ]]; then
  echo "- Ownership metadata looks consistent"
else
  for finding in "${findings[@]}"; do
    echo "- $finding"
  done
fi

if [[ "${#findings[@]}" -gt 0 ]]; then
  exit 1
fi
