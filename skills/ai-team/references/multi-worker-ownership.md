# AI TEAM Multi-Worker Ownership Protocol

Use this protocol whenever more than one logical AI worker may touch the same repository.

## Goals

- keep ownership explicit;
- reduce merge collisions;
- make reviews auditable; and
- keep manager, worker, and reviewer boundaries visible.

## Required Conventions

### Branches

Each worker branch should follow:

```text
ai/<worker>/<task-id>-<short-scope>
```

Examples:

```text
ai/backend-01/123-login-api
ai/frontend-01/124-login-screen
ai/qa-01/125-auth-regression
```

### Commit Trailers

Every worker-owned commit should include:

```text
AI-Worker: ai-backend-01
AI-Role: backend-engineer
Managed-By: ai-project-manager
Task-ID: 123
```

### Task Ownership

Each task should have:

- exactly one primary `AI Worker`;
- exactly one `Managed By` owner;
- one `Review Owner`;
- a declared `Next Handoff`; and
- clear dependency references.

### File Ownership

When possible, assign workers to disjoint areas:

- backend worker: service and API files
- frontend worker: UI and state files
- QA worker: tests and verification artifacts
- docs worker: docs and memory sync

If disjoint ownership is impossible, require:

1. a shared handoff note;
2. a fresh review pass; and
3. an explicit conflict resolution decision in memory.

## Enforcement Scripts

Use:

- `scripts/validate-worker-ownership.sh`
- `scripts/check-memory-github-drift.sh`
- `scripts/check-project-onboarding.sh`

These scripts make ownership, traceability, and drift checks reproducible.
