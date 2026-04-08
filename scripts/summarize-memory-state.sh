#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  summarize-memory-state.sh [options]

Options:
  --project-root PATH
  --help
EOF
}

project_root="$PWD"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="${2:?missing value for --project-root}"
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

if [[ ! -d "$project_root" ]]; then
  echo "Project root does not exist: $project_root" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "summarize-memory-state.sh requires python3." >&2
  exit 1
fi

project_root="$(cd "$project_root" && pwd -P)"

resolve_memory_root() {
  local root="$1"
  if [[ -f "$root/memory/PROJECT.md" ]]; then
    printf '%s\n' "$root/memory"
  elif [[ -f "$root/PROJECT.md" ]]; then
    printf '%s\n' "$root"
  else
    return 1
  fi
}

if ! memory_root="$(resolve_memory_root "$project_root")"; then
  echo "No existing project memory found under $project_root." >&2
  exit 1
fi

project_md="$memory_root/PROJECT.md"
decisions_md="$memory_root/DECISIONS.md"
backlog_md="$memory_root/backlog/BACKLOG.md"
roadmap_md="$memory_root/timeline/ROADMAP.md"

python3 - "$memory_root" "$project_md" "$decisions_md" "$backlog_md" "$roadmap_md" <<'PY'
import re
import sys
from pathlib import Path

memory_root = Path(sys.argv[1])
project_md = Path(sys.argv[2])
decisions_md = Path(sys.argv[3])
backlog_md = Path(sys.argv[4])
roadmap_md = Path(sys.argv[5])


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8") if path.exists() else ""


def parse_table(lines):
    rows = []
    for line in lines:
        if not line.startswith("|"):
            break
        if re.match(r"^\|[-\s|]+\|?$", line):
            continue
        rows.append([part.strip() for part in line.strip().strip("|").split("|")])
    return rows


project_text = read(project_md)
decision_text = read(decisions_md)
project_lines = project_text.splitlines()
decision_lines = decision_text.splitlines()

quick_ref = {}
for idx, line in enumerate(project_lines):
    if line.strip() == "| Item | Value |":
      for row in parse_table(project_lines[idx + 1 : idx + 20]):
        if len(row) >= 2:
          quick_ref[row[0]] = row[1]
      break

recent_sessions = []
for idx, line in enumerate(project_lines):
    if line.strip() == "## Session History":
        rows = parse_table(project_lines[idx + 1 : idx + 30])
        for row in rows[1:]:
            if len(row) >= 5:
                recent_sessions.append(row)
        break

decision_rows = []
for idx, line in enumerate(decision_lines):
    if line.strip() == "## Quick Reference":
        rows = parse_table(decision_lines[idx + 1 : idx + 20])
        for row in rows[1:]:
            if len(row) >= 4 and row[3].lower() == "active":
                decision_rows.append(row)
        break

print("# AI TEAM Latest State Packet")
print()
print("## Resume Mode")
print("- existing_memory")
print("- Bootstrap is not allowed while PROJECT.md already exists")
print()
print("## Current State")
print(f"- Memory root: {memory_root}")
print(f"- Last Session: {quick_ref.get('Last Session', 'unknown')}")
print(f"- Current Focus: {quick_ref.get('Current Focus', 'not set')}")
print(f"- Next Action: {quick_ref.get('Next Action', 'not set')}")
print()
print("## Tracking Files")
print(f"- PROJECT.md: {'present' if project_md.exists() else 'missing'}")
print(f"- DECISIONS.md: {'present' if decisions_md.exists() else 'missing'}")
print(f"- BACKLOG.md: {'present' if backlog_md.exists() else 'missing'}")
print(f"- ROADMAP.md: {'present' if roadmap_md.exists() else 'missing'}")
print()
print("## Recent Sessions")
if recent_sessions:
    for row in recent_sessions[-3:]:
        print(f"- {row[0]} | Session {row[1]} | {row[3]} | {row[4]}")
else:
    print("- none")
print()
print("## Active Decisions")
if decision_rows:
    for row in decision_rows[:5]:
        print(f"- {row[0]} | {row[1]}")
else:
    print("- none")
print()
print("## Immediate Resume Rule")
print("- Read the existing memory state first, then route or execute work from that state.")
PY
