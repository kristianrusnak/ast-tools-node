---
name: self-improvement-apply
description: >
  Gated apply protocol for CSA self-improvement proposals. Archives the current target, applies the
  proposed edit, verifies (R5 consistency + structural cap-check), and updates the proposal status.
  Never auto-invoked -- requires explicit user confirmation. Called by the orchestrator after user
  confirms a pending improvement_proposal.
---

# Self-Improvement Apply Protocol

## When to use
- A pending proposal in .caveman-skeptical/improvement_proposals/ has been confirmed by the user.
- The proposal proposes an agent-prompt edit (.kilo/agents/csa/*.md) or a skill change.

## Protocol (MUST follow in order)

1. **Constitution-check**: verify the proposal passes all principles in
   .kilo/skills/caveman-skeptical/references/improvement_constitution.md. Reject if any principle is violated.
2. **Archive the current target**:
   - Prompt edit: `cp .kilo/agents/csa/<file> .kilo/agents/archive/<file>.YYYY-MM-DD.md`
   - Skill edit: back up the current SKILL.md to `.kilo/agents/archive/skills/<name>.YYYY-MM-DD.md`
3. **Apply the edit**: execute the exact oldString->newString from the proposal.
4. **Verify**:
   - Re-read the edited file; confirm the edit applied cleanly.
   - Re-run R5 consistency check (model/roster consistency, no broken refs).
   - Structural cap-check: count top-of-prompt gates <= 2 (constitution principle 4).
5. **Update proposal status**: set status: applied, date, session id, applied-by.
6. **Update global profile**: log in the Applied/Rejected Proposals Log.
7. **Rollback** (if verification fails or user rejects post-hoc):
   - Restore the archived file.
   - Set proposal status: rolled-back.
   - Log in global profile.

## Safety
- NEVER auto-invoke. The orchestrator dispatches this skill ONLY after explicit user confirmation.
- Global prompt edits are HIGH blast-radius (every session, immediate) -- treat as RED risk.
- The archive is the sole rollback path (.caveman-skeptical and the global store at
  `~/.config/kilo/agent_state/` are gitignored; the constitution + skill references in
  .kilo/skills/caveman-skeptical/ are tracked).
