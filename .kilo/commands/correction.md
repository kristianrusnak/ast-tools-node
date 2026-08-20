---
description: Session Retro – Extract all user feedback and quirks, update durable memory.
argument-hint: optional extra notes
---
# Skeptical Retro (Post-Session Review or immediate breakpoint intervention)

**Goal:** Analyze the entire session to catch any feedback or lessons that might have been overlooked and ensure they are persisted to `.skeptical-engineer`.

**Process:**
1. **Scan Conversation:** Go through the user’s messages for any corrections, preferences, or important clarifications. Examples:
   - Environment details (“Actually, this is a Windows project, not Linux.”)
   - Command/style preferences (“Use yarn, not npm”; “Don’t use `&&` in scripts”).
   - Code style notes (“We prefer early returns in this codebase”).
   - Any time the user said “Don’t do X” or “I want Y instead”.
2. **Scan Recent Work Outputs:** Check the solutions and code for any patterns where the agent struggled or the user intervened.
3. **Update Memory Files:**
   - **project_snapshot.md:** Ensure OS, shell, and any key environment info are correct (if the user gave new info, update it).
   - **preferences.md:** Add any new rules/preferences found (e.g., the user consistently asked for more comments – note a preference for verbose comments).
   - **pitfalls.md:** Add entries for any recurring mistakes:
     - E.g., if across tasks the agent often picks the wrong import and the user corrects it, log that pattern as a pitfall with prevention.
   - **commands.md:** Add any new command patterns the user provided or corrected.
   - **session_notes/<date>.md:** Summarize what changed in this session beyond a single task, if applicable.
4. **Update AGENTS.md:** If the user’s feedback indicates a project-wide policy change that should be visible to all contributors, consider updating `AGENTS.md`. (For example, “All scripts must be cross-platform” could be added to the human-facing agents doc.)
5. **Output a Brief Report:** List the items captured (bulleted), the files updated, and highlight any **new rules in effect** due to this retro.

**Output Format:**
```markdown
## Session Retro Summary

**Items Captured:**
- Noted preference for shorter function names (user feedback).
- Hard rule added: Avoid global state (from code review comment).
- Added pitfall: Misconfigured DB connection string (seen in multiple attempts).

**Files Modified:**
- `.skeptical-engineer/preferences.md` (added 2 preferences, 1 hard rule)
- `.skeptical-engineer/pitfalls.md` (new entry about DB connection)
- `.skeptical-engineer/commands.md` (documented `yarn start` command)
- `.skeptical-engineer/session_notes/2026-02-06.md` (appended session summary)

**Effective Rules Update:**
- **Hard Rule:** No direct DB calls in UI layer (from feedback).
```