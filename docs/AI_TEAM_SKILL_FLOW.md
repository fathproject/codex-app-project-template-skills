# AI Team Skill Flow

This document defines the intended internal flow for AI TEAM.

Public surface:

- `ai-team`

Internal workflow modules:

- the sibling skill folders under `skills/`

## Core Principle

Every active skill should do three things clearly:

1. accept a known input state;
2. produce a reusable output packet; and
3. make the next skill obvious.

## Primary Flow

### 0. Entry Point

1. `ai-team`

Compatibility alias kept in the repo:

- `skill-router`

### 1. Intake And Scope

2. `client-intake-normalizer`
3. `solution-options-tradeoffs`
4. `scope-convergence`

Artifacts:

- normalized brief
- option comparison
- scope decision

### 2. Orchestration And Team Formation

5. `ai-project-manager-orchestrator`
6. `ai-team-planner`
7. `backlog-management`
8. `task-assignment-governance`
9. `github-traceability-board-sync`

Artifacts:

- AI PM control packet
- AI team plan
- delivery backlog
- assignment packet
- traceability packet

### 3. Oversight And Forecasting

10. `delivery-analytics-forecast` when milestone progress, ETA, or AI-versus-human comparison is needed

Artifacts:

- delivery analytics packet

### 4. Implementation And Delivery

11. `memory-bank`
12. `repo-discovery` when needed
13. domain skills such as:
   - `api-contract-integration`
   - `auth-identity`
   - `frontend-ui-states`
   - `infra-environments`
   - `database-schema-migrations`
   - `observability-monitoring`
14. `project-developer`
15. `review-verification`

Artifacts:

- continuity packet
- repository map packet
- domain-specific packets
- implementation packet
- verification packet

### 5. Release, Security, And Closure

16. `qa-e2e-release`
17. `security-production-readiness`
18. `docs-sync-handover`
19. `cross-agent-handover` when another AI role continues

Artifacts:

- release gate packet
- security gate packet
- documentation sync packet
- handoff packet

## Specialist Incident Flow

Use this for bugs, incidents, or flaky behavior:

1. `memory-bank`
2. `debugging-incident`
3. `project-developer`
4. `review-verification`
5. `docs-sync-handover`

## Routing Entry Point

Use `ai-team` as the primary starting point when the path is unclear.

`skill-router` remains a compatible alias.

The entry skill should choose the smallest valid path and prefer the active AI-team flow over legacy PM skills.

## Legacy And Supporting Skills

These skills are still available, but they are not the primary AI-team path:

- `autonomous-agent`
- `project-manager`
- `project-initialization`
- `requirements-analysis`
- `team-setup`
- `team-roles`
- `timeline-roadmap`
- `github-integration`
- `github-projects`
- `docker-setup`
- `cicd-delivery`
- `coding-assistant`

Use them when their specific artifact or support function is required, not as the default route.

## Ready-State Checklist

The skill pack is considered coherent when:

- each active skill has a clear output contract or packet;
- upstream and downstream relationships are visible;
- GitHub traceability is consistent with AI worker ownership;
- memory and docs closure are part of the normal flow; and
- legacy skills are clearly marked so they do not compete with the main path.
