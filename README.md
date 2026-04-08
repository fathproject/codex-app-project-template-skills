# Codex Memory Bank Template

A Codex-native port of the `goldfanatictrader/app-template` repository.

This repository is a self-contained project memory bank template plus a reusable Codex skill pack. Copy or clone it into a project as `memory/`, or let `$ai-team`, `$skill-router`, and `$memory-bank` bootstrap `memory/` automatically into the current project. The bootstrap flow initializes a fresh `memory/PROJECT.md` from `TEMPLATE.md` so each project starts with its own memory history.

## What Changed From The OpenCode Version

- OpenCode-specific files under `.opencode/` were ported to Codex-facing files.
- Skills now live in `skills/` instead of `.opencode/skills/`.
- Each skill includes `agents/openai.yaml` metadata for Codex app skill lists and chips.
- Codex install and validation scripts are included in `scripts/`.

## Quick Start

### Option 1: Copy Into A Project

```bash
./scripts/bootstrap-memory.sh /path/to/your-project
cd /path/to/your-project/memory
./scripts/install-skills.sh
```

### Option 2: Use As A Git Submodule

```bash
cd /path/to/your-project
git submodule add <your-fork-or-copy-url> memory
cd memory
mv TEMPLATE.md PROJECT.md
./scripts/install-skills.sh
```

## Repository Layout

```text
memory/
├── AGENTS.md
├── CODEX.md
├── QUICKSTART.md
├── PROJECT.md
├── TEMPLATE.md
├── DECISIONS.md
├── MEETINGS.md
├── GLOSSARY.md
├── backlog/
│   └── BACKLOG.md
├── context/
│   ├── architecture.md
│   ├── conventions.md
│   ├── environments.md
│   ├── stack.md
│   └── workflows.md
├── docs/
│   ├── API.md
│   ├── DEPLOYMENT.md
│   ├── ONBOARDING.md
│   └── README.md
├── requirements/
│   ├── BRD.md
│   ├── CHARTER.md
│   └── USER_STORIES.md
├── skills/
│   ├── ai-team/
│   ├── ai-project-manager-orchestrator/
│   ├── ai-team-planner/
│   ├── autonomous-agent/
│   ├── client-intake-normalizer/
│   ├── backlog-management/
│   ├── cicd-delivery/
│   ├── coding-assistant/
│   ├── cross-agent-handover/
│   ├── database-schema-migrations/
│   ├── delivery-analytics-forecast/
│   ├── debugging-incident/
│   ├── docs-sync-handover/
│   ├── docker-setup/
│   ├── frontend-ui-states/
│   ├── github-traceability-board-sync/
│   ├── github-integration/
│   ├── github-projects/
│   ├── infra-environments/
│   ├── memory-bank/
│   ├── observability-monitoring/
│   ├── api-contract-integration/
│   ├── auth-identity/
│   ├── project-developer/
│   ├── project-initialization/
│   ├── project-manager/
│   ├── qa-e2e-release/
│   ├── repo-discovery/
│   ├── requirements-analysis/
│   ├── review-verification/
│   ├── security-production-readiness/
│   ├── skill-router/
│   ├── solution-options-tradeoffs/
│   ├── scope-convergence/
│   ├── task-assignment-governance/
│   ├── team-roles/
│   ├── team-setup/
│   └── timeline-roadmap/
├── team/
│   └── ROLES.md
├── timeline/
│   └── ROADMAP.md
└── scripts/
    ├── check-skills.sh
    └── install-skills.sh
```

## Codex Skills Included

### Public Skill

- `ai-team`: primary entry point for the AI TEAM skill pack

By default, this is the only skill installed into Codex from this repository.

### Internal Workflow Modules

The repo still keeps the underlying workflow modules as separate folders for maintainability, but they are intended to run under `ai-team` unless you explicitly install all skills.

### AI Team Orchestration

- `client-intake-normalizer`
- `solution-options-tradeoffs`
- `scope-convergence`
- `ai-project-manager-orchestrator`
- `ai-team-planner`
- `task-assignment-governance`
- `github-traceability-board-sync`
- `delivery-analytics-forecast`
- `cross-agent-handover`

Primary AI-team sequence:

`ai-team -> client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence -> ai-project-manager-orchestrator -> ai-team-planner -> task-assignment-governance -> github-traceability-board-sync -> delivery-analytics-forecast -> cross-agent-handover`

Full active flow reference: [docs/AI_TEAM_SKILL_FLOW.md](docs/AI_TEAM_SKILL_FLOW.md)

### Project Management

- `project-manager`
- `project-initialization`
- `requirements-analysis`
- `team-setup`
- `team-roles`
- `timeline-roadmap`
- `backlog-management`

These are now mostly supporting or legacy PM skills around the AI-team core flow.

### Delivery And Operations

- `github-integration`
- `github-projects`
- `docker-setup`
- `cicd-delivery`
- `infra-environments`
- `observability-monitoring`
- `security-production-readiness`
- `qa-e2e-release`
- `debugging-incident`
- `database-schema-migrations`

### Coding

- `coding-assistant`
- `api-contract-integration`
- `auth-identity`
- `frontend-ui-states`
- `docs-sync-handover`

The active skills are designed to pass structured output packets between one another rather than relying on loose prose alone.

## Install Skills Into Codex

The repository keeps the skills under `memory/skills/`, but Codex loads local skills from `$CODEX_HOME/skills/` or `~/.codex/skills/`.

Run:

```bash
./scripts/install-skills.sh
```

That script installs the public AI TEAM skill only.

If you are maintaining the pack and want every internal module exposed separately, run:

```bash
./scripts/install-skills.sh --all
```

For a fresh project, use `$ai-team` as the first skill entry point. It bootstraps `./memory/` from this template automatically when the current project has neither `./memory/PROJECT.md` nor `./PROJECT.md`.

`$skill-router` remains available in the repo as a routing alias, but it is not installed publicly by default.

`$ai-team` also establishes execution policy before deeper work starts:

- `github_enabled` when the project should sync to GitHub
- `local_only` when tracking should stay fully local

If GitHub is enabled, completed work should sync the GitHub Project card immediately and still update local memory, backlog, and roadmap. If GitHub is disabled, tracking stays in local memory, backlog, roadmap, and optional local git.

AI TEAM now includes deterministic enforcement scripts:

- `./scripts/preflight-check.sh` to verify required tools and GitHub readiness
- `./scripts/check-project-onboarding.sh` to verify memory, GitHub templates, and onboarding readiness
- `./scripts/validate-github-project-schema.sh` to verify GitHub Project fields and status options
- `./scripts/validate-worker-ownership.sh` to verify branch naming and commit trailers per worker
- `./scripts/check-memory-github-drift.sh` to compare local memory against GitHub tracking state
- `./scripts/sync-completion.sh` to update local memory, backlog, and roadmap on task completion
- `./scripts/sync-github-task.sh` to update GitHub issue and GitHub Project state when GitHub mode is enabled
- `./scripts/ai-team-runner.sh` to run a guarded finite execution loop from a TSV task file

Operational guardrail reference: [docs/AI_TEAM_OPERATIONAL_GUARDRAILS.md](docs/AI_TEAM_OPERATIONAL_GUARDRAILS.md)

Then start a new Codex thread. `memory-bank` and `project-developer` are configured to allow implicit invocation, while the rest are best invoked explicitly when useful.

Examples:

- `Use $ai-team to bootstrap this project and choose the right workflow`
- `Use $skill-router to choose the right workflow for this task`
- `Use $client-intake-normalizer to structure these client notes`
- `Use $solution-options-tradeoffs to compare solution paths`
- `Use $scope-convergence to define the MVP boundary`
- `Use $ai-project-manager-orchestrator to run this project as an AI PM`
- `Use $ai-team-planner to define the AI team roster`
- `Use $task-assignment-governance to turn the plan into owned AI tasks`
- `Use $github-traceability-board-sync to reflect AI ownership in GitHub`
- `Use $delivery-analytics-forecast to report milestone progress and ETA`
- `Use $cross-agent-handover to hand work from one AI role to another`
- `Use $backlog-management to turn approved scope into delivery backlog slices`
- `Use $memory-bank before we continue`
- `Use $project-developer to implement the next feature`
- `Use $repo-discovery to map this codebase first`
- `Use $review-verification to review the latest changes`
- `Use $debugging-incident to diagnose a production issue`
- `Use $qa-e2e-release to check release readiness`
- `Use $security-production-readiness before shipping`
- `Use $autonomous-agent to drive this project from planning to delivery`

## Recommended Workflow

1. Read `PROJECT.md` before making changes.
2. Check `DECISIONS.md` for prior rationale.
3. Review `context/conventions.md` before coding.
4. Use the relevant Codex skill for the task.
5. Update `PROJECT.md` and `DECISIONS.md` before ending the session.

## Validation

Run:

```bash
./scripts/check-skills.sh
```

This verifies that every migrated skill has the required `SKILL.md` and `agents/openai.yaml` files.

## Source

Based on: [goldfanatictrader/app-template](https://github.com/goldfanatictrader/app-template)
