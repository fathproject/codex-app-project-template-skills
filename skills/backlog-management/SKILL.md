---
name: backlog-management
description: Use when approved scope must be turned into prioritized backlog slices that can be assigned to logical AI workers and tracked through GitHub.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - backlog
  - github
  - project-management
  - sprint
tags:
  - backlog
  - github-issues
  - github-projects
  - sprint
  - agile
---

# Backlog Management Skill

Use this skill when scope must be converted into a delivery backlog that the AI team can actually execute and track.

## Position In The AI Team Stack

Use this after:

1. `scope-convergence`
2. `ai-project-manager-orchestrator`
3. `ai-team-planner`

Then connect it with:

4. `task-assignment-governance`
5. `github-traceability-board-sync`

## Goals

1. Turn scope into prioritized backlog slices.
2. Keep backlog items small enough to assign, review, and ship.
3. Align backlog items with AI workers, dependencies, and delivery phases.

## Workflow

1. Start from approved MVP or phased scope.
2. Separate backlog items by delivery priority and dependency order.
3. Break epics into assignable issue-sized tasks.
4. Ensure each item can be mapped to the AI task issue template.
5. Mark what is ready now versus blocked by upstream decisions.

## Output Contract

Use this structure:

```md
# Delivery Backlog

## P0 Now
- Item
- Owner role
- Depends on

## P1 Next
- Item
- Owner role
- Depends on

## Deferred
- Item
- Reason deferred

## Epic Breakdown
- Epic -> Task 1 -> Task 2 -> Task 3

## Ready For Issue Creation
- Which items can be turned into AI tasks immediately

## Blocked Items
- Item
- Blocking dependency
```

## Required References

- `.github/ISSUE_TEMPLATE/ai-task.md`
- `docs/AI_TEAM_GITHUB_OPERATIONS.md`

## Rules

- Do not keep backlog items too broad for ownership.
- Priority must reflect dependency and delivery value, not just stakeholder desire.
- A backlog item is not ready if it cannot be assigned to a logical AI owner.
