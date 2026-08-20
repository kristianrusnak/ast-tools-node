# Phase 6: Knowledge Capture (Learn & Update Memory)

**Description:** Knowledge Capture (Learn & Update Memory)

The task is done. Update persistent memory files with any new insights from this session.

## Updates

- **Preferences:** Update `.skeptical-engineer/preferences.md` with any new hard rules or preferences (e.g. "always use single-line comments" → Preferences; "never use eval" → Hard Rules). Organize by category if needed.
- **Commands:** Update `.skeptical-engineer/commands.md` with any known-good commands discovered (proper incantation for integration tests, new build step, etc.). Include expected outcomes if helpful.
- **Pitfalls:** If you hit a repeated mistake or noteworthy error, log it in `.skeptical-engineer/pitfalls.md`. Each entry has: **Date**, **Pitfall**, **Symptom**, **Cause**, **Fix**, **Prevention**. (e.g. "2026-02-06 – Used Linux `rm` in PowerShell. Fix: `Remove-Item`. Prevention: always use PowerShell commands in Windows.")
- **Risk Register:** Append an entry in `.skeptical-engineer/risk_register.md`: date, brief task description, final risk level, risks identified and how mitigated, which tests were run.
- **Session Notes:** Create/update `.skeptical-engineer/session_notes/<today>.md` with a short narrative: what was requested and delivered, key decisions (e.g. chose library X over Y), challenges encountered/resolved, and note that preferences/pitfalls were updated.

All updates should be **additive** (do not remove previous info; add new sections/bullets as needed).

## Feedback Hot Patch Reminder

If the user gave immediate corrections during Phase 0–5, they should already be captured. Double-check they're reflected in preferences or snapshot. If not, add them now.

## Output Format

```markdown
## Phase 6 Knowledge Capture

### Files Updated
- `.skeptical-engineer/preferences.md` – added "Use single quotes in YAML"
- `.skeptical-engineer/commands.md` – noted `npm run build:prod`
- `.skeptical-engineer/pitfalls.md` – added Windows path separator entry
- `.skeptical-engineer/risk_register.md` – logged task (2026-02-06, YELLOW)
- `.skeptical-engineer/session_notes/2026-02-06.md` – created summary note

### Key Learnings Captured
- Decided on standard Docker image naming (added as preference).
- Noted Windows requires PowerShell commands (added Hard Rule).
- Learned new test command for multi-repo scenario.

### Effective Rules Now in Force
- **Hard Rule:** Use PowerShell syntax for all CI scripts on this repo.
- **Preference:** Write commit messages in imperative mood.
```
