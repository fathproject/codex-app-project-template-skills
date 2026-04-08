---
name: delivery-analytics-forecast
description: Use when the AI team must measure weighted milestone progress, estimate completion dates, report delivery health, or compare AI execution speed against a human-style baseline.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - analytics
  - forecasting
  - project-management
  - ai-team
tags:
  - progress
  - forecasting
  - milestones
  - eta
  - ai-vs-human
---

# Delivery Analytics & Forecast

Use this skill when delivery needs quantified progress, ETA, or comparative execution reporting.

## Position In The AI Team Stack

Use this after:

1. `timeline-roadmap` or `ai-project-manager-orchestrator`
2. `backlog-management`
3. `task-assignment-governance`
4. `github-traceability-board-sync`

Hand off to:

5. `ai-project-manager-orchestrator`
6. `docs-sync-handover`

## Goals

1. Measure milestone progress with weighted completion, not just raw issue count.
2. Estimate likely finish dates using current delivery state.
3. Compare AI-team execution against a human-style baseline on the same scope.
4. Surface confidence, blockers, and forecast drivers.

## Inputs To Read

- `PROJECT.md`
- `timeline/ROADMAP.md`
- `backlog/BACKLOG.md`
- `docs/AI_TEAM_GITHUB_OPERATIONS.md`
- active issue, PR, and board status if GitHub metadata exists

## Working Model

### Weighted Progress

Prefer explicit task or milestone weights if they exist.

If no weights exist, say so and fall back to equal weighting.

Recommended status weights:

- `Backlog` or `Todo`: `0.00`
- `Ready`: `0.10`
- `In Progress`: `0.40`
- `In Review`: `0.65`
- `In QA`: `0.80`
- `In Handover`: `0.90`
- `Done`: `1.00`

For `Blocked`, keep the current completion state but apply a risk penalty in the forecast narrative.

### Human-Style Estimate

Estimate as a cautious project manager would:

- include dependency drag;
- include coordination and review delay;
- include realistic batching and handoff overhead; and
- include schedule buffer.

### AI-Style Estimate

Estimate from the active AI delivery system:

- use actual AI throughput where available;
- use retry and blocker rates;
- include logical parallel AI roles;
- include current queue health and review gates; and
- call out when the estimate is assumption-heavy.

## Workflow

1. Identify milestones, target dates, and delivery phases.
2. Map active work items to milestones and weights.
3. Compute weighted completion by milestone and overall delivery state.
4. Produce a human-style ETA.
5. Produce an AI-style ETA.
6. Compare the two and quantify the delta or speedup.
7. Explain the confidence level and main forecast drivers.

## Output Contract

Use this analytics packet:

```md
# Delivery Analytics Packet

## Milestone Progress
- Milestone
- Weighted completion %
- Timeline status

## Overall Delivery Health
- On track / watch / off track

## AI Forecast
- Estimated finish date
- Confidence
- Main assumptions

## Human Baseline Forecast
- Estimated finish date
- Confidence
- Main assumptions

## Variance And Speedup
- Planned vs current variance
- AI vs human delta
- Estimated speedup factor

## Main Risks And Drivers
- Blocker 1
- Forecast driver 1

## Recommended PM Action
- Re-sequence / add reviewers / reduce scope / hold release
```

## Rules

- Never pretend weak data is precise.
- Separate facts, assumptions, and inference.
- Compare AI and human against the same milestone scope.
- If the board or backlog is stale, call out that the forecast quality is degraded.
- If progress is based on equal weighting, say so explicitly.
