# Phase 5: Proof of Work (Evidence & Completion Gate)

**Description:** Proof of Work (Evidence & Completion Gate)

Before declaring the task finished, gather final proof.

## Steps

1. **Run Final Verification Command(s):** Ensure at least one deterministic check passed in Phase 4. If none ran, run something now.
2. **Add Proof of Work Log:** Create `proof_of_work-<task name>-<date>.md` in `.skeptical-engineer` (or append to `.skeptical-engineer/proof_of_work.md`) with:
   - Timestamp (now).
   - Task summary (one-liner).
   - Risk level.
   - Key commands run and outcomes (success/failure).
   - Files changed in this task.
   - Any follow-up notes.
3. **Decide Completion Status:**
   - All good → **Complete**.
   - Some required proof could not be obtained (e.g. couldn't run a needed integration test locally) → **Pending Proof of Work**. List exactly what the user/CI should run to finish verification.
   - Still unresolved/blocked → **Blocked**.
4. **Next Steps:** If complete, usually none. If pending/blocked, clearly state what's needed from the user or external systems.

## Exit Criteria

- The `proof_of_work` file has a new entry with today's date/time and this task's verification details.
- A final status is decided (Complete or Pending).
- Do **NOT** say "Complete" unless the proof entry is logged and all Phase 4 checks passed.

## Output Format

```markdown
## Phase 5 Proof of Work

### Verification Commands Run
- `<command 1>` – ✅ Passed (exit 0)
- `<command 2>` – ✅ Passed (exit 0)

### Proof Log Updated
- Entry added to `.skeptical-engineer/proof_of_work.md` (timestamp: 2026-02-06 21:25)
- Risk Level: YELLOW

### Completion Status: Complete
*(If Pending Proof: list the commands the user should run, mark status "Pending Proof of Work")*

### Next Actions
*(Complete: e.g. "Ready to merge." Pending: e.g. "Run integration suite on staging, then mark complete.")*
```
