# Codex Memory Bank Template

A Codex-native port of the `goldfanatictrader/app-template` repository.

This repository is a self-contained project memory bank template plus a reusable Codex skill pack. Copy or clone it into a project as `memory/`, install the skills into Codex, and use the memory bank to preserve project context across sessions.

## What Changed From The OpenCode Version

- OpenCode-specific files under `.opencode/` were ported to Codex-facing files.
- Skills now live in `skills/` instead of `.opencode/skills/`.
- Each skill includes `agents/openai.yaml` metadata for Codex app skill lists and chips.
- Codex install and validation scripts are included in `scripts/`.

## Quick Start

### Option 1: Copy Into A Project

```bash
cp -R codex-app-template /path/to/your-project/memory
cd /path/to/your-project/memory
mv TEMPLATE.md PROJECT.md
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
│   ├── ai-project-manager-orchestrator/
│   ├── ai-team-planner/
│   ├── autonomous-agent/
│   ├── client-intake-normalizer/
│   ├── backlog-management/
│   ├── cicd-delivery/
│   ├── coding-assistant/
│   ├── cross-agent-handover/
│   ├── database-schema-migrations/
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

### Core Workflow

- `skill-router`: choose the smallest effective skill or skill sequence
- `memory-bank`: memory-first session workflow and update rules
- `project-developer`: development workflow combining memory + implementation
- `autonomous-agent`: end-to-end autonomous delivery mode
- `repo-discovery`: fast technical map for unfamiliar repositories
- `review-verification`: review and regression-focused verification pass

### AI Team Orchestration

- `client-intake-normalizer`
- `solution-options-tradeoffs`
- `scope-convergence`
- `ai-project-manager-orchestrator`
- `ai-team-planner`
- `task-assignment-governance`
- `github-traceability-board-sync`
- `cross-agent-handover`

Primary AI-team sequence:

`client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence -> ai-project-manager-orchestrator -> ai-team-planner -> task-assignment-governance -> github-traceability-board-sync -> cross-agent-handover`

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

## Install Skills Into Codex

The repository keeps the skills under `memory/skills/`, but Codex loads local skills from `$CODEX_HOME/skills/` or `~/.codex/skills/`.

Run:

```bash
./scripts/install-skills.sh
```

That script creates symlinks for every skill into your Codex skills directory.

Then start a new Codex thread. `memory-bank` and `project-developer` are configured to allow implicit invocation, while the rest are best invoked explicitly when useful.

Examples:

- `Use $skill-router to choose the right workflow for this task`
- `Use $client-intake-normalizer to structure these client notes`
- `Use $solution-options-tradeoffs to compare solution paths`
- `Use $scope-convergence to define the MVP boundary`
- `Use $ai-project-manager-orchestrator to run this project as an AI PM`
- `Use $ai-team-planner to define the AI team roster`
- `Use $task-assignment-governance to turn the plan into owned AI tasks`
- `Use $github-traceability-board-sync to reflect AI ownership in GitHub`
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
