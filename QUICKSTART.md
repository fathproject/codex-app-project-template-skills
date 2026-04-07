# Quick Start: Codex Memory Bank Template

This repository is meant to be copied or cloned into a project as `memory/`.

## 1. Add It To A Project

### Copy

```bash
cp -R codex-app-template /path/to/your-project/memory
cd /path/to/your-project/memory
mv TEMPLATE.md PROJECT.md
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

This links each folder in `skills/` into `${CODEX_HOME:-$HOME/.codex}/skills/`.

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

Typical prompts:

- `Use $memory-bank and tell me what to do next`
- `Use $project-developer to implement authentication`
- `Use $repo-discovery to inspect this repository before coding`
- `Use $requirements-analysis to turn this idea into a BRD and user stories`
- `Use $review-verification to review the latest diff for regressions`
- `Use $autonomous-agent to drive the project from planning to delivery`

## Session Rules

1. Read `PROJECT.md` first.
2. Check `DECISIONS.md` before making architectural changes.
3. Update memory before ending the session.

`memory-bank` and `project-developer` may be used implicitly by Codex because they are configured for automatic invocation.
