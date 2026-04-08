---
name: github-traceability-board-sync
description: Use when AI-managed work must be reflected clearly in GitHub issues, pull requests, project fields, labels, and board state so ownership and progress remain auditable with one shared GitHub account.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - github
  - traceability
  - board
tags:
  - github
  - traceability
  - project-board
  - metadata
---

# GitHub Traceability Board Sync

Use this skill when logical AI roles must remain visible in GitHub even though the actual GitHub account is shared.

## Goals

1. Make AI ownership visible in issues and board items.
2. Keep GitHub status aligned with the real work state.
3. Preserve auditability for task flow, review, and handoff.
4. Force every completed task to sync its GitHub board card immediately.

## Mode Gate

Use this skill only when `tracking_mode=github_enabled`.

If the user wants local-only tracking, do not use this skill. Keep tracking in local memory and backlog files instead.

## Recommended Metadata

Track fields such as:

- `AI Worker`
- `AI Role`
- `Managed By`
- `Review Owner`
- `Depends On`
- `Risk`
- `Workstream`

Also use consistent:

- branch naming;
- PR title and body conventions;
- commit trailers; and
- issue labels or status mapping.

## Workflow

1. Map the logical AI roster to GitHub metadata.
2. Ensure each issue or board item carries the required ownership fields.
3. Sync task state changes to board movement and review state.
4. Keep branch, PR, and issue references consistent.
5. Hand milestone and status data cleanly to `delivery-analytics-forecast` when quantified progress or ETA reporting is needed.
6. When a task is completed, push the completion state into GitHub immediately:
   - update the issue or PR;
   - move the GitHub Project card; and
   - preserve logical AI ownership metadata.
7. Require the matching local memory and planning updates to happen in parallel with the GitHub sync.

Use these repo artifacts directly:

- `.github/ISSUE_TEMPLATE/ai-task.md`
- `.github/pull_request_template.md`
- `docs/AI_TEAM_GITHUB_OPERATIONS.md`

## Output Contract

Use this traceability packet:

```md
# Traceability Packet

## Required Fields
- Field 1
- Field 2

## Naming And Metadata Rules
- Branch naming
- PR body convention
- Commit trailer convention

## Status Sync Rules
- Issue opened -> Backlog
- Work started -> In Progress
- PR opened -> In Review
- Task completed -> move the card immediately to the correct completion state

## Traceability Gaps
- Gap 1
- Gap 2

## Recommended Next Step
- Usually: `$delivery-analytics-forecast`, `$cross-agent-handover`, or active execution skills
```

## Output Format

Produce:

1. required GitHub fields;
2. naming conventions;
3. sync rules for status changes; and
4. traceability gaps that need fixing.

## Rules

- One shared GitHub account is fine, but logical AI identity must still be explicit.
- GitHub should show who logically owns the task, not just who pushed the commit.
- Traceability should be consistent across issue, board, branch, and PR.
- If board metadata and issue metadata disagree, call out the mismatch directly.
- Completion sync should happen as part of finishing the task, not batched later.
- GitHub sync does not replace local project memory; both should be kept aligned.
