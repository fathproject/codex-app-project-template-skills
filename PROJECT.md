---
name: experiment
description: Comprehensive memory bank template - long-term project memory for AI-assisted development
version: 2.0.0
created: 2026-04-07
last_updated: 2026-04-08
author: User
license: MIT
compatibility:
  - codex app
categories:
  - template
  - memory-bank
  - long-term-memory
tags:
  - project-template
  - memory-bank
  - long-term-memory
  - comprehensive
---

# Project Memory Bank

> **Quick Reference Card** - Start here for current state

| Item | Value |
|------|-------|
| Project | experiment |
| Phase | Template |
| Last Session | 2026-04-08 |
| Current Focus | Convert AI TEAM policy into deterministic preflight and sync scripts |
| Next Action | Validate the new enforcement scripts and document `gh` as a required GitHub-mode dependency |

---

## Quick Links

- [Template Files](./) - Copy this repository into new projects as `memory/`
- [Decisions](./DECISIONS.md) - Decision log
- [Meetings](./MEETINGS.md) - Meeting notes
- [Glossary](./GLOSSARY.md) - Terminology
- [Stack](./context/stack.md) - Technology stack
- [Architecture](./context/architecture.md) - System design
- [Conventions](./context/conventions.md) - Coding standards

---

## Project Overview

### Basic Information

| Field | Value |
|-------|-------|
| **Project Name** | experiment |
| **Type** | Template / Memory Bank System |
| **Description** | Comprehensive memory bank template for AI-assisted development |
| **Problem Solved** | Enables AI agents to maintain long-term context across sessions |
| **Target Users** | Developers using AI coding assistants |
| **Phase** | Template (ready to copy to new projects) |
| **Status** | Active |

### Purpose

This is a **template project** demonstrating the memory bank pattern. The `memory/` folder contains a complete, reusable template that can be copied to any new project.

### Template Contents

The memory bank template includes:

| File | Purpose |
|------|---------|
| `TEMPLATE.md` | Complete template with all sections |
| `DECISIONS.md` | Decision log template |
| `MEETINGS.md` | Meeting notes template |
| `GLOSSARY.md` | Glossary template |
| `context/stack.md` | Technology stack template |
| `context/architecture.md` | Architecture template |
| `context/conventions.md` | Coding conventions template |
| `context/workflows.md` | Workflows template |
| `context/environments.md` | Environments template |
| `docs/*.md` | Documentation templates |

---

## Session History

| Date | Session # | Agent | Focus | Outcome |
|------|-----------|-------|-------|---------|
| 2026-04-07 | 1 | codex | Initial template creation | Created comprehensive memory bank template |
| 2026-04-08 | 2 | codex | Make skill-router bootstrap memory automatically | Added bootstrap scripts, updated entry skills, and aligned docs for project-first memory creation |
| 2026-04-08 | 3 | codex | Add AI TEAM entry skill and delivery analytics | Added a dedicated `ai-team` entry skill, introduced milestone and ETA analytics, and rewired the main flow docs |
| 2026-04-08 | 4 | codex | Collapse public skill surface into AI TEAM only | Switched installation to public-only `ai-team`, kept sibling skills as internal workflow modules, and updated docs accordingly |
| 2026-04-08 | 5 | codex | Add execution-mode and completion-sync discipline | Added `github_enabled` vs `local_only` policy, tooling preflight, and immediate GitHub Project sync rules for completed tasks |
| 2026-04-08 | 6 | codex | Make GitHub mode keep local memory in sync | Updated AI TEAM so GitHub-connected work still writes `PROJECT.md`, backlog, and roadmap alongside GitHub state |
| 2026-04-08 | 7 | codex | Add deterministic AI TEAM enforcement scripts | Added preflight, local completion sync, and GitHub sync scripts so the AI TEAM policy can be executed and checked consistently |

### Detailed Sessions

#### Session #1 - 2026-04-07

- **Agent**: codex
- **Duration**: ~1 hour
- **Focus**: Create comprehensive memory bank template
- **Work Done**:
  - Created `TEMPLATE.md` with all sections
  - Created `DECISIONS.md` for tracking decisions
  - Created `MEETINGS.md` for meeting notes
  - Created `GLOSSARY.md` for terminology
  - Created `context/stack.md` for tech stack
  - Created `context/architecture.md` for system design
  - Created `context/conventions.md` for coding standards
  - Created `context/workflows.md` for CI/CD and processes
  - Created `context/environments.md` for environment config
  - Created documentation templates in `docs/`
  - Updated `AGENTS.md` with complete instructions
- **Decisions Made**:
  - Created comprehensive template with all sections for true long-term memory
  - Used markdown with YAML frontmatter for metadata
  - Included templates for decisions, meetings, and glossary
- **Next Steps**: Copy template to new projects as needed

#### Session #2 - 2026-04-08

- **Agent**: codex
- **Duration**: ~1 hour
- **Focus**: Turn `skill-router` into the first-call entry point for new projects
- **Work Done**:
  - Added `scripts/bootstrap-memory.sh` to copy the template into `./memory/`
  - Added wrapper bootstrap scripts under `skills/skill-router/` and `skills/memory-bank/`
  - Updated `skill-router`, `memory-bank`, and `project-developer` to bootstrap project memory automatically when missing
  - Updated agent metadata and top-level docs to describe the new entry-point behavior
  - Verified skill structure and tested bootstrap against a temporary empty project
- **Decisions Made**:
  - `skill-router` is now the preferred first call for fresh projects
  - Bootstrap should initialize a fresh `memory/PROJECT.md` from `TEMPLATE.md`, not from the template repo's own `PROJECT.md`
- **Next Steps**: Commit and push the automatic memory bootstrap workflow

#### Session #3 - 2026-04-08

- **Agent**: codex
- **Duration**: ~1 hour
- **Focus**: Align the skill-pack entry point with the AI TEAM identity and add delivery analytics
- **Work Done**:
  - Added the new `ai-team` skill as the primary first-call entry point
  - Kept `skill-router` as a compatibility routing alias
  - Added `delivery-analytics-forecast` for weighted progress, ETA, and AI-versus-human comparison
  - Updated the core skill-flow docs, README, QUICKSTART, CODEX guide, and AGENTS note
  - Linked GitHub traceability to delivery analytics as a downstream reporting layer
- **Decisions Made**:
  - The skill pack should expose `ai-team` as its named entry point
  - Delivery analytics should be a dedicated skill, not buried in legacy PM guidance
- **Next Steps**: Verify the new AI TEAM entry flow and analytics skill, then push the update

#### Session #4 - 2026-04-08

- **Agent**: codex
- **Duration**: ~0.5 hours
- **Focus**: Make `ai-team` the only public skill shown in Codex while preserving internal workflow depth
- **Work Done**:
  - Changed `install-skills.sh` to install only `ai-team` by default
  - Added `--all` mode for maintainers who still want every internal module exposed separately
  - Added `skills/ai-team/references/internal-modules.md` as the internal module index
  - Updated docs to describe AI TEAM as the public face and the rest as internal modules
  - Prepared the pack to prune previously installed repo-managed skill symlinks outside `ai-team`
- **Decisions Made**:
  - Public Codex surface should show `ai-team` only by default
  - Internal workflow skills should remain in the repo for maintainability and selective loading
- **Next Steps**: Reinstall the skill pack in public-only mode and verify only `ai-team` remains exposed

#### Session #5 - 2026-04-08

- **Agent**: codex
- **Duration**: ~0.5 hours
- **Focus**: Make AI TEAM explicitly disciplined about GitHub usage, tool requirements, and completion tracking
- **Work Done**:
  - Added `skills/ai-team/references/execution-policy.md`
  - Updated `ai-team` to establish `github_enabled` versus `local_only` before routing deeper work
  - Updated GitHub-related modules so they are gated behind `github_enabled`
  - Added explicit rules that every completed task must sync the GitHub Project card immediately when GitHub is enabled
  - Added local-only rules so all tracking stays in local memory, backlog, roadmap, and optional local git
- **Decisions Made**:
  - AI TEAM should choose execution policy before orchestration
  - GitHub-connected projects must sync task completion immediately, not in a later batch
- **Next Steps**: Validate the new preflight policy and decide whether to push the updated AI TEAM workflow

#### Session #6 - 2026-04-08

- **Agent**: codex
- **Duration**: ~0.25 hours
- **Focus**: Ensure GitHub-enabled projects still preserve full local project memory
- **Work Done**:
  - Updated execution policy so `github_enabled` requires local memory, backlog, and roadmap updates too
  - Updated AI TEAM and GitHub sync modules to treat GitHub as an operational layer, not a replacement for local memory
  - Updated top-level docs to make the dual-write rule explicit
- **Decisions Made**:
  - GitHub-connected projects must still update `memory/PROJECT.md`, `backlog/BACKLOG.md`, and `timeline/ROADMAP.md`
- **Next Steps**: Revalidate the policy docs and keep GitHub plus local memory in lockstep

#### Session #7 - 2026-04-08

- **Agent**: codex
- **Duration**: ~0.5 hours
- **Focus**: Turn AI TEAM policy into deterministic scripts
- **Work Done**:
  - Added `scripts/preflight-check.sh` to verify execution mode, tool availability, and GitHub auth readiness
  - Added `scripts/sync-completion.sh` to write completion state into `PROJECT.md`, `BACKLOG.md`, and `ROADMAP.md`
  - Added `scripts/sync-github-task.sh` to comment on issues, update GitHub Project cards, and optionally close issues
  - Added wrapper scripts under `skills/ai-team/scripts/`
  - Updated AI TEAM docs to point at scripted enforcement instead of policy prose alone
- **Decisions Made**:
  - GitHub mode should fail fast if `gh` or GitHub auth is unavailable
  - Local memory sync should stay mandatory in every tracking mode
- **Next Steps**: Validate the new enforcement scripts and document the GitHub-mode dependency clearly

---

## Decisions Log

| ID | Date | Decision | Rationale | Status |
|----|------|----------|-----------|--------|
| D000 | 2026-04-08 | Keep skill-router as a bootstrap routing alias | Preserves compatibility while keeping bootstrap logic available | Active |
| D001 | 2026-04-08 | Use AI TEAM as the canonical skill-pack entry point | Aligns the entry skill name with the pack identity | Active |
| D002 | 2026-04-08 | Make delivery analytics a dedicated AI-team skill | Gives progress and ETA reporting a clear active-skill home | Active |
| D003 | 2026-04-08 | Expose only AI TEAM publicly by default | Keeps the Codex skill list clean while preserving internal module depth | Active |
| D004 | 2026-04-08 | Require execution policy and completion sync discipline | Prevents hidden GitHub assumptions and forces immediate tracking updates | Active |
| D005 | 2026-04-08 | Keep local memory updates mandatory in GitHub mode | Preserves long-term local project memory even when GitHub is active | Active |
| D006 | 2026-04-08 | Back AI TEAM policy with deterministic enforcement scripts | Makes preflight and completion sync auditable and repeatable | Active |

---

## Template Structure

```
memory/
├── TEMPLATE.md              # Main template (copy this)
├── DECISIONS.md             # Decision log template
├── MEETINGS.md              # Meeting notes template
├── GLOSSARY.md              # Glossary template
├── context/
│   ├── stack.md             # Tech stack
│   ├── architecture.md      # System design
│   ├── conventions.md       # Coding standards
│   ├── workflows.md         # CI/CD & processes
│   └── environments.md       # Environment config
└── docs/
    ├── README.md           # Project README template
    ├── API.md              # API docs template
    ├── DEPLOYMENT.md       # Deployment guide template
    └── ONBOARDING.md       # Onboarding guide template
```

---

## How to Use This Template

### For New Projects

1. **Copy the memory folder:**
   ```bash
   cp -r memory/ /path/to/new-project/memory/
   ```

2. **Rename template to project:**
   ```bash
   cd /path/to/new-project
   mv memory/TEMPLATE.md memory/PROJECT.md
   ```

3. **Customize PROJECT.md:**
   - Update frontmatter with project name
   - Fill in project overview
   - Add initial tasks
   - Set up session history

4. **Set up context files:**
   - Copy relevant context templates
   - Fill in technology details
   - Document architecture

### For Existing Projects

1. Read `memory/PROJECT.md` first
2. Check context files for technical details
3. Review decisions log for rationale
4. Update memory after any significant work

---

## Session Continuation Guide

### For AI Agents

#### Starting Fresh
1. Read `memory/PROJECT.md` when working from a project root, or `PROJECT.md` when working inside the memory repository directly
2. Check `memory/context/` or `context/` for technical details
3. Review `memory/docs/` or `docs/` for documentation
4. Check `memory/DECISIONS.md` or `DECISIONS.md` for rationale
5. Explore codebase structure
6. Ask clarifying questions if needed

#### Returning Session
1. Read **Quick Reference Card** at top
2. Review **Session History** section
3. Check **Decisions Log**
4. Review any **Tasks** or **Blockers**
5. Continue from **Next Steps**

#### Before Ending Session (MANDATORY)
1. Add entry to **Session History**
2. Add any new **Decisions** to DECISIONS.md
3. Update **Task** status
4. Update **Quick Reference Card**

---

## Knowledge Base

### What We Know

- This is a comprehensive memory bank template
- Designed for true long-term memory across AI sessions
- Includes separate files for decisions, meetings, glossary
- Has detailed context files for technical documentation
- Templates are reusable for any project type

### What This Template Includes

- Quick Reference Card for fast orientation
- Complete project overview section
- Detailed session history with timestamps
- Decision log with rationale
- Task tracking with sprint management
- Known issues and risks
- Learnings and important notes
- Meeting notes template
- Comprehensive context files
- Documentation templates

### Template Copy Instructions

```bash
# Copy template to new project
cp -r memory/ /path/to/new-project/memory/

# Rename template file
cd /path/to/new-project
mv memory/TEMPLATE.md memory/PROJECT.md

# Customize the project file
# Update frontmatter, overview, and initial state
```

---

## Open Tasks

- [ ] Template is complete and ready for use
- [ ] Copy to actual projects as needed

---

## Learnings & Notes

### Key Learnings

| Date | Learning | Context |
|------|----------|---------|
| 2026-04-07 | AI needs structured memory to maintain context | Created comprehensive template to solve this |
| 2026-04-07 | Separating decisions helps maintain rationale | Created DECISIONS.md for this purpose |

### Important Notes

- This is a TEMPLATE - customize for each project
- Always update memory before ending session
- Include "why" not just "what" in decisions

---

## Resources

### Documentation Links
- [TEMPLATE.md](./TEMPLATE.md) - Main template
- [DECISIONS.md](./DECISIONS.md) - Decision template
- [MEETINGS.md](./MEETINGS.md) - Meeting template
- [GLOSSARY.md](./GLOSSARY.md) - Glossary template
- [Stack](./context/stack.md) - Tech stack template
- [Architecture](./context/architecture.md) - Architecture template
- [Conventions](./context/conventions.md) - Conventions template
- [Workflows](./context/workflows.md) - Workflows template
- [Environments](./context/environments.md) - Environments template

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v2.0.0 | 2026-04-07 | Complete rewrite with comprehensive sections, separate decision/meeting files |
| v1.0.0 | 2026-04-07 | Initial basic template |

---

*Last updated: 2026-04-07*
*Memory Bank Template v2.0.0*
