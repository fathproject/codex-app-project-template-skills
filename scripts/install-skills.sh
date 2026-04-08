#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/skills"
target_dir="${CODEX_HOME:-$HOME/.codex}/skills"
mode="${1:-public}"

mkdir -p "$target_dir"

case "$mode" in
  public|"")
    desired_skills=("ai-team")
    ;;
  --all|all)
    desired_skills=()
    for skill_dir in "$source_dir"/*; do
      [[ -d "$skill_dir" ]] || continue
      desired_skills+=("$(basename "$skill_dir")")
    done
    ;;
  *)
    echo "usage: ./scripts/install-skills.sh [public|--all]" >&2
    exit 1
    ;;
esac

for installed_link in "$target_dir"/*; do
  [[ -L "$installed_link" ]] || continue
  resolved_target="$(readlink "$installed_link" || true)"
  case "$resolved_target" in
    "$source_dir"/*)
      keep_link=0
      installed_name="$(basename "$installed_link")"
      for desired_name in "${desired_skills[@]}"; do
        if [[ "$installed_name" == "$desired_name" ]]; then
          keep_link=1
          break
        fi
      done
      if [[ "$keep_link" -eq 0 ]]; then
        rm -f "$installed_link"
        echo "removed $installed_name from $target_dir"
      fi
      ;;
  esac
done

for skill_name in "${desired_skills[@]}"; do
  skill_dir="$source_dir/$skill_name"
  [[ -d "$skill_dir" ]] || continue
  ln -sfn "$skill_dir" "$target_dir/$skill_name"
  echo "linked $skill_name -> $target_dir/$skill_name"
done

echo "installed Codex skills into $target_dir using mode: ${mode/public/public-only}"
