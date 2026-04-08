# Codex Project Guide

This repository is the Codex-oriented version of the original OpenCode template.

## Purpose

It combines:

- a reusable project memory bank;
- a structured documentation pack for planning and delivery; and
- a multi-skill Codex workflow for development, project management, GitHub operations, and delivery.

## Codex Workflow

### At Session Start

1. If the current project has neither `memory/PROJECT.md` nor `PROJECT.md`, bootstrap `memory/` from this template first.
2. Read `PROJECT.md`.
3. Check `DECISIONS.md`.
4. Review `context/conventions.md`.
5. Load any other context documents needed for the current task.

### During The Session

- Update decisions when rationale changes.
- Keep backlog, roadmap, and requirements in sync with the real state of the project.
- Use the appropriate installed skill from `skills/`.
- Establish whether the project is `github_enabled` or `local_only` before invoking deeper workflow modules.

### At Session End

1. Add a session entry to `PROJECT.md`.
2. Add any new decision to `DECISIONS.md`.
3. Update task status and next actions.

## Suggested Skill Entry Points

- `$ai-team` as the primary first call for this skill pack
- Internal workflow modules are kept in the repository and should normally be loaded by `ai-team` rather than invoked as separate public skills.
- Install with `./scripts/install-skills.sh --all` only if you intentionally want every internal module exposed separately.

Primary AI-team path:

`$ai-team -> $client-intake-normalizer -> $solution-options-tradeoffs -> $scope-convergence -> $ai-project-manager-orchestrator -> $ai-team-planner -> $task-assignment-governance -> $github-traceability-board-sync -> $delivery-analytics-forecast -> $cross-agent-handover`

If the user does not want GitHub:

- keep tracking local;
- skip GitHub modules; and
- use memory, backlog, roadmap, and local git only.

If the user does want GitHub:

- sync GitHub immediately on task completion; and
- still keep `memory/PROJECT.md`, `backlog/BACKLOG.md`, and `timeline/ROADMAP.md` aligned locally.

The canonical flow and packet handoff model are documented in `docs/AI_TEAM_SKILL_FLOW.md`.

Legacy or supporting skills:

- `$autonomous-agent`
- `$project-manager`
- `$team-setup`
- `$team-roles`
- `$timeline-roadmap`
- `$github-integration`
- `$github-projects`

Inside AI TEAM, internal workflow modules such as `memory-bank`, `project-developer`, `review-verification`, and `delivery-analytics-forecast` remain available as reference modules.

## Installation

Run `./scripts/install-skills.sh` from the repository root to install the public `ai-team` skill into Codex. Use `./scripts/install-skills.sh --all` only for maintenance mode.
