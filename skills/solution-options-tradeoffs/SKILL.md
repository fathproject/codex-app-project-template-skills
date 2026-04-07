---
name: solution-options-tradeoffs
description: Use when an idea needs alternative solution paths, tradeoff analysis, and a justified recommendation before scope or implementation is locked in.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - analysis
  - product
  - architecture
tags:
  - options
  - tradeoffs
  - decision-making
  - recommendation
---

# Solution Options Tradeoffs

Use this skill when the AI should explore multiple valid paths before choosing one.

## Workflow

1. Define the actual decision being made.
2. Generate 2 to 4 credible options.
3. Compare them on value, effort, risk, dependency shape, and long-term flexibility.
4. Recommend one direction with reasons.

## Output Contract

Use a compact option matrix rather than loose prose:

```md
# Decision Analysis

## Decision Statement
- The exact choice being made

## Option A
- Summary
- Strengths
- Risks
- Dependencies
- Effort

## Option B
- Summary
- Strengths
- Risks
- Dependencies
- Effort

## Option C
- Summary
- Strengths
- Risks
- Dependencies
- Effort

## Comparison Matrix
| Option | Value | Effort | Risk | Dependency Shape | Flexibility |
|--------|-------|--------|------|------------------|-------------|
| A | high | medium | medium | simple | medium |
| B | medium | low | low | simple | low |
| C | high | high | high | complex | high |

## Recommendation
- Preferred option
- Why it wins
- What is explicitly being traded away

## Recommended Next Step
- Usually: `$scope-convergence`
```

## Output Format

Produce:

1. decision statement;
2. option A/B/C;
3. tradeoff comparison; and
4. recommended option with rationale.

## Rules

- Do not produce fake variety where options are basically the same.
- If one option clearly dominates, say so.
- Keep tradeoffs concrete rather than abstract.
- Every recommendation should say what is not being chosen and why.
