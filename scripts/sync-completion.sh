#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  sync-completion.sh [options]

Options:
  --project-root PATH
  --tracking-mode github_enabled|local_only
  --task-id ID
  --task-title TITLE
  --status STATUS
  --worker NAME
  --summary TEXT
  --milestone NAME
  --roadmap-note TEXT
  --next-action TEXT
  --dry-run
  --help
EOF
}

project_root="$PWD"
tracking_mode="local_only"
task_id=""
task_title=""
status=""
worker=""
summary=""
milestone=""
roadmap_note=""
next_action=""
issue_number=""
github_status=""
dry_run=0

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
    --task-title)
      task_title="${2:?missing value for --task-title}"
      shift 2
      ;;
    --status)
      status="${2:?missing value for --status}"
      shift 2
      ;;
    --worker)
      worker="${2:?missing value for --worker}"
      shift 2
      ;;
    --summary)
      summary="${2:?missing value for --summary}"
      shift 2
      ;;
    --milestone)
      milestone="${2:?missing value for --milestone}"
      shift 2
      ;;
    --roadmap-note)
      roadmap_note="${2:?missing value for --roadmap-note}"
      shift 2
      ;;
    --next-action)
      next_action="${2:?missing value for --next-action}"
      shift 2
      ;;
    --issue-number)
      issue_number="${2:?missing value for --issue-number}"
      shift 2
      ;;
    --github-status)
      github_status="${2:?missing value for --github-status}"
      shift 2
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

if [[ -z "$task_id" || -z "$status" || -z "$worker" || -z "$summary" ]]; then
  echo "sync-completion.sh requires --task-id, --status, --worker, and --summary" >&2
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

today="$(date +%F)"
timestamp="$(TZ="${TZ:-Asia/Jakarta}" date '+%F %H:%M %Z')"

resolve_memory_root() {
  local root="$1"
  if [[ -f "$root/memory/PROJECT.md" || -f "$root/memory/TEMPLATE.md" ]]; then
    printf '%s\n' "$root/memory"
  elif [[ -f "$root/PROJECT.md" || -f "$root/TEMPLATE.md" ]]; then
    printf '%s\n' "$root"
  else
    printf '%s\n' "$root/memory"
  fi
}

memory_root="$(resolve_memory_root "$project_root")"
project_md="$memory_root/PROJECT.md"
backlog_md="$memory_root/backlog/BACKLOG.md"
roadmap_md="$memory_root/timeline/ROADMAP.md"

mkdir -p "$memory_root" "$(dirname "$backlog_md")" "$(dirname "$roadmap_md")"

ensure_file() {
  local file="$1"
  local title="$2"
  if [[ ! -f "$file" ]]; then
    printf '# %s\n\n' "$title" > "$file"
  fi
}

ensure_file "$project_md" "Project Memory Bank"
ensure_file "$backlog_md" "Backlog"
ensure_file "$roadmap_md" "Roadmap"

insert_under_heading() {
  local file="$1"
  local heading="$2"
  local entry="$3"
  local tmp
  local entry_file
  tmp="$(mktemp)"
  entry_file="$(mktemp)"
  printf '%s\n' "$entry" > "$entry_file"

  awk -v heading="$heading" -v entry_file="$entry_file" '
    function print_entry() {
      while ((getline line < entry_file) > 0) {
        print line
      }
      close(entry_file)
    }
    BEGIN { inserted = 0 }
    {
      print
      if (!inserted && $0 == heading) {
        print ""
        print_entry()
        print ""
        inserted = 1
      }
    }
    END {
      if (!inserted) {
        if (NR > 0) {
          print ""
        }
        print heading
        print ""
        print_entry()
        print ""
      }
    }
  ' "$file" > "$tmp"

  mv "$tmp" "$file"
  rm -f "$entry_file"
}

replace_quick_ref_value() {
  local file="$1"
  local key="$2"
  local value="$3"
  local tmp
  tmp="$(mktemp)"

  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    {
      if ($0 ~ "^\\|[[:space:]]*" key "[[:space:]]*\\|") {
        print "| " key " | " value " |"
        updated = 1
      } else {
        print
      }
    }
    END {
      if (!updated) {
        print "| " key " | " value " |"
      }
    }
  ' "$file" > "$tmp"

  mv "$tmp" "$file"
}

short_title="$task_title"
if [[ -z "$short_title" ]]; then
  short_title="$task_id"
fi

project_entry="- $timestamp | $task_id | $status | $worker | $short_title
  Summary: $summary
  Tracking: $tracking_mode"

if [[ -n "$issue_number" ]]; then
  project_entry="$project_entry
  GitHub Issue: #$issue_number"
fi

if [[ -n "$github_status" ]]; then
  project_entry="$project_entry
  GitHub Status: $github_status"
fi

if [[ -n "$next_action" ]]; then
  project_entry="$project_entry
  Next: $next_action"
fi

backlog_entry="- $timestamp | $task_id | $status | $worker | $short_title | $summary"

if [[ -n "$issue_number" || -n "$github_status" ]]; then
  if [[ -n "$issue_number" ]]; then
    backlog_entry="$backlog_entry
  GitHub Issue: #$issue_number"
  fi
  if [[ -n "$github_status" ]]; then
    backlog_entry="$backlog_entry
  GitHub Status: $github_status"
  fi
fi

roadmap_entry="- $timestamp | $task_id | $status | ${milestone:-no-milestone}
  Summary: $summary"

if [[ -n "$roadmap_note" ]]; then
  roadmap_entry="$roadmap_entry
  Note: $roadmap_note"
fi

if [[ -n "$issue_number" ]]; then
  roadmap_entry="$roadmap_entry
  GitHub Issue: #$issue_number"
fi

if [[ -n "$github_status" ]]; then
  roadmap_entry="$roadmap_entry
  GitHub Status: $github_status"
fi

if [[ "$dry_run" -eq 1 ]]; then
  echo "PROJECT: $project_md"
  echo "$project_entry"
  echo
  echo "BACKLOG: $backlog_md"
  echo "$backlog_entry"
  if [[ -n "$milestone" || -n "$roadmap_note" ]]; then
    echo
    echo "ROADMAP: $roadmap_md"
    echo "$roadmap_entry"
  fi
  exit 0
fi

insert_under_heading "$project_md" "## AI TEAM Completion Log" "$project_entry"
insert_under_heading "$backlog_md" "## AI TEAM Completion Log" "$backlog_entry"

replace_quick_ref_value "$project_md" "Last Session" "$today"
replace_quick_ref_value "$project_md" "Current Focus" "$status: $short_title"
if [[ -n "$next_action" ]]; then
  replace_quick_ref_value "$project_md" "Next Action" "$next_action"
fi

if [[ -n "$milestone" || -n "$roadmap_note" ]]; then
  insert_under_heading "$roadmap_md" "## AI TEAM Milestone Updates" "$roadmap_entry"
fi

echo "Synced AI TEAM completion state into:"
echo "- $project_md"
echo "- $backlog_md"
if [[ -n "$milestone" || -n "$roadmap_note" ]]; then
  echo "- $roadmap_md"
fi
