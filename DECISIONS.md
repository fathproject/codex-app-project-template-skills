---
name: decisions-log
description: Template for tracking architectural and significant decisions
version: 1.0.0
created: 2026-04-07
---

# Decisions Log

> All significant architectural and technical decisions should be documented here with full rationale.

---

## How to Use This Log

When making a significant decision:
1. Create a new entry with auto-incremented ID (D001, D002, etc.)
2. Fill in all sections
3. If deprecated later, update status and add replacement reference

---

## Decision Template

```markdown
### DXXX - YYYY-MM-DD: [Decision Title]

**Status**: Active / Deprecated / Superseded
**Made By**: Name/Team
**Related**: DXXX (if related to other decisions)

**Decision**: What was decided
**Context**: Why this decision needed to be made

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Option A | ... | ... | ... |
| Option B | ... | ... | ... |
| Option C (Chosen) | ... | ... | ... |

**Consequences**:
- Positive: What benefits this brings
- Negative: What trade-offs or technical debt this introduces

**Implementation**: How this was/should be implemented

**Status History**:
- YYYY-MM-DD: Active - Initial decision
```

---

## Active Decisions

### D000 - 2026-04-08: Keep Skill Router As A Bootstrap Routing Alias

**Status**: Active
**Made By**: codex
**Related**: D001

**Decision**: Keep `$skill-router` in the repo as a compatibility routing alias that can still bootstrap `./memory/` automatically when needed.

**Context**: The pack now uses `ai-team` as the canonical public entry point, but existing prompts and workflows may still reference `skill-router`.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Manual copy step only | Explicit and simple | Easy to skip, breaks continuity in new projects | Too much friction |
| `memory-bank` only bootstraps | Keeps router pure | First user call may still start without memory | Not enough coverage |
| Remove `skill-router` entirely | Clean public story | Breaks compatibility with earlier prompts | Too disruptive |
| Keep `skill-router` as alias (Chosen) | Preserves compatibility and bootstrap logic | Adds a second routing doc to maintain | Acceptable tradeoff |

**Consequences**:
- **Positive**: Earlier prompts still work, and bootstrap behavior remains available.
- **Negative**: Alias documentation must stay in sync with `ai-team`.

**Implementation**: Keep `skill-router` in the repo and update it in parallel with `ai-team` when routing behavior changes.

### D001 - 2026-04-08: Use AI TEAM As The Canonical Skill-Pack Entry Point

**Status**: Active
**Made By**: codex
**Related**: D000

**Decision**: Introduce `ai-team` as the named first-call entry skill for this skill pack and keep `skill-router` as a routing alias for compatibility.

**Context**: The pack is branded and conceptualized as an AI TEAM operating model. Using `skill-router` as the visible entry point works functionally, but it does not match the mental model of the pack itself.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Keep `skill-router` only | No new skill to maintain | Entry point name does not match the pack identity | Too generic |
| Rename and remove `skill-router` completely | Clean naming | Breaks prompts and existing usage | Too disruptive |
| Add `ai-team` and keep `skill-router` as alias (Chosen) | Clear identity with backward compatibility | Slight overlap between the two skills | Best balance |

**Consequences**:
- **Positive**: The pack now has an entry point whose name matches its operating model.
- **Negative**: Routing guidance must stay synchronized across two entry skills.

**Implementation**: Added `skills/ai-team/`, updated docs to recommend `$ai-team`, and repositioned `skill-router` as a supporting alias.

### D002 - 2026-04-08: Make Delivery Analytics A Dedicated AI-Team Skill

**Status**: Active
**Made By**: codex
**Related**: D001

**Decision**: Track milestone progress, ETA, and AI-versus-human comparison through a dedicated skill named `delivery-analytics-forecast`.

**Context**: Existing skills cover roadmap creation, backlog shaping, orchestration, and board visibility, but none produce a coherent weighted-progress or forecast packet for delivery oversight.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Leave forecasting inside legacy PM skills | No new files | Analytics stays buried and disconnected from the AI-team flow | Too weak |
| Fold analytics into `ai-project-manager-orchestrator` | Fewer skills | PM control and metrics reporting become overly broad | Too coupled |
| Dedicated analytics skill (Chosen) | Clear role, reusable packet, easier to trigger from GitHub state | Adds one more active skill | Strongest separation |

**Consequences**:
- **Positive**: Progress, ETA, and benchmark reporting now have a clear home in the active AI-team path.
- **Negative**: Forecast quality still depends on good backlog weights and current board status.

**Implementation**: Added `skills/delivery-analytics-forecast/` and linked it from the AI-team flow and GitHub traceability skill.

### D003 - 2026-04-08: Expose Only AI TEAM Publicly By Default

**Status**: Active
**Made By**: codex
**Related**: D000, D001, D002

**Decision**: Install only `ai-team` into Codex by default and keep the other sibling skills as internal workflow modules unless a maintainer explicitly installs them with `--all`.

**Context**: The user experience should present one coherent public skill-pack face, not a long list of separate workflow pieces.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Install every skill publicly | Maximum direct addressability | Skill list becomes crowded and breaks the pack mental model | Too noisy |
| Move all workflow logic into one giant SKILL.md | One visible skill | Harder to maintain and evolve safely | Too monolithic |
| Public `ai-team`, internal sibling modules (Chosen) | Clean public face with maintainable internal modules | Requires AI TEAM to load sibling docs as needed | Best balance |

**Consequences**:
- **Positive**: Codex shows one clear skill entry point for this pack.
- **Negative**: Direct `$project-developer`-style calls require `--all` installation mode if the maintainer wants them exposed.

**Implementation**: Updated `install-skills.sh` to public-only mode by default, added `--all`, and documented internal workflow modules under AI TEAM.

### D004 - 2026-04-08: Require Execution Policy And Completion Sync Discipline

**Status**: Active
**Made By**: codex
**Related**: D001, D003

**Decision**: AI TEAM must establish execution policy before deeper routing and must enforce immediate completion tracking according to that policy.

**Context**: Some internal modules assume GitHub auth, repository setup, or external tooling. The public AI TEAM skill needs an explicit rule set so GitHub is used only when desired, local-only projects stay fully local, and completed work is recorded consistently.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Let each internal module decide ad hoc | Minimal central logic | Inconsistent behavior and hidden GitHub assumptions | Too loose |
| Always assume GitHub-first | Simple global rule | Breaks local-only projects | Too rigid |
| Central execution policy in AI TEAM (Chosen) | Predictable, explicit, and easy to audit | Requires one more preflight step | Best fit |

**Consequences**:
- **Positive**: AI TEAM now knows when GitHub auth is required, when local-only mode applies, and when task completion must sync immediately.
- **Negative**: Preflight is slightly more structured before work begins.

**Implementation**: Added `skills/ai-team/references/execution-policy.md`, updated AI TEAM routing rules, gated GitHub modules behind `github_enabled`, and documented immediate GitHub Project card sync on task completion.

### D005 - 2026-04-08: Keep Local Memory Updates Mandatory In GitHub Mode

**Status**: Active
**Made By**: codex
**Related**: D004

**Decision**: Even when `tracking_mode=github_enabled`, completed work must still update `memory/PROJECT.md`, `backlog/BACKLOG.md`, and `timeline/ROADMAP.md` when those artifacts are affected.

**Context**: GitHub is useful for operational tracking and collaboration, but the local memory bank remains the canonical long-term context layer for AI continuity across sessions.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| GitHub-only updates in GitHub mode | Less duplicate writing | Local context decays and future sessions lose continuity | Too risky |
| Local-only updates in every mode | Simple memory story | Loses live operational visibility in GitHub projects | Too weak |
| GitHub plus local memory updates (Chosen) | Keeps operational visibility and long-term continuity together | Slightly more update work per completed task | Best fit |

**Consequences**:
- **Positive**: GitHub-connected projects still preserve rich local AI memory and planning history.
- **Negative**: Completion steps are more disciplined and slightly heavier.

**Implementation**: Updated AI TEAM execution policy, GitHub operations docs, governance rules, and top-level guides to require both GitHub sync and local memory updates.

### D006 - 2026-04-08: Back AI TEAM Policy With Deterministic Enforcement Scripts

**Status**: Active
**Made By**: codex
**Related**: D004, D005

**Decision**: Add dedicated scripts for AI TEAM preflight, local completion sync, and GitHub task sync so the operating rules can be executed consistently instead of remaining guidance only.

**Context**: The AI TEAM policy already distinguishes GitHub and local-only modes, requires tool readiness, and mandates dual-write tracking in GitHub mode. Without deterministic scripts, those rules still depend too much on agent discipline.

**Alternatives Considered**:
| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Keep policy text only | Minimal files | Easy for agents to skip or apply inconsistently | Too weak |
| Push all logic into one large shell script | One entry point | Harder to reuse from different stages of the workflow | Too monolithic |
| Separate preflight and sync scripts (Chosen) | Clear responsibilities, reusable from AI TEAM, easy to audit | Adds a few more scripts to maintain | Best balance |

**Consequences**:
- **Positive**: AI TEAM now has a deterministic way to block missing tooling, update local memory on completion, and sync GitHub issue/project state when enabled.
- **Negative**: GitHub mode now clearly depends on `gh` plus authentication until an API-only path is added later.

**Implementation**: Added `scripts/preflight-check.sh`, `scripts/sync-completion.sh`, `scripts/sync-github-task.sh`, plus wrapper scripts under `skills/ai-team/scripts/`, and updated AI TEAM docs to reference them directly.

---

## Deprecated Decisions

### DXXX - YYYY-MM-DD: [Title]

**Status**: Deprecated on YYYY-MM-DD
**Replaced By**: DYYY
**Original Date**: YYYY-MM-DD

**Original Decision**: 

**Why Deprecated**: 

---

## Quick Reference

| ID | Decision | Date | Status |
|----|----------|------|--------|
| D000 | Keep skill-router as a bootstrap routing alias | 2026-04-08 | Active |
| D001 | Use AI TEAM as the canonical entry point | 2026-04-08 | Active |
| D002 | Make delivery analytics a dedicated AI-team skill | 2026-04-08 | Active |
| D003 | Expose only AI TEAM publicly by default | 2026-04-08 | Active |
| D004 | Require execution policy and completion sync discipline | 2026-04-08 | Active |
| D005 | Keep local memory updates mandatory in GitHub mode | 2026-04-08 | Active |
| D006 | Back AI TEAM policy with deterministic enforcement scripts | 2026-04-08 | Active |

---

*Last updated: 2026-04-08*
