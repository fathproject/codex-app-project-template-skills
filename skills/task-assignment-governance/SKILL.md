---
name: task-assignment-governance
description: Use when AI-managed work must be broken into owned tasks with clear assignees, reviewers, dependencies, escalation rules, and status transitions before execution starts.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - governance
  - assignment
  - orchestration
tags:
  - task-assignment
  - governance
  - ownership
  - dependencies
---

# Task Assignment Governance

Use this skill when AI work must be assigned in a disciplined way rather than as a vague task list.

## Goals

1. Turn scope into assignable work units.
2. Define owner, reviewer, dependency, and escalation path for each task.
3. Make status transitions explicit so the AI PM can manage progress.
4. Make completion-sync responsibility explicit for either GitHub or local-only tracking.

## Workflow

1. Break scope into tasks small enough to own and review.
2. Assign each task a logical AI worker and role.
3. Use `.github/ISSUE_TEMPLATE/ai-task.md` as the default task structure.
4. Define:
   - owner;
   - reviewer;
   - dependency list;
   - blocker escalation path; and
   - definition of done.
5. Separate parallel work from sequential work.
6. Mark tasks that should not start until prerequisites are complete.
7. Define the completion-sync action:
   - GitHub issue and project update plus local memory, backlog, and milestone update when `tracking_mode=github_enabled`; or
   - local backlog and memory update when `tracking_mode=local_only`.

Use [docs/AI_TEAM_GITHUB_OPERATIONS.md](../../docs/AI_TEAM_GITHUB_OPERATIONS.md) when the GitHub board conventions need to be applied consistently.

## Output Contract

Use this assignment packet:

```md
# Assignment Packet

## Task Table
| Task | Owner | Reviewer | Depends On | Start Condition | Next Handoff |
|------|-------|----------|------------|-----------------|--------------|
| ... | ... | ... | ... | ... | ... |

## Dependency Map
- Task A -> Task B
- Task C -> Task D

## Status Flow
- Ready
- In Progress
- In Review
- In QA

## Completion Sync
- Task done -> update GitHub card immediately
- Task done -> also update local memory and planning files when GitHub is enabled
- or Task done -> update local backlog and memory immediately

## Escalation Rules
- If blocked by contract -> AI PM
- If blocked by infra -> infra owner

## Recommended Next Step
- Usually: `$github-traceability-board-sync`
```

## Output Format

Produce:

1. task list;
2. owner and reviewer for each task;
3. dependency map;
4. status flow; and
5. escalation rules.

## Rules

- Do not create tasks that are too broad to review.
- Every task should have exactly one primary logical owner.
- Dependencies should be explicit, not implied.
- Every task should expose a next handoff target when applicable.
- Every task should declare how completion gets recorded.
