---
name: github-integration
description: Use when repository-level GitHub setup must be checked or fixed so the AI-team workflow can use issues, pull requests, labels, and projects safely.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - github
  - integration
  - automation
  - devops
tags:
  - github
  - github-cli
  - automation
  - issues
  - projects
  - milestones
---

# GitHub Integration Skill

Use this skill when GitHub itself must be prepared for the AI-team workflow.

## Position In The AI Team Stack

This is a supporting setup skill.

For normal AI-team execution, prefer:

1. `task-assignment-governance`
2. `github-traceability-board-sync`
3. `cross-agent-handover`

## Goals

1. Confirm the repository is usable by the AI team.
2. Confirm authentication, repository settings, and baseline labels.
3. Ensure issues, PRs, and projects can reflect logical AI ownership.

## Mode Gate

Use this skill only when `tracking_mode=github_enabled`.

If the project is `local_only`, do not require GitHub auth and do not perform GitHub setup work.

## Workflow

1. Check authentication and repository access.
2. Confirm issues and projects are enabled.
3. Create or align labels needed by the delivery workflow.
4. Ensure the repository has the AI task and PR templates.
5. Hand off board structure work to `github-traceability-board-sync`.

## Required References

- `docs/AI_TEAM_GITHUB_OPERATIONS.md`
- `.github/ISSUE_TEMPLATE/ai-task.md`
- `.github/pull_request_template.md`

## Output Contract

Produce:

1. GitHub readiness status;
2. missing configuration items;
3. labels or settings to create or fix; and
4. the next GitHub-oriented skill to invoke.

## Rules

- Assume one shared GitHub account is acceptable.
- Do not design a separate ownership model outside `AI_TEAM_GITHUB_OPERATIONS.md`.
- If the repository already has the required templates and settings, stop and hand off.
- If `tracking_mode=local_only`, stop immediately and hand tracking back to local memory and backlog files.
