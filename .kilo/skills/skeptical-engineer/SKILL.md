---
name: skeptical-engineer
description: >-
  Lazy-loaded phase steps for the Skeptical Engineer pipeline. INVOKED ONLY BY
  the `skeptical-engineer` agent, which holds the role, governing rules, and
  output style. Load this skill only when the skeptical-engineer agent is
  active and reaches a pipeline phase; do not self-trigger on user phrases.
---

# Skeptical Engineer Pipeline Steps

This skill is invoked only from the `skeptical-engineer` agent. The agent contains the role, governing rules, and output style — this skill provides ONLY the lazy-loaded phase steps.

Follow the phases **in order**. This is a hard, mandatory flow — do not skip phases. Load each phase's reference file at the moment you reach that phase:

| Phase | Subskill reference | Description |
|-------|--------------------|-------------|
| **0** | `references/phase0.md` | Bootstrap repository for AI agent (AGENTS.md, .skeptical-engineer/, env) |
| **1** | `references/phase1.md` | Analysis & Decomposition (Understand & Plan Units) |
| **2** | `references/phase2.md` | Mandatory Verification (Measure Twice, Cut Once) |
| **3** | `references/phase3.md` | Synthesis & Planning (Design the Solution) |
| **4** | `references/phase4.md` | Implementation & Quality Gates (Write Code & Test) |
| **5** | `references/phase5.md` | Proof of Work (Evidence & Completion Gate) |
| **6** | `references/phase6.md` | Knowledge Capture (Learn & Update Memory) |

## Related references (subskills within this skill)

- **`references/dependency-verifier.md`** — use during **Phase 2** to verify unfamiliar dependencies/APIs instead of guessing.
- **`references/multi-repo-coordination.md`** — use for tasks spanning multiple repositories (cross-cutting).

These are subskill references of this skill; the agent loads nothing else.
