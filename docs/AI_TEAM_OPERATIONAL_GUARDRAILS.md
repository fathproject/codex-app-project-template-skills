# AI TEAM Operational Guardrails

This document defines the operational safeguards that keep AI TEAM disciplined in real projects.

## Guardrail Layer

AI TEAM should not rely on prompt discipline alone.

Use these scripts:

- `scripts/preflight-check.sh`
- `scripts/check-project-onboarding.sh`
- `scripts/validate-github-project-schema.sh`
- `scripts/validate-worker-ownership.sh`
- `scripts/check-memory-github-drift.sh`
- `scripts/sync-completion.sh`
- `scripts/sync-github-task.sh`
- `scripts/ai-team-runner.sh`

## Blind Spots Closed

### GitHub Board Schema Drift

Use `validate-github-project-schema.sh` against the schema file in:

- `skills/ai-team/references/github-project-schema.json`

### Memory Versus GitHub Drift

Use `check-memory-github-drift.sh` after task completion when GitHub mode is enabled.

### Multi-Worker Ownership Drift

Use `validate-worker-ownership.sh` and follow:

- `skills/ai-team/references/multi-worker-ownership.md`

### Project Bootstrap And Onboarding Gaps

Use `check-project-onboarding.sh` before active delivery.

### Missing Baseline Runner

Use `ai-team-runner.sh` as the minimal autonomous execution loop for finite task files.

It is not a full agent platform, but it adds:

- bootstrapping;
- onboarding checks;
- max iteration limits;
- timeout control;
- stop-on-error behavior;
- local completion sync; and
- optional GitHub sync.
