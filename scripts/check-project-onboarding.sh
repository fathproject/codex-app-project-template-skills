#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  check-project-onboarding.sh [options]

Options:
  --project-root PATH
  --tracking-mode github_enabled|local_only
  --repository-mode new_repo|existing_repo|local_only_no_remote
  --auth-mode auto|gh_cli|token|oauth|none
  --project-owner OWNER
  --project-number NUMBER
  --schema-file PATH
  --skip-schema-check
  --help
EOF
}

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
project_root="$PWD"
tracking_mode="local_only"
repository_mode=""
auth_mode="auto"
project_owner=""
project_number=""
schema_file="$repo_root/skills/ai-team/references/github-project-schema.json"
skip_schema_check=0
preflight_out="$(mktemp)"
preflight_err="$(mktemp)"
schema_out="$(mktemp)"
schema_err="$(mktemp)"

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
    --repository-mode)
      repository_mode="${2:?missing value for --repository-mode}"
      shift 2
      ;;
    --auth-mode)
      auth_mode="${2:?missing value for --auth-mode}"
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
    --schema-file)
      schema_file="${2:?missing value for --schema-file}"
      shift 2
      ;;
    --skip-schema-check)
      skip_schema_check=1
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

if [[ ! -d "$project_root" ]]; then
  echo "Project root does not exist: $project_root" >&2
  exit 1
fi

project_root="$(cd "$project_root" && pwd -P)"

resolve_memory_root() {
  local root="$1"
  if [[ -f "$root/memory/PROJECT.md" || -f "$root/memory/TEMPLATE.md" ]]; then
    printf '%s\n' "$root/memory"
  else
    printf '%s\n' "$root"
  fi
}

memory_root="$(resolve_memory_root "$project_root")"
declare -a blockers=()
declare -a warnings=()

check_file() {
  local path="$1"
  local label="$2"
  if [[ ! -f "$path" ]]; then
    blockers+=("Missing $label at $path")
  fi
}

check_file "$memory_root/PROJECT.md" "PROJECT.md"
check_file "$memory_root/DECISIONS.md" "DECISIONS.md"
check_file "$memory_root/backlog/BACKLOG.md" "BACKLOG.md"
check_file "$memory_root/timeline/ROADMAP.md" "ROADMAP.md"

if ! git -C "$project_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  warnings+=("Project root is not inside a git repository")
fi

memory_issue_template="$memory_root/.github/ISSUE_TEMPLATE/ai-task.md"
memory_pr_template="$memory_root/.github/pull_request_template.md"
root_issue_template="$project_root/.github/ISSUE_TEMPLATE/ai-task.md"
root_pr_template="$project_root/.github/pull_request_template.md"

if [[ "$tracking_mode" == "github_enabled" ]]; then
  if [[ -f "$memory_issue_template" && ! -f "$root_issue_template" && "$memory_root" != "$project_root" ]]; then
    blockers+=("Root repo is missing .github/ISSUE_TEMPLATE/ai-task.md even though the canonical template exists under memory/")
  fi
  if [[ -f "$memory_pr_template" && ! -f "$root_pr_template" && "$memory_root" != "$project_root" ]]; then
    blockers+=("Root repo is missing .github/pull_request_template.md even though the canonical template exists under memory/")
  fi
  if [[ "$skip_schema_check" -eq 0 ]]; then
    if [[ -z "$project_owner" || -z "$project_number" ]]; then
      blockers+=("GitHub onboarding requires --project-owner and --project-number for schema validation")
    else
      if ! bash "$repo_root/scripts/validate-github-project-schema.sh" --project-owner "$project_owner" --project-number "$project_number" --schema-file "$schema_file" >"$schema_out" 2>"$schema_err"; then
        blockers+=("GitHub Project schema validation failed")
      fi
    fi
  fi
fi

preflight_args=(
  --project-root "$project_root"
  --tracking-mode "$tracking_mode"
  --auth-mode "$auth_mode"
)

if [[ -n "$repository_mode" ]]; then
  preflight_args+=(--repository-mode "$repository_mode")
fi

if ! bash "$repo_root/scripts/preflight-check.sh" "${preflight_args[@]}" >"$preflight_out" 2>"$preflight_err"; then
  blockers+=("Preflight check failed")
fi

echo "# AI TEAM Onboarding Report"
echo
echo "## Project Root"
echo "- $project_root"
echo "- Memory root: $memory_root"
echo
echo "## Required Memory Files"
for file in PROJECT.md DECISIONS.md backlog/BACKLOG.md timeline/ROADMAP.md; do
  target="$memory_root/$file"
  if [[ -f "$target" ]]; then
    echo "- ok: $target"
  else
    echo "- missing: $target"
  fi
done
echo
echo "## GitHub Templates"
if [[ "$tracking_mode" == "github_enabled" ]]; then
  echo "- Root issue template: $([[ -f "$root_issue_template" ]] && echo present || echo missing)"
  echo "- Root PR template: $([[ -f "$root_pr_template" ]] && echo present || echo missing)"
else
  echo "- GitHub templates optional in local_only mode"
fi
echo
echo "## Findings"
if [[ -z "${blockers[*]-}" && -z "${warnings[*]-}" ]]; then
  echo "- Project onboarding looks ready"
else
  if [[ -n "${blockers[*]-}" ]]; then
    for blocker in "${blockers[@]}"; do
      echo "- Blocker: $blocker"
    done
  fi
  if [[ -n "${warnings[*]-}" ]]; then
    for warning in "${warnings[@]}"; do
      echo "- Warning: $warning"
    done
  fi
fi

if [[ -s "$preflight_out" ]]; then
  echo
  echo "## Preflight"
  sed -n '1,80p' "$preflight_out"
fi

if [[ -s "$schema_out" ]]; then
  echo
  echo "## Schema Validation"
  sed -n '1,80p' "$schema_out"
fi

rm -f "$preflight_out" "$preflight_err" "$schema_out" "$schema_err"

if [[ -n "${blockers[*]-}" ]]; then
  exit 1
fi
