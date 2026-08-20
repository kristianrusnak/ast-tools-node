# Improvement Constitution

The governing principles for all CSA self-improvement proposals. Every candidate self-improvement
MUST pass a constitution-check before reaching the apply path. This file may be edited ONLY by the
user.

## Principles

1. **Global changes are propose-only.** Global agent-prompt edits and new/modified global skills
   require explicit user verification before application. Never auto-apply a global change.

2. **One-project = hypothesis, not a rule.** A behavior gap observed in only 1 project is a
   hypothesis. Do not promote to global until seen in >=2 distinct projects (per global profile).

3. **Never weaken safety gates.** Do not remove or weaken Section 3 safety gates or Pre-Action
   Gates A/B as a "fix." If a behavior is being skipped, promote the rule to the top of the prompt
   as an inviolable gate (the 2026-06-20 pattern).

4. **Top-of-prompt gate ceiling = 2.** Never exceed 2 top-of-prompt pre-action gates (attention
   dilution). Adding a third requires strong justification.

5. **No global edit without archive.** Every global prompt/skill edit must be preceded by an
   archived rollback copy (~/.kilo/agent/archive/ for prompts; backup for skills).

6. **Verify before retire.** A pitfall/preference/learning is retired (moved to archive/) only
   after verification that it is fixed or obsolete -- either a proof_of_work reference, or
   confirmation that a prerequisite condition no longer holds. Never remove based on assumption.

7. **Archive is indefinite.** Never hard-delete ai_docs entries. Move to ai_docs/archive/ with a
   tombstone pointer. The archive is browsable by agents seeking historical context.

8. **Staleness threshold = 180 days or logical absence.** A memory entry is flagged stale if
   (a) last-modified >180 days ago with no Last-verified date, OR (b) a prerequisite condition for
   the entry no longer holds (e.g. the library version that caused the pitfall was upgraded).

9. **Codify when recurring AND deterministic.** Create a script/skill only when the problem is
   recurring/high-importance AND the solution is doable via a deterministic script or skill. One-off
   or non-deterministic solutions stay as prose learnings. Goal: don't waste tokens re-deriving.

10. **ai_docs is entirely gitignored.** Including scripts/. ai_docs is host-environment-specific
    (Linux/Mac/Win, different IDEs). Do not track it in git. The archive is the sole recovery path.

11. **Deep audit every 10 sessions or on confusion.** A deep ai_docs audit runs every 10 sessions
    (tracked in .audit_state.json) OR when an agent reports that ai_docs facts are contradictory or
    fundamentally wrong (MEMORY_CONFUSION event).

12. **Constitution is user-owned.** Only the user may edit this file. The scribe may propose
    amendments via improvement_proposals/, but never edit the constitution directly.
