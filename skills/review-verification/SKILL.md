---
name: review-verification
description: Use when reviewing a change set, checking for regressions before release, or validating that implementation work is complete. It focuses on risk, behavior, verification coverage, and clear findings rather than broad summaries.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - review
  - verification
  - quality
tags:
  - code-review
  - regression-check
  - verification
  - release-readiness
---

# Review Verification Skill

Use this skill when the goal is to prove a change is safe, or to find why it is not.

## Focus

- behavioral regressions;
- missing validation or test coverage;
- risky edge cases;
- release readiness gaps; and
- unclear assumptions in the implementation.

## Workflow

### 1. Establish Review Scope

Start by identifying:

- which files changed;
- which user-facing or system-facing behaviors changed;
- which commands are supposed to verify the change; and
- whether the task is a code review, QA pass, or release check.

### 2. Read For Risk, Not For Style

Prioritize:

- correctness;
- state transitions;
- error handling;
- data integrity;
- API compatibility;
- auth, permissions, and secrets handling; and
- migration or deployment risks.

Treat formatting and style as secondary unless they hide a functional problem.

### 3. Verify With Evidence

Run the narrowest useful checks first:

- targeted tests for the changed area;
- lint or typecheck when the repo relies on them;
- smoke checks for affected commands or routes; and
- diff inspection when tests are unavailable.

If verification could not be run, say exactly what was blocked.

### 4. Report Findings Clearly

Order findings by severity:

1. critical breakage;
2. likely regressions;
3. missing tests or validation;
4. residual risks.

Each finding should include:

- what is wrong;
- why it matters; and
- where it lives.

## Output Format

For review tasks, prefer:

1. Findings
2. Open questions or assumptions
3. Verification run
4. Short overall assessment

If there are no findings, say so explicitly and still mention any verification gaps.

## Rules

- Findings come before summary.
- Do not pad the result with style-only commentary.
- Distinguish confirmed problems from plausible risks.
- When evidence is partial, say what was checked and what was not.
