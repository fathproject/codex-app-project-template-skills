#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  preflight-check.sh [options]

Options:
  --project-root PATH
  --tracking-mode github_enabled|local_only
  --repository-mode new_repo|existing_repo|local_only_no_remote
  --auth-mode auto|gh_cli|token|oauth|none
  --tools tool1,tool2
  --help
EOF
}

project_root="$PWD"
tracking_mode="local_only"
repository_mode=""
auth_mode="auto"
extra_tools_csv=""

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
    --tools)
      extra_tools_csv="${2:?missing value for --tools}"
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

project_root="$(cd "$project_root" && pwd -P)"

case "$tracking_mode" in
  github_enabled|local_only) ;;
  *)
    echo "Invalid tracking mode: $tracking_mode" >&2
    exit 1
    ;;
esac

case "$auth_mode" in
  auto|gh_cli|token|oauth|none) ;;
  *)
    echo "Invalid auth mode: $auth_mode" >&2
    exit 1
    ;;
esac

has_item() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    if [[ "$item" == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

push_unique() {
  local array_name="$1"
  local value="$2"
  eval "local current=(\"\${${array_name}[@]-}\")"
  if has_item "$value" "${current[@]}"; then
    return 0
  fi
  eval "${array_name}+=(\"\$value\")"
}

declare -a required_tools=()
declare -a missing_items=()
declare -a tracking_surfaces=()
declare -a detected_notes=()

if [[ -z "$repository_mode" ]]; then
  if [[ "$tracking_mode" == "github_enabled" ]]; then
    if [[ -d "$project_root/.git" ]]; then
      repository_mode="existing_repo"
    else
      repository_mode="new_repo"
    fi
  else
    repository_mode="local_only_no_remote"
  fi
fi

case "$repository_mode" in
  new_repo|existing_repo|local_only_no_remote) ;;
  *)
    echo "Invalid repository mode: $repository_mode" >&2
    exit 1
    ;;
esac

if [[ "$tracking_mode" == "github_enabled" || -d "$project_root/.git" ]]; then
  push_unique required_tools "git"
fi

if [[ -f "$project_root/package.json" ]]; then
  push_unique required_tools "node"
  if [[ -f "$project_root/pnpm-lock.yaml" ]]; then
    push_unique required_tools "pnpm"
  elif [[ -f "$project_root/yarn.lock" ]]; then
    push_unique required_tools "yarn"
  elif [[ -f "$project_root/bun.lockb" || -f "$project_root/bun.lock" ]]; then
    push_unique required_tools "bun"
  else
    push_unique required_tools "npm"
  fi
  detected_notes+=("Detected Node.js project from package.json")
fi

if [[ -f "$project_root/pyproject.toml" || -f "$project_root/requirements.txt" ]]; then
  push_unique required_tools "python3"
  if [[ -f "$project_root/uv.lock" ]]; then
    push_unique required_tools "uv"
  elif [[ -f "$project_root/poetry.lock" ]]; then
    push_unique required_tools "poetry"
  elif [[ -f "$project_root/Pipfile" ]]; then
    push_unique required_tools "pipenv"
  fi
  detected_notes+=("Detected Python project from pyproject.toml or requirements.txt")
fi

if [[ -f "$project_root/go.mod" ]]; then
  push_unique required_tools "go"
  detected_notes+=("Detected Go project from go.mod")
fi

if [[ -f "$project_root/Cargo.toml" ]]; then
  push_unique required_tools "cargo"
  detected_notes+=("Detected Rust project from Cargo.toml")
fi

if [[ -f "$project_root/pom.xml" ]]; then
  push_unique required_tools "java"
  push_unique required_tools "mvn"
  detected_notes+=("Detected Maven project from pom.xml")
fi

if [[ -f "$project_root/build.gradle" || -f "$project_root/build.gradle.kts" || -f "$project_root/gradlew" ]]; then
  push_unique required_tools "java"
  detected_notes+=("Detected Gradle project from build.gradle or gradlew")
fi

if [[ -f "$project_root/composer.json" ]]; then
  push_unique required_tools "php"
  push_unique required_tools "composer"
  detected_notes+=("Detected PHP project from composer.json")
fi

if [[ -f "$project_root/Dockerfile" || -f "$project_root/docker-compose.yml" || -f "$project_root/docker-compose.yaml" || -f "$project_root/compose.yml" || -f "$project_root/compose.yaml" ]]; then
  push_unique required_tools "docker"
  detected_notes+=("Detected container workflow from Dockerfile or compose file")
fi

if [[ -n "$extra_tools_csv" ]]; then
  OLD_IFS="$IFS"
  IFS=','
  for tool in $extra_tools_csv; do
    tool="${tool## }"
    tool="${tool%% }"
    if [[ -n "$tool" ]]; then
      push_unique required_tools "$tool"
    fi
  done
  IFS="$OLD_IFS"
fi

if [[ "$tracking_mode" == "github_enabled" ]]; then
  push_unique required_tools "gh"
  tracking_surfaces=("GitHub repository" "GitHub Project" "memory/PROJECT.md" "backlog/BACKLOG.md" "timeline/ROADMAP.md")
else
  tracking_surfaces=("memory/PROJECT.md" "backlog/BACKLOG.md" "timeline/ROADMAP.md")
fi

tool_name_for_command() {
  case "$1" in
    node) echo "node" ;;
    python3) echo "python3" ;;
    java) echo "java" ;;
    mvn) echo "mvn" ;;
    cargo) echo "cargo" ;;
    composer) echo "composer" ;;
    docker) echo "docker" ;;
    bun) echo "bun" ;;
    *) echo "$1" ;;
  esac
}

if [[ -n "${required_tools[*]-}" ]]; then
  for tool in "${required_tools[@]}"; do
    command_name="$(tool_name_for_command "$tool")"
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing_items+=("Missing tool: $tool")
    fi
  done
fi

detected_auth="none"
if [[ "$tracking_mode" == "github_enabled" ]]; then
  gh_available=0
  if command -v gh >/dev/null 2>&1; then
    gh_available=1
  fi

  case "$auth_mode" in
    auto)
      if [[ -n "${GH_TOKEN:-}" || -n "${GITHUB_TOKEN:-}" ]]; then
        detected_auth="token"
      elif [[ "$gh_available" -eq 1 ]] && gh auth status >/dev/null 2>&1; then
        detected_auth="gh_cli"
      else
        missing_items+=("Missing GitHub authentication: provide GH_TOKEN/GITHUB_TOKEN or run gh auth login")
      fi
      ;;
    token)
      detected_auth="token"
      if [[ -z "${GH_TOKEN:-}" && -z "${GITHUB_TOKEN:-}" ]]; then
        missing_items+=("Missing GitHub token in GH_TOKEN or GITHUB_TOKEN")
      fi
      ;;
    gh_cli|oauth)
      detected_auth="$auth_mode"
      if [[ "$gh_available" -ne 1 ]]; then
        missing_items+=("Missing tool: gh")
      elif ! gh auth status >/dev/null 2>&1; then
        missing_items+=("GitHub CLI is not authenticated")
      fi
      ;;
    none)
      missing_items+=("Authentication mode 'none' is invalid when tracking_mode=github_enabled")
      ;;
  esac
fi

echo "# AI TEAM Preflight Packet"
echo
echo "## Tracking Mode"
echo "- $tracking_mode"
echo
echo "## Repository Mode"
echo "- $repository_mode"
echo
echo "## Authentication Mode"
echo "- $detected_auth"
echo
echo "## Required Tools"
if [[ -z "${required_tools[*]-}" ]]; then
  echo "- none"
else
  for tool in "${required_tools[@]}"; do
    echo "- $tool"
  done
fi
echo
echo "## Missing Or Blocking Items"
if [[ -z "${missing_items[*]-}" ]]; then
  echo "- none"
else
  for item in "${missing_items[@]}"; do
    echo "- $item"
  done
fi
echo
echo "## Tracking Surfaces"
for surface in "${tracking_surfaces[@]}"; do
  echo "- $surface"
done
echo
echo "## Completion Sync Rule"
if [[ "$tracking_mode" == "github_enabled" ]]; then
  echo "- Every completed task must update GitHub issue state, the GitHub Project card, and the local memory files."
else
  echo "- Every completed task must update the local memory files and optional local git state."
fi

if [[ -n "${detected_notes[*]-}" ]]; then
  echo
  echo "## Detection Notes"
  for note in "${detected_notes[@]}"; do
    echo "- $note"
  done
fi

if [[ -n "${missing_items[*]-}" ]]; then
  exit 1
fi
