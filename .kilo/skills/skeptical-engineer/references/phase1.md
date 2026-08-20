# Phase 1: Analysis & Decomposition (Understand & Plan Units)

**Description:** Analysis & Decomposition (Understand & Plan Units)

## Steps

1. **Parse the Request:** Restate what is being asked in your own words and identify the main goals.
2. **Read Context:** Review relevant files, configs, or prior conversations to ground yourself. Use `read` / `grep` to find context, but avoid lengthy outputs.
3. **Identify Building Blocks:** List distinct components or concepts involved in the task. A Building Block can be a module, class/function, external API, database, framework, etc.
4. **Label Known/Unknown:** Mark each building block **Known** (standard tech or found in repo) or **Unknown** (anything needing external info or possibly outdated in model memory). EVERYTHING you are EVEN SLIGHTLY UNSURE about is **UNKNOWN** by default.
5. **Stoplight Risk Assessment:** Assign an overall risk level – **GREEN**, **YELLOW**, or **RED** – based on scope:
   - GREEN: Local changes, low impact, few uncertainties.
   - YELLOW: Touches multiple parts or involves moderate uncertainty (e.g. adding a library).
   - RED: High risk or complexity (major refactor, security-sensitive, multi-repo coordination).
   Provide a brief rationale.
6. **Rigor Requirements:** State required rigor given risk:
   - GREEN: minimal tests (lint/format + a couple of targeted tests).
   - YELLOW: thorough tests (lint, type-check if typed, run affected suites) and possibly an ADR.
   - RED: full test suite, build, integration tests, and definitely an ADR + rollback plan.
7. **List Unknowns for Verification:** Compile the Unknowns list for Phase 2. If none, explicitly say "Unknowns list is empty".

## Exit Criteria

- Explicit list of Building Blocks, each marked Known or Unknown.
- A risk level chosen and justified.
- An Unknowns list ready (or explicitly "Unknowns: none").
- Outlined extra rigor steps needed based on risk.

## Output Format

```markdown
## Phase 1 Analysis

**Task Interpretation:** *<Rephrase the task>*

**Building Blocks:**
- A – Known/Unknown – brief explanation
- B – Known/Unknown – ...
- C – Known/Unknown – ...

**Risk Assessment:** <GREEN/YELLOW/RED> – *rationale*

**Required Rigor:** *<What testing/ADR is required based on risk>*

**Unknowns List:**
- <Unknown 1>
- <Unknown 2>
```
(If no Unknowns, write "Unknowns List: none" and skip Phase 2.)
