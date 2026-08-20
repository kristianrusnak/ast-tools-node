# Phase 0: Bootstrap & Environment Setup

**Description:** Bootstrap repository for AI agent (AGENTS.md, .skeptical-engineer/, env)

**Goal:** Prepare or read governance and memory files, and determine the environment.

## Steps

1. **Check & Create Governance Files**: If `AGENTS.md` is missing, create it with a basic policy stating the AI rules and mode. Ensure `.gitignore` includes `.skeptical-engineer/`. If it exists, read it.
2. **Check & Create Durable Memory**: If the `.skeptical-engineer/` folder or key files are present, read them. If any are missing entirely, create them with starter templates:
   - `.skeptical-engineer/preferences.md` – sections **Hard Rules**, **Preferences**, **Contextual** (empty to start).
   - `.skeptical-engineer/commands.md` – placeholders for common commands (Install, Test, Lint, Build).
   - `.skeptical-engineer/pitfalls.md` – empty template (Date, Symptom, Fix, Prevention columns).
   - `.skeptical-engineer/project_snapshot.md` – sections for Stack, Package manager, Entry points, Environments.
   - `.skeptical-engineer/codebase_map.md` – outline of directories and key flows.
   - `.skeptical-engineer/risk_register.md` – empty table for recording risk level of each task.
   - `.skeptical-engineer/proof_of_work.md` – empty log for proof-of-work entries.
   - `.skeptical-engineer/session_notes/` – folder for session notes.
   - `.skeptical-engineer/decisions/` – folder for ADRs (include a template if not present).
3. **Determine Environment**: Identify OS and shell. Detect clues (e.g. `pwsh` scripts indicate PowerShell on Windows). If unclear, run `uname` or ask the user. Record **OS, Shell, Shell Version** in `.skeptical-engineer/project_snapshot.md` and note the canonical shell (e.g. *PowerShell Core 7* or *bash*).
4. **Output Summary**: Report which files were created/updated, the canonical environment, and any existing project policies found.

## Exit Criteria

- `AGENTS.md` exists in the root (or a clear reason it cannot be created).
- `.skeptical-engineer/` exists with all key files and is listed in `.gitignore`.
- Canonical OS and shell are identified and recorded.

## Output Format

```markdown
Phase 0 Bootstrap Complete

Created: .skeptical-engineer/ (initialized preferences.md, commands.md, ... )

Updated: .gitignore (added .skeptical-engineer/)

Environment: Windows 10, Shell: PowerShell 7.2

Found existing AGENTS.md (left unchanged)
```
