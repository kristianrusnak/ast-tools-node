---
description: "Analyze repo (deep, >1 level) and build a layered set of per-folder AGENTS.md files that are DRY against existing skills/rules/commands, present a tree, and reference them from a cleaned root AGENTS.md"
---

Analyze the repository and build a layered set of `AGENTS.md` files instead of a single root file.

## Goal

1. Deep-scan the repo **recursively (more than one level deep)** to find folders genuinely different in character (different tech, different conventions, different kind of information).
2. For every candidate folder, check whether an existing skill, rule, slash command, or agent **already governs** it. This is mandatory — do not restate what is already governed.
3. Decide per folder: **self-contained** (no governing source) vs **thin dispatcher** (governed source exists — reference it, keep the file "minified but present"). Never silently skip a folder that needs an `AGENTS.md`.
4. Show the user the proposed deep tree before writing anything, explain each node, and get confirmation.
5. Reference every created `AGENTS.md` from a dedicated last chapter in the root `AGENTS.md`, and clean the root file so it no longer duplicates per-folder detail.

## Phase 0 — Investigate

Read the highest-value sources first, before leaf files:

- `README*`, root manifests, workspace config, lockfiles
- build / test / lint / formatter / typecheck / codegen config
- CI workflows, pre-commit / task-runner config
- existing instruction files (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules/`, `.cursorrules`, `.github/copilot-instructions.md`)
- repo-local config (`kilo.json`, `.roo/`, `package.json`, etc.)

Trust executable sources over prose. If docs conflict with config or scripts, trust the executable source and only keep what you can verify.

## Phase 1 — Inventory existing governance (do this BEFORE choosing folders)

Every candidate node's `AGENTS.md` must be checked against what already governs its folder. Look for **skills, rules, slash commands, and agents** in every instruction location present in the repo:

- `.kilo/skills/*/SKILL.md`, `.kilo/commands/*.md`, `.kilo/rules/*.md`, `.kilo/agents/*.md`
- `.roo/skills/`, `.roo/commands/`, `.roo/rules/`, `.roo/rules-code/`
- `.github/copilot-instructions.md`, `.cursor/rules/`, `.cursorrules`, `CLAUDE.md`
- any nested `AGENTS.md` that already exists under the candidate folder

For each folder, answer:

- Is there a skill whose `description` clearly covers work in this folder? (e.g. `write-detector` for a detector dir, `doc-guard` for a docs dir)
- Is there a slash command that drives the workflow there? (e.g. `/report-detectors`, `/write-test`)
- Is there a rule that applies repo-wide to this kind of content? (e.g. `ai-generated-content`, `git-commits`)

**Decision rule (DRY):**

| Governance found | AGENTS.md style |
|---|---|
| A skill/command/rules **fully** governs the folder | **Thin dispatcher**: state the governing source, how to load it, then add ONLY the 1–3 repo-specific facts the skill does not carry |
| Partially governed / only a repo-wide rule applies | **Thin-to-medium**: reference the rule, add the folder-specific facts |
| Nothing governs the folder | **Self-contained**: full, high-signal folder guidance |

**Never skip** a folder that warrants an `AGENTS.md` because a skill exists — the `AGENTS.md` is the always-read entry point that tells the agent *"this area is governed by X — load it."* It must reference the skill, not re-implement it)Skip. A one-line "governed by X" is DRY; pasting the skill's body is not.

## Phase 2 — Identify candidate folders (deep, recursive)

Do **not** stop at the top level. Recursively descend at least 2–3 levels and look for genuinely distinct subfolders. Typical split triggers — at ANY depth:

- Tests vs production code — different frameworks, fixtures, snapshot workflows, integration prerequisites, or different run commands.
- Different technologies / layers — backend vs frontend vs DB migrations vs infra vs a **vendored third-party tool tree** vs a **nested standalone package** with its own `package.json`/`node_modules`.
- A different **language** than the parent (e.g. a Python sub-project inside a shell/Node repo, a JArchi `.ajs` project).
- Distinct tools / build systems — monorepo packages with independent toolchains, codegen, or generated artifacts.
- Documentation / business-rule folders — prose/domain info, not code.
- Anything that would otherwise force the parent `AGENTS.md` to be huge or vague.

Scan signals that reveal "this is a different world in here":

- A nested `package.json` / `requirements.txt` / `pyproject.toml` / its own `node_modules`
- A directory named after a third-party tool (`external/`, `vendor/`, `third_party/`)
- A subdirectory whose file extensions differ from its siblings (`.ajs`, `.py`, `.scm`, `.j2`)
- A `bin/` + own entry points inside a subfolder
- A generated/derived data directory (`db-data/`, `out/`, `build/`)

For each candidate, ask:

- Does the folder use a different stack or commands from its siblings or parent?
- Does it have different conventions (naming, imports, error handling, testing)?
- Does it have non-obvious gotchas (generated code, hidden coupling, env quirks, "don't edit" boundaries)?
- Would an agent likely miss this without help?
- Would keeping this knowledge in the parent file make it a confusing "god config"?

Keep a candidate only if the answer is yes. If the repo is simple, keep the tree small — do not create a file per directory. Prefer to stop where folders start sharing the same stack and conventions.

## Phase 3 — Present the deep tree and get confirmation

Present the proposed split as a **nested** tree (showing the real depth), with the governance verdict per node. Example shape:

```
repo/
├── AGENTS.md                      (root: global + Folder Guides index)
├── src/AGENTS.md                  (self-contained: backend stack, entrypoints)
├── src/tests/AGENTS.md            (self-contained: pytest, fixtures, single-test cmd)
├── packages/web/AGENTS.md         (thin dispatcher → /dev-stack skill)
├── tools/AGENTS.md                (self-contained: product architecture)
│   ├── tools/detect/AGENTS.md     (thin dispatcher → write-detector skill)
│   ├── tools/query/AGENTS.md      (thin dispatcher → cindy-query skill)
│   ├── tools/external/AGENTS.md   (self-contained: vendored 3rd-party, don't edit)
│   └── tools/report/detector-report/AGENTS.md  (self-contained: Python sub-project)
├── db-data/AGENTS.md              (thin dispatcher → rebuild-model skill)
└── docs/AGENTS.md                 (thin dispatcher → doc-guard skill)
```

For each node give a one-line reason it is worth its own `AGENTS.md` **and** one line stating which skill/rule/command governs it (or "self-contained — nothing governs"). Use the `question` tool to confirm the set and let the user add, remove, or rename nodes. Do not proceed without confirmation.

## Phase 4 — Write the per-folder AGENTS.md files

For each confirmed folder, create or improve `<folder>/AGENTS.md`.

**First line of every file:**

```
# AGENTS.md — <folder description>
```

**If governed (thin dispatcher):**

- Line 2+: state the governing source and how to load it. Example:
  `Detector authoring is governed by the \`write-detector\` skill — read SKILL.md + learn.md first (penalized if ignored); use \`/detectors\` for metadata.`
- Then add ONLY the repo-specific facts the skill does NOT carry (paths, env vars, command order, gotchas).
- Keep it genuinely short ("minified but present"). If the governing skill is comprehensive, this file can be 5–15 lines.

**If not governed (self-contained):**

- exact commands (build / lint / test / run), especially how to run a single test or a single package within that folder
- required command order when it matters (`lint -> typecheck -> test`)
- non-obvious architecture / entrypoints / package boundaries
- toolchain quirks (generated code, migrations, codegen, env loading, dev servers)
- folder-specific conventions that differ from defaults
- testing quirks (fixtures, integration prerequisites, snapshots, flaky/expensive suites)
- gotchas and operational requirements, including any "don't edit — generated/vendored" boundaries

Exclude generic advice, tutorials, exhaustive file trees, obvious language conventions, and speculative or unverifiable claims. When in doubt, omit.

Do NOT copy skill/command content into the `AGENTS.md`. Reference the source by name and path; keep the reference DRY.

## Phase 5 — Clean and update the root AGENTS.md

1. Read the existing root `AGENTS.md` if present.
2. Move any knowledge that now belongs in a child `AGENTS.md` into that child file. The child becomes the source of truth for its subtree.
3. Delete content from the root that is fully covered by a child file. The root keeps only what is genuinely global (workspace-wide commands, cross-cutting conventions, repo-wide gotchas).
4. Append a final chapter `## Folder Guides` (or `## Per-Folder AGENTS.md`) that references every child `AGENTS.md` with a short one-line note, e.g.:

   ```markdown
   ## Folder Guides

   Detailed, folder-specific guidance lives in per-folder AGENTS.md files:

   - [`src/AGENTS.md`](src/AGENTS.md) — core business logic, stack, entrypoints
   - [`tools/detect/AGENTS.md`](tools/detect/AGENTS.md) — detector engine (governed by write-detector skill)
   - [`tools/external/AGENTS.md`](tools/external/AGENTS.md) — vendored 3rd-party tooling; don't edit
   - [`docs/AGENTS.md`](docs/AGENTS.md) — documentation conventions (governed by doc-guard skill)
   ```

   The references chapter must be the last chapter of the root `AGENTS.md`.

5. If the root file does not exist, create it with the global guidance plus the final "Folder Guides" chapter.

## Phase 6 — Verify and summarise

- Confirm each child `AGENTS.md` exists and is referenced from the root index chapter.
- Confirm each governed folder's `AGENTS.md` references its governing skill/rule/command and does NOT duplicate it.
- Confirm the root file no longer duplicates child content.
- Report to the user:

  ```
  Created/updated N AGENTS.md files:
    - <path> — <reason> (governed by <skill/command>, thin dispatcher) | (self-contained)
    - ...
  Root AGENTS.md: <path> (global guidance + Folder Guides index)
  ```

## Rules

- Ask, don't assume: confirm the tree before writing (via `question`).
- Non-obvious only: every kept line must be high-signal and repo-specific.
- DRY against governance: if a skill/rule/command already governs a folder, reference it — never restate it. But still create the `AGENTS.md` (minified) so the folder is discoverable and indexed.
- Source of truth: prefer executable sources; verify everything.
- Comprehensive where it matters: a folder with its own stack gets real depth, but a simple repo gets a simple tree.
- Deep not shallow: scan recursively, >1 level; stop where folders share stack and conventions.
- Never leave stale or duplicated detail in the root file.
- Respect existing instruction files (`CLAUDE.md`, `.cursor/rules/`, skills, commands, rules): preserve verified useful guidance, reconcile conflicts.

## Example

A monorepo with backend + frontend + separate test infra, plus governed docs, might end up with:

```
repo/
├── AGENTS.md            # global: mono-repo layout, shared tooling, CI, + Folder Guides index
├── src/AGENTS.md        # backend: Go stack, API entrypoints, DB access patterns (self-contained)
├── src/tests/AGENTS.md  # tests: pytest, fixtures, how to run a single test (self-contained)
├── web/AGENTS.md        # frontend: Vite/React, dev server, styling conventions (thin → /web-dev skill)
├── web/vendor/AGENTS.md # vendored third-party JS, don't edit (self-contained)
└── docs/AGENTS.md       # docs: non-code prose (thin → doc-guard skill)
```

The root no longer explains how to run frontend tests or the backend stack — it points to the right `AGENTS.md` instead, and each child defers to its governing skill/command instead of duplicating it.
