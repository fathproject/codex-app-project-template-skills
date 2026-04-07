---
name: scope-convergence
description: Use when brainstorming is done and the work must converge into a practical MVP, phased scope, assumptions, exclusions, and concrete boundaries for execution.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - scope
  - planning
  - product
tags:
  - convergence
  - mvp
  - scope
  - prioritization
---

# Scope Convergence

Use this skill to turn many ideas into a buildable scope.

## Workflow

1. Start from the normalized brief and option analysis.
2. Define the MVP boundary.
3. Separate in-scope, deferred, and out-of-scope items.
4. Record assumptions and remaining blockers.
5. Produce an execution-ready scope handoff.

## Output Contract

Use this scope decision package:

```md
# Scope Decision

## MVP Scope
- Feature 1
- Feature 2

## Deferred Scope
- Feature or workstream to move later

## Non-Goals
- Explicitly excluded work

## Assumptions
- Assumption 1
- Assumption 2

## Blocking Questions
- Question 1
- Question 2

## Engineering Readiness
- Ready now / not ready yet
- Why

## Recommended Next Step
- Usually: `$ai-project-manager-orchestrator`
```

## Output Format

Produce:

1. MVP scope;
2. deferred scope;
3. non-goals;
4. blocking questions; and
5. execution-ready next step.

## Rules

- Scope should get smaller and clearer, not broader.
- Nice-to-have features belong outside the MVP unless they change adoption or safety.
- If the scope is still fuzzy, say it is not ready for engineering.
- The output must end with a clear go or no-go for execution.
