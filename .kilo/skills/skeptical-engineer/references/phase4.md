# Phase 4: Implementation & Quality Gates (Write Code & Test)

**Description:** Implementation & Quality Gates (Write Code & Test)

**Goal:** Implement the planned changes with minimal diffs, and verify with automated checks.

## Guidelines

- Stick to the Phase 3 plan. Implement step by step, ensuring each change aligns with the proposal.
- Aim for **minimal diffs**: don't refactor unrelated areas or add cosmetic out-of-scope changes.
- Use the **canonical shell** determined in Phase 0 for any command snippets/scripts.
- If you hit an error or unexpected result (test fails, build error), **STOP coding**:
  - Switch back to Phase 2 to investigate the error or update assumptions.
  - Adjust the Phase 3 plan if needed, then resume Phase 4.
  - (You may loop: troubleshoot, re-plan on the fly, then continue.)
- Use known-good command patterns from `.skeptical-engineer/commands.md` or `AGENTS.md` to avoid shell drift.

## Quality Gates (by risk)

- **GREEN:** Code compiles, lints/formats, and targeted tests pass.
- **YELLOW:** Above + broader tests (affected module suites) and type-checking/compile.
- **RED:** Above + full test suite, integration tests, build, and possibly a smoke test (run the app). Consider testing the rollback procedure.

## Execution

1. Apply code changes with `edit`/`write`. After each significant edit, run targeted tests to confirm nothing broke.
2. Once all changes are done, run the suite of checks:
   - Lint/format (`npm run lint`, `dotnet format`, `clang-format`, etc.).
   - Type-checking or compilation (if applicable).
   - Tests (fast unit vs slower integration as needed).
   - Build (C++/C#).
   - Smoke test if it's a running system.
3. Gather results from each command and note pass/fail with relevant output snippets.
4. If anything failed: fix trivial issues, or for design issues revert to planning/verification.

## Exit Criteria

- All planned code changes applied.
- All required quality checks for the risk level executed, outcomes noted, ideally all pass.
- If checks pass, ready for Phase 5. If some checks fail and can't be quickly fixed, mark **Blocked** or incomplete and seek user input.

## Output Format

```markdown
## Phase 4 Implementation

### Changes Made
- `path/to/file1.ext` – Implemented X (details…)
- `path/to/file2.ext` – Modified Y to do Z

### Verification of Changes
- `module A` logic change – covered by unit test `ATest` ✅

### Quality Gates Run
- **Lint:** `npm run lint` – ✅ No issues
- **Typecheck:** `tsc --noEmit` – ✅ 0 errors
- **Tests:** `npm test` – ✅ 150/150 passed
- **Build:** `dotnet build` – ⚠️ 1 warning, 0 errors
- **Smoke:** App started locally – ✅ OK

### Issues Encountered
- *None.* (or list problems and how they were addressed)
```
