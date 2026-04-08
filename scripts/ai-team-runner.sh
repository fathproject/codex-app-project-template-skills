#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ai-team-runner.sh [options]

Options:
  --project-root PATH
  --task-file PATH
  --tracking-mode github_enabled|local_only
  --repository-mode new_repo|existing_repo|local_only_no_remote
  --auth-mode auto|gh_cli|token|oauth|none
  --repo owner/name
  --project-owner OWNER
  --project-number NUMBER
  --schema-file PATH
  --max-iterations N
  --timeout-seconds N
  --continue-on-error
  --skip-ownership-check
  --allow-main
  --dry-run
  --help

Task file format is TSV with this header:
task_id	task_title	worker	command	status	summary	issue_number	milestone	roadmap_note	next_action	github_status	close_issue
EOF
}

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
project_root="$PWD"
task_file=""
tracking_mode="local_only"
repository_mode=""
auth_mode="auto"
repo=""
project_owner=""
project_number=""
schema_file="$repo_root/skills/ai-team/references/github-project-schema.json"
max_iterations=20
timeout_seconds=600
continue_on_error=0
skip_ownership_check=0
allow_main=0
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="${2:?missing value for --project-root}"
      shift 2
      ;;
    --task-file)
      task_file="${2:?missing value for --task-file}"
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
    --schema-file)
      schema_file="${2:?missing value for --schema-file}"
      shift 2
      ;;
    --max-iterations)
      max_iterations="${2:?missing value for --max-iterations}"
      shift 2
      ;;
    --timeout-seconds)
      timeout_seconds="${2:?missing value for --timeout-seconds}"
      shift 2
      ;;
    --continue-on-error)
      continue_on_error=1
      shift
      ;;
    --skip-ownership-check)
      skip_ownership_check=1
      shift
      ;;
    --allow-main)
      allow_main=1
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

if [[ -z "$task_file" ]]; then
  echo "ai-team-runner.sh requires --task-file." >&2
  exit 1
fi

if [[ ! -f "$task_file" ]]; then
  echo "Task file not found: $task_file" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "ai-team-runner.sh requires python3." >&2
  exit 1
fi

project_root="$(cd "$project_root" && pwd -P)"
task_file="$(cd "$(dirname "$task_file")" && pwd -P)/$(basename "$task_file")"

if [[ ! -f "$project_root/memory/PROJECT.md" && ! -f "$project_root/PROJECT.md" ]]; then
  bash "$repo_root/scripts/bootstrap-memory.sh" "$project_root" >/dev/null
fi

onboarding_args=(
  --project-root "$project_root"
  --tracking-mode "$tracking_mode"
  --auth-mode "$auth_mode"
  --schema-file "$schema_file"
)

if [[ -n "$repository_mode" ]]; then
  onboarding_args+=(--repository-mode "$repository_mode")
fi

if [[ -n "$project_owner" ]]; then
  onboarding_args+=(--project-owner "$project_owner")
fi

if [[ -n "$project_number" ]]; then
  onboarding_args+=(--project-number "$project_number")
fi

if [[ "$dry_run" -eq 1 ]]; then
  onboarding_args+=(--skip-schema-check)
fi

bash "$repo_root/scripts/check-project-onboarding.sh" "${onboarding_args[@]}"

run_command() {
  local command_text="$1"
  local timeout_value="$2"
  local log_file="$3"
  python3 - "$command_text" "$timeout_value" "$log_file" <<'PY'
import subprocess
import sys

command_text, timeout_value, log_file = sys.argv[1], int(sys.argv[2]), sys.argv[3]
try:
    result = subprocess.run(
        command_text,
        shell=True,
        text=True,
        capture_output=True,
        timeout=timeout_value,
    )
    output = (result.stdout or "") + (result.stderr or "")
    with open(log_file, "w", encoding="utf-8") as handle:
        handle.write(output)
    sys.exit(result.returncode)
except subprocess.TimeoutExpired as exc:
    output = (exc.stdout or "") if isinstance(exc.stdout, str) else ""
    output += (exc.stderr or "") if isinstance(exc.stderr, str) else ""
    with open(log_file, "w", encoding="utf-8") as handle:
        handle.write(output)
        handle.write("\nTimed out\n")
    sys.exit(124)
PY
}

iteration=0
processed=0

emit_task_rows() {
  python3 - "$task_file" <<'PY'
import csv
import sys

path = sys.argv[1]
fields = [
    "task_id",
    "task_title",
    "worker",
    "command",
    "status",
    "summary",
    "issue_number",
    "milestone",
    "roadmap_note",
    "next_action",
    "github_status",
    "close_issue",
]

with open(path, "r", encoding="utf-8", newline="") as handle:
    reader = csv.DictReader(handle, delimiter="\t")
    for row in reader:
        task_id = (row.get("task_id") or "").strip()
        if not task_id or task_id.startswith("#"):
            continue
        values = []
        for field in fields:
            value = (row.get(field) or "").replace("\n", " ").strip()
            values.append(value)
        print("\x1f".join(values))
PY
}

while IFS=$'\x1f' read -r task_id task_title worker command_text status summary issue_number milestone roadmap_note next_action github_status close_issue || [[ -n "${task_id:-}" ]]; do
  [[ -z "${task_id:-}" ]] && continue

  iteration=$((iteration + 1))
  if (( iteration > max_iterations )); then
    echo "Runner stopped: max iterations $max_iterations reached." >&2
    exit 1
  fi

  processed=$((processed + 1))
  effective_status="${status:-done}"
  effective_github_status="${github_status:-$effective_status}"
  effective_summary="$summary"
  command_status=0
  command_log="$(mktemp)"

  if [[ "$skip_ownership_check" -eq 0 ]] && git -C "$project_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    ownership_args=(--project-root "$project_root" --worker "$worker" --task-id "$task_id")
    if [[ "$allow_main" -eq 1 ]]; then
      ownership_args+=(--allow-main)
    fi
    bash "$repo_root/scripts/validate-worker-ownership.sh" "${ownership_args[@]}"
  fi

  if [[ -n "${command_text:-}" && "$command_text" != "-" ]]; then
    if [[ "$dry_run" -eq 1 ]]; then
      printf 'DRY RUN: %s\n' "$command_text" > "$command_log"
    else
      if ! run_command "$command_text" "$timeout_seconds" "$command_log"; then
        command_status=$?
      fi
    fi
  else
    printf 'No command provided\n' > "$command_log"
  fi

  if [[ "$command_status" -ne 0 ]]; then
    effective_status="blocked"
    effective_github_status="Blocked"
    if [[ -z "$effective_summary" ]]; then
      effective_summary="Runner command failed for $task_id"
    fi
  elif [[ -z "$effective_summary" ]]; then
    effective_summary="$(sed -n '1p' "$command_log")"
    if [[ -z "$effective_summary" ]]; then
      effective_summary="Runner completed $task_id"
    fi
  fi

  sync_args=(
    --project-root "$project_root"
    --tracking-mode "$tracking_mode"
    --task-id "$task_id"
    --task-title "${task_title:-$task_id}"
    --status "$effective_status"
    --worker "$worker"
    --summary "$effective_summary"
    --github-status "$effective_github_status"
  )

  if [[ -n "${issue_number:-}" ]]; then
    sync_args+=(--issue-number "$issue_number")
  fi
  if [[ -n "${milestone:-}" ]]; then
    sync_args+=(--milestone "$milestone")
  fi
  if [[ -n "${roadmap_note:-}" ]]; then
    sync_args+=(--roadmap-note "$roadmap_note")
  fi
  if [[ -n "${next_action:-}" ]]; then
    sync_args+=(--next-action "$next_action")
  fi
  if [[ "$dry_run" -eq 1 ]]; then
    sync_args+=(--dry-run)
  fi

  bash "$repo_root/scripts/sync-completion.sh" "${sync_args[@]}"

  if [[ "$tracking_mode" == "github_enabled" && -n "${issue_number:-}" ]]; then
    github_args=(
      --issue-number "$issue_number"
      --project-number "$project_number"
      --status "$effective_github_status"
      --comment "AI TEAM runner processed $task_id for $worker: $effective_summary"
    )
    if [[ -n "$repo" ]]; then
      github_args+=(--repo "$repo")
    fi
    if [[ -n "$project_owner" ]]; then
      github_args+=(--project-owner "$project_owner")
    fi
    if [[ "${close_issue:-}" == "true" || "${close_issue:-}" == "yes" || "${close_issue:-}" == "1" ]]; then
      github_args+=(--close-issue)
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      github_args+=(--dry-run)
    fi
    bash "$repo_root/scripts/sync-github-task.sh" "${github_args[@]}"
  fi

  echo "# AI TEAM Runner Task"
  echo "- Task: $task_id"
  echo "- Worker: $worker"
  echo "- Status: $effective_status"
  echo "- Summary: $effective_summary"

  rm -f "$command_log"

  if [[ "$command_status" -ne 0 && "$continue_on_error" -eq 0 ]]; then
    echo "Runner stopped after task failure: $task_id" >&2
    exit 1
  fi
done < <(emit_task_rows)

if [[ "$processed" -eq 0 ]]; then
  echo "Runner did not process any tasks from $task_file" >&2
  exit 1
fi

echo "AI TEAM runner completed $processed task(s)."
