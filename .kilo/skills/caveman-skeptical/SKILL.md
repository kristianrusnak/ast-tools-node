---
name: caveman-skeptical
description: >-
  Lazy-loaded reference for the Caveman Skeptical Agent (CSA) pipeline. INVOKED
  ONLY BY the `csa` agents (orchestrator + specialists), which hold the role,
  governing rules, and output style. Load this skill only when a CSA agent is
  active and needs pipeline or protocol detail; do not self-trigger on user
  phrases.
---

# Caveman Skeptical Agent (CSA) — References

This skill is invoked only from the CSA agent family. The agents contain the role, governing rules, and output style — this skill provides ONLY the lazy-loaded reference material. Load a reference at the moment it is needed; do not preload everything.

| Load when | Subskill reference | What it provides |
|-----------|--------------------|------------------|
| **Orchestrator, any phase** | `references/caveman-skeptical-agent.md` | The full CSA pipeline: orchestrator + 5 specialist subagents, phases 0–6, gate rules, pre-action gates (delegation + MCP-first), proactive memory, fast path, agent roster + model routing, MCP tool awareness, self-improvement system, caveman rules, memory-files reference, gate summary, and transferable rules |
| **After user confirms a proposal** | `references/self-improvement-apply.md` | The gated apply protocol: archives the current target, applies the proposed edit, verifies (R5 + structural cap-check), updates the proposal status, and rolls back on failure — only dispatched after explicit user confirmation |
| **Scribe constitution-check / self-improvement** | `references/improvement_constitution.md` | The immutable Improvement Constitution — 12 governing principles every candidate self-improvement must pass. User-owned; never agent-edited |
| **Phase 0 bootstrap (session-init)** | `references/global_capability_profile.template.md` | The template for the global capability profile. Copied into `~/.config/kilo/agent_state/global_capability_profile.md` when that runtime file does not yet exist |

## Related references (subskills within this skill)

- **`references/caveman-skeptical-agent.md`** — the orchestrator's primary reference. Load it to get the pipeline map, agent roster, MCP tool routing, gate rules, and handoff protocols for any phase. The single main body of this skill.
- **`references/self-improvement-apply.md`** — the only other subskill. Loaded only when a pending `.caveman-skeptical/improvement_proposals/` entry has been confirmed by the user and an agent-prompt or skill change is being applied.
- **`references/improvement_constitution.md`** — the immutable constitution, lazy-loaded for any constitution-check (scribe Phase 6, self-improvement-apply, session-init awareness). User-owned; never edited by an agent.
- **`references/global_capability_profile.template.md`** — not loaded into context; copied by session-init at Phase 0 to bootstrap `~/.config/kilo/agent_state/global_capability_profile.md` if missing.

These are subskill references of this skill; the CSA agents load nothing else.
