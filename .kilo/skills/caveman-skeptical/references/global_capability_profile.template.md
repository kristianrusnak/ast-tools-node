---
kind: csa-global-memory
layer: global
role: Layer-3 cross-project capability-gap ledger
written_by: csa-scribe (Phase 6, Output 6); self-improvement-apply (proposals log)
read_by: csa-session-init (Phase 0); self-improvement-apply
gitignored: true
created: 2026-08-18
---

# Global Capability Profile

Cross-project memory tier for the CSA pipeline. Holds observations that are
**project-agnostic** (survive the "deleted this repo" litmus). Project-specific
facts stay in the per-repo `.caveman-skeptical/`; do NOT store those here.

Status of this file: LIVE ACCUMULATOR. Scribe appends rows; session-init reads
them and surfaces "Recurring Global Gaps". Do not hand-delete rows — retire via
the proposal log (below) instead, so the paper trail stays intact.

## Field guide

- **Slug**: kebab-case id, reused when the same gap recurs (lets us count distinct projects).
- **Classification**: `general` (proven across ≥2 projects) | `local` (project-specific; kept here only temporarily before routing home) | `hypothesis` (seen in 1 project; not promotable yet).
- **Distinct-count**: number of DISTINCT projects where observed. Promotion threshold = ≥2.
- **Proposal-ID**: link to a `.caveman-skeptical/improvement_proposals/YYYY-MM-DD-NNN.md` once one exists; `—` until then.

## Observed Behavior Gaps

| Slug | Gap | Classification | Projects | Distinct-count | First-seen | Last-seen | Proposal-ID | Status |
|---|---|---|---|---|---|---|---|---|
| _(none yet)_ | | | | | | | | |

## Environment Patterns

| Pattern | Evidence | Environments / platforms | Frequency | Notes |
|---|---|---|---|---|
| _(none yet)_ | | | | |

## Applied / Rejected Proposals Log

Appended by `self-improvement-apply` (steps 6–7). Newest first.

| Proposal-ID | Date | Target file | Outcome | Violated principle (if rejected) | Session | Notes |
|---|---|---|---|---|---|---|
| _(none yet)_ | | | | | | |

## Backlog note
Any row promoted to `proposal` but not yet applied belongs in the matching
`.caveman-skeptical/improvement_proposals/` of the project where it was raised;
this profile tracks the *observation*, the proposal file tracks the *change*.
