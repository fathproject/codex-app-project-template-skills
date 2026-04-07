---
name: repo-discovery
description: Use when starting work in an unfamiliar repository, inheriting an existing codebase, or needing a fast technical map of the project before planning or coding. It inspects structure, stack, commands, key entry points, and likely risk areas.
version: 1.0.0
created: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - discovery
  - analysis
  - codebase
tags:
  - repo-discovery
  - onboarding
  - audit
  - codebase-map
---

# Repo Discovery Skill

Use this skill to create a compact, actionable map of a repository before deeper work starts.

## Goals

1. Identify the real project root and major directories.
2. Detect the primary stack and toolchain.
3. Find the actual run, build, lint, typecheck, and test commands.
4. Locate key entry points, configuration files, and stateful or risky areas.
5. Summarize the repo so follow-up work can start with fewer assumptions.

## Workflow

### 1. Inspect Structure First

- List top-level files and folders.
- Identify whether the repo is single-package, monorepo, or polyrepo-shaped.
- Note likely application roots such as `src/`, `app/`, `server/`, `packages/`, `services/`, `infra/`, or `docs/`.

### 2. Detect Stack From Primary Files

Check for files such as:

- `package.json`, `pnpm-workspace.yaml`, `turbo.json`
- `pyproject.toml`, `requirements.txt`
- `go.mod`
- `Cargo.toml`
- `Dockerfile`, `docker-compose.yml`
- `.github/workflows/`
- framework configs such as `next.config.*`, `vite.config.*`, `tsconfig.json`

Do not infer the stack from folder names alone when manifest files exist.

### 3. Find Real Commands

Prefer project-defined commands over generic guesses.

- Read scripts from `package.json`.
- Read make targets from `Makefile`.
- Read task runners or CI workflows when local commands are unclear.
- Call out when expected commands are missing.

### 4. Identify Execution Paths

Find:

- app entry points;
- API handlers or route roots;
- background jobs or workers;
- database schema or migration directories;
- test suites and coverage tooling; and
- deployment or infra definitions.

### 5. Highlight Risks

Call out areas that will slow future work, for example:

- missing tests;
- inconsistent commands across packages;
- generated code mixed with source;
- secrets or env-heavy setup;
- large legacy directories; or
- multiple apps sharing one repo.

## Output Format

When reporting discovery, include:

1. Repository shape
2. Primary stack
3. Important commands
4. Key entry points
5. Risk areas
6. Recommended next step

Keep it compact. The point is to accelerate follow-up work, not to dump the whole tree.

## Rules

- Prefer evidence from manifests and configs over intuition.
- Mention uncertainty explicitly when the repo is ambiguous.
- Avoid deep reads of unrelated files before the high-level map is clear.
- Hand off to a more specific skill after discovery if the next task is known.
