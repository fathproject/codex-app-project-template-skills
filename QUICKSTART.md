# Quick Start: Codex Memory Bank Template

This repository is meant to be copied or cloned into a project as `memory/`.

## 1. Add It To A Project

### Copy

```bash
./scripts/bootstrap-memory.sh /path/to/your-project
cd /path/to/your-project/memory
```

### Submodule

```bash
cd /path/to/your-project
git submodule add <your-fork-or-copy-url> memory
cd memory
mv TEMPLATE.md PROJECT.md
```

## 2. Install The Codex Skills

```bash
./scripts/install-skills.sh
```

This installs the public `ai-team` skill into `${CODEX_HOME:-$HOME/.codex}/skills/`.

If you want every internal workflow module exposed separately for maintenance work:

```bash
./scripts/install-skills.sh --all
```

## 3. Customize The Memory Bank

Update:

- `PROJECT.md`
- `context/stack.md`
- `context/architecture.md`
- `context/conventions.md`
- `requirements/*.md`
- `timeline/ROADMAP.md`
- `backlog/BACKLOG.md`

## 4. Verify The Skills

```bash
./scripts/check-skills.sh
```

## 5. Use It In Codex

For a brand new project, start with `$ai-team`. It will bootstrap `./memory/` automatically when the current project does not already have `memory/PROJECT.md` or `PROJECT.md`, and it will initialize a fresh `memory/PROJECT.md` from `TEMPLATE.md`.

AI TEAM should also decide the execution mode up front:

- `github_enabled` if the project should use GitHub issues, boards, and remote version control
- `local_only` if the user does not want GitHub and all tracking should stay local

Even in `github_enabled`, AI TEAM should still update `memory/PROJECT.md`, `backlog/BACKLOG.md`, and `timeline/ROADMAP.md` as part of task completion.

Main AI-team flow reference:

- `docs/AI_TEAM_SKILL_FLOW.md`

Typical prompts:

- `Use $ai-team to bootstrap this project and choose the right workflow`
- `Use $ai-team to report milestone progress and compare AI versus human ETA`
- `Use $ai-team to investigate this codebase before coding`
- `Use $ai-team to run this project as an AI-managed workflow`

## Session Rules

1. Read `PROJECT.md` first.
2. Check `DECISIONS.md` before making architectural changes.
3. Update memory before ending the session.

Internal modules such as `memory-bank`, `project-developer`, and `review-verification` stay in the repo and are meant to be loaded by `ai-team` as needed. They may be installed separately only with `--all`.
