# Codex Agent Instructions

## Memory First

Before doing anything substantial:

1. If the current project has neither `memory/PROJECT.md` nor `PROJECT.md`, bootstrap `memory/` from this template first.
2. Then read:

   - `PROJECT.md`
   - `DECISIONS.md`
   - `context/conventions.md`

Review additional `context/` and `requirements/` files when the task depends on them.

For fresh projects, prefer `$ai-team` as the first-call entry skill. Internal workflow modules should normally stay behind `ai-team` rather than being treated as separate public skills.

## Working Rules

- Understand the current project state before making changes.
- Follow the documented conventions and recent decisions.
- Prefer the matching Codex skill from `skills/` when the workflow is covered there.
- Keep changes aligned with the current project phase and next steps.

## Session End Rules

Before finishing a task:

1. Add a session entry to `PROJECT.md`.
2. Record any important new decision in `DECISIONS.md`.
3. Update task or phase status if it changed.
4. Leave clear next steps for the next session.

Use `codex` as the agent name in session history entries.
