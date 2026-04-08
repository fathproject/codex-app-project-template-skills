# AI TEAM Execution Policy

Apply this before deeper routing.

If `memory/PROJECT.md` or `PROJECT.md` already exists, AI TEAM is in `resume_mode=existing_memory`.

In that mode:

- do not bootstrap a replacement memory copy;
- do not overwrite memory unless the user explicitly asks for a forced reset; and
- run `scripts/summarize-memory-state.sh --project-root "$PWD"` before deeper work.

## Tracking Mode

Choose exactly one:

- `github_enabled`
- `local_only`

### `github_enabled`

Use only when the user wants GitHub-connected delivery.

Requirements:

- local `git`
- GitHub authentication by one of:
  - authenticated `gh` CLI
  - GitHub token/PAT
  - GitHub OAuth session
- access to the target repository and GitHub Project

### `local_only`

Use when the user does not want GitHub involved.

Rules:

- keep all tracking in local files;
- do not require `gh`, PAT, OAuth, issues, PRs, or GitHub Projects;
- use local git only if the project wants version control.

Local tracking surfaces:

- `memory/PROJECT.md`
- `backlog/BACKLOG.md`
- `timeline/ROADMAP.md`

## Repository Mode

Choose exactly one:

- `new_repo`
- `existing_repo`
- `local_only_no_remote`

### `new_repo`

Use when a new GitHub-backed repository should be created.

### `existing_repo`

Use when the project already has a usable GitHub repository.

### `local_only_no_remote`

Use when the project should stay off GitHub entirely.

## Tooling Preflight

Check required tools before execution starts.

Use `scripts/preflight-check.sh` as the deterministic enforcement path for this policy.

Before sustained delivery starts, also run:

- `scripts/check-project-onboarding.sh`
- `scripts/validate-github-project-schema.sh` when `github_enabled`
- `scripts/validate-worker-ownership.sh` when multiple workers are active
- `scripts/check-memory-github-drift.sh` when milestone reporting or completion accuracy matters

Always useful:

- `git` when version control is desired
- stack-specific package manager or runtime as detected from the repo

Only when needed:

- `gh` when `github_enabled`
- `docker` or `docker compose` when container workflows are chosen
- language/runtime tools such as `node`, `npm`, `pnpm`, `python`, `uv`, `go`, `cargo`, `java`, or others based on the detected stack

If a required tool is missing, call it out before deeper execution starts.

## Completion Sync Policy

### In `github_enabled`

Every completed task must trigger:

1. local work committed or staged according to the repo workflow;
2. remote push when the branch is meant to exist remotely;
3. issue or PR status update;
4. GitHub Project card move to the correct status; and
5. `memory/PROJECT.md` update;
6. `backlog/BACKLOG.md` update when backlog state changes; and
7. `timeline/ROADMAP.md` update when milestone or timeline state changes.

Scripted enforcement:

- `scripts/sync-github-task.sh` for GitHub issue and GitHub Project updates
- `scripts/sync-completion.sh` for local memory, backlog, and roadmap updates
- `scripts/check-memory-github-drift.sh` for drift detection between GitHub and local memory

### In `local_only`

Every completed task must trigger:

1. local backlog update;
2. `memory/PROJECT.md` update;
3. roadmap or milestone update if affected; and
4. local git commit only if the project wants local version control.

Scripted enforcement:

- `scripts/sync-completion.sh` for local memory, backlog, and roadmap updates

## Operational Loop

For guarded multi-step execution, use `scripts/ai-team-runner.sh` with:

- a task file;
- max iteration limit;
- timeout limit;
- optional continue-on-error behavior; and
- the same tracking policy established at preflight time.

## Preflight Packet

```md
# AI TEAM Preflight Packet

## Tracking Mode
- github_enabled / local_only

## Repository Mode
- new_repo / existing_repo / local_only_no_remote

## Authentication Mode
- gh_cli / token / oauth / none

## Required Tools
- git
- gh
- npm

## Missing Or Blocking Items
- Missing tool 1
- Missing auth 1

## Tracking Surfaces
- GitHub Project
- memory/PROJECT.md
- backlog/BACKLOG.md
- timeline/ROADMAP.md

## Completion Sync Rule
- Exact update rule after every completed task
```
