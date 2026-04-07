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

Use this skill to choose the right skill or skill sequence before doing deeper work.

## Purpose

The router should reduce confusion, not add ceremony.

Its job is to:

1. classify the task;
2. choose the smallest useful skill set;
3. order the skills if more than one is needed; and
4. explain the choice briefly.

## Routing Rules

### Start With Context

First determine:

- Is this a new project or an existing codebase?
- Is the user planning, implementing, debugging, reviewing, or deploying?
- Is the repository already understood?
- Is the request broad enough to need multiple skills?

### Default Minimal Path

Prefer the shortest path that can solve the task.

- For normal coding work: `memory-bank -> project-developer`
- For unfamiliar repos: `repo-discovery -> memory-bank -> project-developer`
- For reviews: `memory-bank -> review-verification`
- For planning from scratch: `requirements-analysis -> backlog-management -> timeline-roadmap`

Do not select many skills unless each one clearly adds value.

## Skill Selection Guide

Choose the best fit from these patterns:

| Situation | Preferred Skill |
|-----------|-----------------|
| Need current project state | `memory-bank` |
| Need a repo map first | `repo-discovery` |
| Normal implementation task | `project-developer` |
| Code quality or regression review | `review-verification` |
| Broad coding help | `coding-assistant` |
| New project setup | `project-initialization` |
| Requirements and scope | `requirements-analysis` |
| Backlog and sprint planning | `backlog-management` |
| Roadmap and milestones | `timeline-roadmap` |
| Team structure and role coverage | `team-setup` or `team-roles` |
| GitHub repository operations | `github-integration` |
| GitHub project board work | `github-projects` |
| Containerization | `docker-setup` |
| Pipeline and release flow | `cicd-delivery` |
| End-to-end autonomous delivery | `autonomous-agent` |

## Escalation Rules

- If one skill fully covers the task, use only that skill.
- If discovery is missing, do discovery before implementation.
- If implementation is complete and confidence is needed, add `review-verification` after coding.
- If the user asks for autonomous end-to-end ownership, prefer `autonomous-agent` over composing many PM skills.
- If the task is still ambiguous after classification, ask one concise clarifying question or choose the least risky path.

## Output Format

When routing, provide:

1. task classification;
2. selected skill or skill sequence;
3. one-line reason for each selected skill; and
4. immediate next action.

Keep the output short. The purpose is to move into execution quickly.

## Rules

- Route first, then work.
- Prefer fewer skills over more skills.
- Avoid redundant overlaps such as `coding-assistant` plus `project-developer` unless there is a clear reason.
- Use `memory-bank` in most project-continuity tasks.
