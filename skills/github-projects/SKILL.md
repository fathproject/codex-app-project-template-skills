---
name: github-projects
description: Use when GitHub Project fields and workflow states must be created or corrected so the AI-team board matches the logical ownership model.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - github
  - projects
  - kanban
  - automation
tags:
  - github-projects
  - kanban
  - automation
  - task-management
---

# GitHub Projects Skill

Use this skill when GitHub Project structure itself must be created or corrected for AI-team delivery.

## Position In The AI Team Stack

This is a supporting board-setup skill.

For day-to-day AI execution, prefer `github-traceability-board-sync`.

## Goals

1. Create or align the GitHub Project board with the AI-team workflow.
2. Make project fields and statuses match the logical AI ownership model.
3. Ensure issues can move through the board without losing traceability.

## Required Board Model

Use `docs/AI_TEAM_GITHUB_OPERATIONS.md`.

Required fields:

- `Status`
- `AI Worker`
- `AI Role`
- `Managed By`
- `Review Owner`
- `Workstream`
- `Priority`
- `Risk`
- `Depends On`
- `Phase`
- `Next Handoff`

Recommended statuses:

1. `Backlog`
2. `Ready`
3. `In Progress`
4. `In Review`
5. `In QA`
6. `In Handover`
7. `Blocked`
8. `Done`

## Workflow

1. Inspect the current GitHub Project structure.
2. Compare it against the required fields and statuses.
3. Add missing fields or rename conflicting ones where practical.
4. Ensure issue intake and PR review can map to the board cleanly.
5. Hand off ongoing sync behavior to `github-traceability-board-sync`.

## Output Contract

Produce:

1. current board status;
2. missing fields;
3. missing statuses;
4. naming mismatches; and
5. next sync action.

## Rules

- Do not use old classic-project assumptions.
- The board must reflect logical AI ownership, not just generic kanban movement.
- If the board already matches the AI-team model, stop and hand off.
