---
name: client-intake-normalizer
description: Use when the user provides raw client materials such as notes, chats, requests, transcripts, screenshots, or mixed ideas that must be normalized into a structured brief before planning begins.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - intake
  - analysis
  - planning
tags:
  - client-intake
  - normalization
  - brief
  - discovery
---

# Client Intake Normalizer

Use this skill to turn messy client input into a brief the AI team can actually execute against.

## Goals

1. Separate facts from assumptions.
2. Extract the real problem, goal, and requested outcome.
3. Identify missing information and contradictions.
4. Produce a structured brief for planning.

## Workflow

1. Gather the raw materials.
2. Extract the problem statement, goals, requested features, users, and constraints.
3. Distinguish facts, assumptions, and open questions.
4. Flag contradictions and missing decisions.
5. Produce an execution-ready brief for the next planning skill.

## Output Contract

Use this structure so the next skill can continue without re-reading the raw client material:

```md
# Normalized Client Brief

## Problem Statement
- What business or user problem must be solved

## Goals
- Goal 1
- Goal 2

## Requested Outcomes
- Requested feature or result 1
- Requested feature or result 2

## Target Users
- Primary user
- Secondary user

## Constraints
- Budget, time, stack, compliance, or delivery constraints

## Facts
- Confirmed fact 1
- Confirmed fact 2

## Assumptions
- Assumption 1
- Assumption 2

## Open Questions
- Critical unanswered question 1
- Critical unanswered question 2

## Contradictions
- Statement conflict or unclear point

## Recommended Next Step
- Usually: `$solution-options-tradeoffs` or `$scope-convergence`
```

## Output Format

Produce:

1. normalized brief;
2. facts;
3. assumptions;
4. open questions; and
5. recommended next planning step.

## Rules

- Do not jump to architecture or implementation.
- Preserve client intent even when the input is messy.
- Ask only the smallest number of critical follow-up questions.
- Facts, assumptions, and open questions must never be mixed together.
