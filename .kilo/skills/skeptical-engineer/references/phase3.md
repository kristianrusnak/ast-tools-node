# Phase 3: Synthesis & Planning (Design the Solution)

**Description:** Synthesis & Planning (Design the Solution)

Combine everything learned into a solid plan for execution.

## Steps

1. **Synthesize Context:** Summarize the task and key constraints:
   - User's request and goal.
   - Relevant repo context from Phase 1 (existing code affected).
   - Rules/preferences that impact the approach (from `.skeptical-engineer/preferences.md` or `AGENTS.md`).
   - Verified facts from Phase 2 that matter (e.g. "Library X v1.4 requires Y").
2. **Outline Implementation Steps:** List a concrete sequence of steps, each a small achievable change (e.g. "Add function `fooBar()` in `utils.js`"). Include which repo each step affects if multi-repo.
3. **Enumerate File Changes:** For each step, list files to create/modify with paths (repo-qualified if multi-repo) and a brief note of the change.
4. **Acceptance Criteria:** List testable conditions that prove the solution works (e.g. "API returns correct data for X", "all unit tests pass").
5. **Test Plan:** Describe when/how to test:
   - **During implementation:** targeted tests to run step-by-step.
   - **Before completion:** broad suites/checks appropriate to risk (full suite, integration, lint).
   - **Manual/special validation** for RED risks (extra review or security scan).
6. **Rollback Plan:** Especially for YELLOW/RED, outline how to undo changes (revert commit, migration rollback, feature flag). If trivial, state so.
7. **ADR Reminder:** If an ADR is required (per risk rules), note it must be written **before coding**. RED: definitely prepare an ADR. YELLOW: if a major decision like "Library A vs B", plan an ADR. You may draft the ADR in this phase.

## Exit Criteria

- A step-by-step plan covering implementation, testing, and rollback.
- Any required ADR is noted (and ideally created in `.skeptical-engineer/decisions/`).
- The plan addresses all acceptance criteria the user cares about.

## Output Format

```markdown
## Phase 3 Implementation Plan

### Synthesis
*<Summary of request, context, key verified facts/constraints>*

### Implementation Steps
1. *Step 1:* ... (file1, file2 will change to do X)
2. *Step 2:* ... (modify file3 to add Y)
3. *Step 3:* ... (in repo2, update fileA to accommodate X)

### Files to Create/Modify
- `src/featureX/module1.js` – add new function `doThing()`
- `src/featureX/test_module1.js` – create tests for `doThing`
- `repo2/lib/foo.cpp` – adjust logic for new data format

### Acceptance Criteria
- [ ] Feature X returns correct output for inputs A, B, C.
- [ ] Unit tests covering X pass.
- [ ] No regression in existing test suite.

### Test Plan
- **During implementation:** Run `npm test module1` after Step 2; `dotnet test SomeProject` after repo2 changes.
- **Before completion:** Full test suite (`npm test`), build (`make all`), lint in both.

### Rollback Plan
*Revert the commit or feature-flag the changes. DB changes are backward-compatible.*

### ADR Required?
Yes – RED risk change affecting core auth; create `.skeptical-engineer/decisions/ADR-auth-method.md` before proceeding.
```
