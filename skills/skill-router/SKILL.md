---
name: skill-router
description: Use when the user is not sure which Codex skill should be applied, when a task spans multiple phases, or when you need to choose the smallest effective sequence of skills before starting work.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - routing
  - workflow
  - orchestration
tags:
  - skill-router
  - workflow-router
  - triage
  - orchestration
---

# Skill Router

Supporting routing alias.

For this skill pack, prefer `ai-team` as the canonical first-call entry point.

Use this skill to choose the right skill or skill sequence before doing deeper work.

## Purpose

The router should reduce confusion, not add ceremony.

Its job is to:

1. classify the task;
2. choose the smallest useful skill set;
3. order the skills if more than one is needed; and
4. explain the choice briefly.

## Entry Point Requirement

Treat `skill-router` as a compatible routing entry point when a project is new, unfamiliar, or has not been initialized with local memory.

Before routing:

1. Check whether `./memory/PROJECT.md` or `./PROJECT.md` exists in the current project.
2. If neither exists, bootstrap `./memory/` immediately by running the bundled `scripts/bootstrap-memory.sh "$PWD"` from this skill directory.
3. After bootstrapping, read `memory/PROJECT.md` and route from that state instead of routing blind.

Do not ask the user whether to create `memory/` first. The router should create it automatically so the project gets a recorded working history from the first session.

When possible, recommend `ai-team` as the named entry point for the skill pack.

## Routing Rules

### Start With Context

First determine:

- Does the current project already have `memory/PROJECT.md` or `PROJECT.md`?
- Is this a new project or an existing codebase?
- Is the user planning, implementing, debugging, reviewing, or deploying?
- Is the repository already understood?
- Is the request broad enough to need multiple skills?

If both `memory/PROJECT.md` and `PROJECT.md` are missing, bootstrap `memory/` first and then continue classification.

### Default Minimal Path

Prefer the shortest path that can solve the task.

- For normal coding work: `memory-bank -> project-developer`
- For unfamiliar repos: `repo-discovery -> memory-bank -> project-developer`
- For reviews: `memory-bank -> review-verification`
- For planning from scratch: `client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence -> ai-project-manager-orchestrator`
- For raw client input: `client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence`
- For AI-team setup from client input: `client-intake-normalizer -> solution-options-tradeoffs -> scope-convergence -> ai-project-manager-orchestrator -> ai-team-planner`
- For turning an AI plan into managed execution: `ai-project-manager-orchestrator -> ai-team-planner -> backlog-management -> task-assignment-governance -> github-traceability-board-sync`
- For handing work between AI roles: `cross-agent-handover`
- For production bugs: `memory-bank -> debugging-incident`
- For release checks: `review-verification -> qa-e2e-release -> security-production-readiness`
- For API changes: `api-contract-integration -> project-developer -> review-verification`
- For auth changes: `auth-identity -> project-developer -> security-production-readiness`
- For schema changes: `database-schema-migrations -> project-developer -> review-verification`
- For environment or deploy work: `infra-environments -> cicd-delivery -> qa-e2e-release`
- For milestone progress, ETA, or AI-vs-human reporting: `ai-project-manager-orchestrator -> github-traceability-board-sync -> delivery-analytics-forecast`
- For documentation closure: `docs-sync-handover -> memory-bank`

Do not select many skills unless each one clearly adds value.

## Skill Selection Guide

Choose the best fit from these patterns:

| Situation | Preferred Skill |
|-----------|-----------------|
| Need current project state | `memory-bank` |
| Need to normalize raw client materials | `client-intake-normalizer` |
| Need to compare solution paths | `solution-options-tradeoffs` |
| Need to lock MVP scope | `scope-convergence` |
| Need an AI PM to run the project | `ai-project-manager-orchestrator` |
| Need to design the AI team roster | `ai-team-planner` |
| Need to break scope into owned AI tasks | `task-assignment-governance` |
| Need AI ownership visible in GitHub | `github-traceability-board-sync` |
| Need to pass work between AI roles | `cross-agent-handover` |
| Need a repo map first | `repo-discovery` |
| Normal implementation task | `project-developer` |
| Code quality or regression review | `review-verification` |
| Broad coding help | `coding-assistant` |
| New project setup | `project-initialization` |
| Requirements and scope | `requirements-analysis` |
| Backlog and sprint planning | `backlog-management` |
| Roadmap and milestones | `timeline-roadmap` |
| Delivery progress, ETA, or AI-vs-human comparison | `delivery-analytics-forecast` |
| Team structure and role coverage | `team-setup` or `team-roles` |
| GitHub repository operations | `github-integration` |
| GitHub project board work | `github-projects` |
| Containerization | `docker-setup` |
| Pipeline and release flow | `cicd-delivery` |
| End-to-end autonomous delivery | `autonomous-agent` |
| Hard bug or production incident | `debugging-incident` |
| Release gate and E2E confidence | `qa-e2e-release` |
| Security and hardening review | `security-production-readiness` |
| Logging, metrics, and alerts | `observability-monitoring` |
| Schema changes and data rollout | `database-schema-migrations` |
| API compatibility work | `api-contract-integration` |
| Login, roles, and identity flows | `auth-identity` |
| User-facing screen state coverage | `frontend-ui-states` |
| Environment and deployment topology | `infra-environments` |
| Memory and docs consistency | `docs-sync-handover` |

## Escalation Rules

- If one skill fully covers the task, use only that skill.
- If the input is still raw client material, normalize before planning.
- If brainstorming produced too many ideas, converge scope before assignment.
- If the project should be run as an AI team, use the PM orchestrator and team planner explicitly.
- If work is about to be assigned across multiple AI roles, apply assignment governance.
- If GitHub visibility matters, add traceability sync before or during execution.
- If one AI role is finishing and another must continue, require a handoff step.
- If discovery is missing, do discovery before implementation.
- If implementation is complete and confidence is needed, add `review-verification` after coding.
- If the task touches production data, consider `database-schema-migrations`.
- If the task changes auth or permissions, consider `auth-identity`.
- If the task is approaching release, consider QA, security, and observability explicitly.
- If the user asks for autonomous end-to-end ownership, prefer `autonomous-agent` over composing many PM skills.
- If the task is still ambiguous after classification, ask one concise clarifying question or choose the least risky path.

## Output Format

When routing, provide:

1. task classification;
2. selected skill or skill sequence;
3. one-line reason for each selected skill; and
4. immediate next action.

Keep the output short. The purpose is to move into execution quickly.

## Output Contract

Use this routing packet:

```md
# Routing Packet

## Task Classification
- planning / implementation / review / incident / release / docs / infra

## Selected Skill Path
1. Skill 1
2. Skill 2
3. Skill 3

## Why This Path
- Reason 1
- Reason 2

## Immediate Next Action
- Exact first move
```

## Rules

- Route first, then work.
- Bootstrap `memory/` first if the current project does not have it yet.
- Prefer fewer skills over more skills.
- Avoid redundant overlaps such as `coding-assistant` plus `project-developer` unless there is a clear reason.
- Use `memory-bank` in most project-continuity tasks.
- Prefer the AI-team flow over legacy PM skills unless a formal artifact is specifically requested.
