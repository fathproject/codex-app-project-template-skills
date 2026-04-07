---
name: ai-team-planner
description: Use when the project needs a logical AI team roster, role definitions, workstream ownership, and handoff structure sized to the project rather than assumed in advance.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - team-planning
  - orchestration
  - ai-team
tags:
  - ai-team
  - roster
  - planning
  - ownership
---

# AI Team Planner

Use this skill to define the logical AI team for a project.

## Workflow

1. Size the logical team based on scope, risk, and parallel workstreams.
2. Define the roles that are actually needed.
3. Map each role to ownership, dependencies, and review path.
4. Recommend the first assignments.

## Typical Roles

- AI Project Manager
- Architect
- Backend Engineer
- Frontend Engineer
- QA or Release Engineer
- DevOps or Infra Engineer
- Docs or Handover Owner

## Output Contract

Use this roster package:

```md
# AI Team Plan

## Proposed Roster
| AI Worker | AI Role | Owns | Reviews With | Start Condition |
|-----------|---------|------|--------------|-----------------|
| ai-project-manager | project-manager | orchestration | n/a | immediately |
| ai-backend-01 | backend-engineer | auth API | ai-qa-01 | scope approved |
| ai-frontend-01 | frontend-engineer | login UI | ai-qa-01 | API contract stable |

## Workstream Ownership
- Workstream: auth foundation -> ai-backend-01
- Workstream: login UX -> ai-frontend-01

## Dependency Notes
- Frontend waits for API contract
- QA starts after backend and frontend verification

## Review Path
- backend -> qa
- frontend -> qa
- docs -> project manager

## First Assignments
- Assignment 1
- Assignment 2
```

## Output Format

Produce:

1. proposed AI team roster;
2. role responsibilities;
3. workstream ownership map; and
4. recommended first assignments.

## Rules

- Add roles only when they change delivery capacity or risk.
- One person can cover multiple logical AI roles on small projects.
- Large projects still need clear ownership boundaries.
- Every proposed worker should have a start condition, not just a role name.
