---
name: ai-team
description: Use as the primary entry point for this skill pack when starting a fresh project, resuming a project with this operating model, or asking AI TEAM to choose the right workflow and next skills.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - routing
  - orchestration
  - ai-team
tags:
  - ai-team
  - entry-point
  - routing
  - bootstrap
---

# AI TEAM

Use this as the first-call skill for the AI TEAM skill pack.

This is the only public skill that should normally be installed into Codex from this repository.

Other skills in the repo are internal workflow modules for AI TEAM, not separate public entry points by default.

Its job is to:

1. bootstrap project memory when needed;
2. establish execution policy and preflight requirements;
3. classify the current request;
4. choose the smallest valid AI-team workflow; and
5. tell the next skill clearly.

## Deterministic Enforcement

AI TEAM should not rely on policy prose alone when deterministic tooling is available.

Use the bundled scripts under `scripts/`:

- `scripts/bootstrap-memory.sh "$PWD"` to create `./memory/` when missing
- `scripts/preflight-check.sh --project-root "$PWD" ...` to verify tool and auth readiness
- `scripts/sync-completion.sh --project-root "$PWD" ...` to write local completion state into memory, backlog, and roadmap
- `scripts/sync-github-task.sh ...` to update the GitHub issue and GitHub Project card when `tracking_mode=github_enabled`

Treat these scripts as the preferred enforcement mechanism whenever AI TEAM is operating inside a writable local project.

## Entry Point Workflow

Before routing:

1. Check whether `./memory/PROJECT.md` or `./PROJECT.md` already exists.
2. If neither exists, bootstrap `./memory/` immediately by running the bundled `scripts/bootstrap-memory.sh "$PWD"`.
3. Read `memory/PROJECT.md` or `PROJECT.md`.
4. Apply the execution policy from `references/execution-policy.md`.
5. Run `scripts/preflight-check.sh` before deeper execution whenever tools or GitHub access matter.
5. Route only after project memory exists and execution policy is known.

This skill should reduce setup friction. Do not ask the user whether memory should be created first.

## Execution Policy

AI TEAM must establish these values before deeper work starts:

1. `tracking_mode`
   - `github_enabled`
   - `local_only`
2. `repository_mode`
   - `new_repo`
   - `existing_repo`
   - `local_only_no_remote`
3. `authentication_mode`
   - `gh_cli`
   - `token`
   - `oauth`
   - `none`
4. `required_tools`
   - detect from the repo stack and chosen workflow

Use [references/execution-policy.md](./references/execution-policy.md) as the canonical policy.

### Policy Rules

- If the user says they do not want GitHub, force `tracking_mode=local_only`.
- If `tracking_mode=local_only`, do not require GitHub auth and do not route into GitHub-only setup work.
- If the project is new and GitHub is enabled, use `repository_mode=new_repo`.
- If the project already has a usable GitHub repository, use `repository_mode=existing_repo`.
- If GitHub is enabled, every completed task must call `scripts/sync-github-task.sh` for issue and board state and `scripts/sync-completion.sh` for local memory state.
- If GitHub is disabled, all tracking must remain local in memory, backlog, roadmap, and optional local git.
- If a required tool or GitHub auth is missing, stop and surface the blocker instead of pretending the workflow can continue cleanly.

## Internal Workflow Modules

When AI TEAM needs deeper guidance, load only the relevant internal module from the sibling skill docs:

- planning and scope:
  - `../client-intake-normalizer/SKILL.md`
  - `../solution-options-tradeoffs/SKILL.md`
  - `../scope-convergence/SKILL.md`
- orchestration and team operations:
  - `../ai-project-manager-orchestrator/SKILL.md`
  - `../ai-team-planner/SKILL.md`
  - `../backlog-management/SKILL.md`
  - `../task-assignment-governance/SKILL.md`
  - `../github-traceability-board-sync/SKILL.md`
  - `../cross-agent-handover/SKILL.md`
- implementation and specialist work:
  - `../memory-bank/SKILL.md`
  - `../repo-discovery/SKILL.md`
  - `../project-developer/SKILL.md`
  - domain modules such as `../api-contract-integration/SKILL.md`, `../auth-identity/SKILL.md`, `../frontend-ui-states/SKILL.md`, `../infra-environments/SKILL.md`, `../database-schema-migrations/SKILL.md`, and `../observability-monitoring/SKILL.md`
- validation and release:
  - `../review-verification/SKILL.md`
  - `../qa-e2e-release/SKILL.md`
  - `../security-production-readiness/SKILL.md`
  - `../docs-sync-handover/SKILL.md`
- delivery oversight:
  - `../delivery-analytics-forecast/SKILL.md`
- setup and GitHub enablement when policy requires it:
  - `../github-integration/SKILL.md`
  - `../github-projects/SKILL.md`
  - `../project-initialization/SKILL.md`

Do not load all internal modules at once. Load only the minimum module needed for the current phase.

## Preferred Routing Paths

Prefer the shortest path that solves the task cleanly.

- Fresh project or unclear starting point: `memory-bank -> ai-team`
- Raw client materials: `client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence`
- AI-managed planning: `client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence -> ai-project-manager-orchestrator -> ai-team-planner`
- GitHub-connected managed execution: `ai-project-manager-orchestrator -> ai-team-planner -> task-assignment-governance -> github-traceability-board-sync`
- Local-only managed execution: `ai-project-manager-orchestrator -> ai-team-planner -> backlog-management -> task-assignment-governance`
- Normal implementation: `memory-bank -> project-developer`
- Existing unfamiliar codebase: `repo-discovery -> memory-bank -> project-developer`
- Review or regression check: `memory-bank -> review-verification`
- Incident or hard bug: `memory-bank -> debugging-incident`
- Release gate: `review-verification -> qa-e2e-release -> security-production-readiness`
- Delivery progress and ETA: `ai-project-manager-orchestrator -> github-traceability-board-sync -> delivery-analytics-forecast`
- Documentation closure: `docs-sync-handover -> memory-bank`

## Selection Rules

- Prefer the active AI-team flow over legacy PM skills.
- Use `memory-bank` in most continuity-sensitive paths.
- Add `github-traceability-board-sync` whenever ownership or board visibility matters.
- Add `github-integration` or `github-projects` only when `tracking_mode=github_enabled`.
- Add `delivery-analytics-forecast` whenever milestone progress, ETA, or AI-versus-human comparison is requested.
- If a single skill fully covers the task, do not add more.

## Backward Compatibility

`skill-router` remains available as a routing alias and supporting skill.

Advanced maintainers can still install every internal module explicitly with `./scripts/install-skills.sh --all`, but the default public installation should expose `ai-team` only.

## Output Contract

Use this routing and preflight packet:

```md
# AI TEAM Routing Packet

## Execution Policy
- Tracking mode
- Repository mode
- Authentication mode
- Required tools
- Missing or blocking items

## Task Classification
- planning / implementation / review / incident / release / analytics / docs / infra

## Selected Skill Path
1. Skill 1
2. Skill 2
3. Skill 3

## Why This Path
- Reason 1
- Reason 2

## Immediate Next Action
- Exact first move
```

## Rules

- Bootstrap memory first if the project has none yet.
- Establish execution policy before deeper routing.
- Route first, then work.
- Prefer fewer skills over more skills.
- Keep the next skill explicit.
- Treat sibling skills as internal modules under AI TEAM unless the maintainer explicitly installs them with `--all`.
- If GitHub is enabled, every completed task must update the GitHub Project card immediately and also update local memory files.
- If GitHub is disabled, all task tracking must remain local.
