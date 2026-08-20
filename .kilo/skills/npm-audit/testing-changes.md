---
name: testing-changes
description: Testing strategy for npm dependency upgrades — how to verify that upgraded packages do not break production code.
---

<!-- Generated/modified by AI RooCode 3.53.0, used model google/claude-sonnet-4-6 -->

# Testing Strategy After npm Dependency Upgrades

This document defines the **mandatory testing strategy** to follow after applying any npm dependency upgrade or override as part of the npm-audit skill workflow.

---

## Why This Matters

When you upgrade a transitive dependency (via `overrides`, `npm audit fix`, or direct dep bump), you must verify that:
1. The **changed library** still works correctly at its new version
2. The **parent package** (which uses the changed library) still works correctly
3. The **production code** in this repo (which uses the parent package as CLI or API) still works correctly

This is an **upstream traversal**: changed dep → parent package → production usage.

---

## The Upstream Traversal Report

For every dependency change, produce a report in this format:

```
I am testing [PRODUCTION COMPONENT] because it uses [PARENT PACKAGE]
which contains [CHANGED DEPENDENCY] which I have upgraded from [OLD] to [NEW].
This is a [breaking/non-breaking] change because [reason].
The changed dependency is used in [PARENT PACKAGE] for [specific purpose].
```

### Example

```
I am testing `grasp` CLI (used in tools/detect/scripts2/*.sh for JS AST search)
because it uses `minimatch@3.1.2` which I have upgraded to `3.1.5`.
This is a NON-BREAKING change (patch release, only fixes ReDoS regex).
minimatch is used in grasp for file glob pattern matching (the -r recursive flag).
```

---

## Step-by-Step Testing Process

### Step 1 — Identify all changed dependencies

List every package that was upgraded (version before → after):

```bash
git diff HEAD -- package-lock.json | grep '"version"' | head -50
```

### Step 2 — For each changed dependency, find its parent packages

```bash
npm ls <changed-dep> 2>&1
```

Show the full tree — not just the package name, but the **full path** from root to the changed dep.

### Step 3 — For each parent package, find its usage in this repo

Search for CLI usage:
```bash
grep -r "<parent-package-cli-name>" . --include="*.sh" -l
grep -r "<parent-package-cli-name>" . --include="Makefile" -l
grep -r "<parent-package-cli-name>" . --include="*.md" -l
```

Search for API/module usage:
```bash
grep -r "require.*<parent-package>" . --include="*.js" -l
grep -r "from.*<parent-package>" . --include="*.ts" -l
```

### Step 4 — Classify the change

| Change type | Definition | Testing required |
|-------------|-----------|-----------------|
| Non-breaking | Patch/minor semver bump; only bug/security fixes | Smoke test the affected code path |
| Breaking | Major semver bump; API changes possible | Full regression test of all usages |
| Override | Transitive dep pinned; parent API unchanged | Smoke test the specific feature that uses the changed dep |

### Step 5 — Find or create realistic test samples

**Priority order:**
1. Find existing tests in the repo: `find . -name "*.test.*" -o -name "*.spec.*" | xargs grep -l "<package>"`
2. Find existing sample scripts that use the package: `grep -r "<cli-name>" . --include="*.sh"`
3. Extract realistic input from actual data files in the repo
4. Create minimal but realistic test input

**Never use trivial synthetic inputs** — use inputs that exercise the actual code path affected by the changed dependency.

### Step 6 — Run the tests and report results

For each production component tested, report:

```
✅ PASS: [component] — [what was tested] — [command used] — [output summary]
❌ FAIL: [component] — [what failed] — [error message]
```

---

## Template: Upstream Traversal Report

Fill this out for every dependency change before committing:

```markdown
### [CHANGED DEP] [OLD VERSION] → [NEW VERSION] ([breaking/non-breaking])

**What changed:** [brief description of the change — security fix, API change, etc.]
**How it's used in [PARENT PACKAGE]:** [specific purpose — glob matching, YAML parsing, etc.]

**Affected production components:**

| Production Component | How it uses [PARENT PACKAGE] | Test command | Result |
|---------------------|------------------------------|--------------|--------|
| [component name] | [CLI / API / module] | [command] | ✅/❌ |

**Upstream traversal:**
```
[CHANGED DEP] → [PARENT PACKAGE] → [PRODUCTION COMPONENT] → [REPO USAGE]
```
```

---

## Real Example (cindy-tools/external, 2026-05-03)

### minimatch 3.1.2 → 3.1.5 (NON-BREAKING)

**What changed:** Patch release fixing ReDoS vulnerability (GHSA-3ppc-4f35-3m26). No API changes.
**How it's used in `grasp`:** File glob pattern matching for the `-r` recursive file search flag.
**How it's used in `yamljs`:** File glob matching in `yaml2json`/`json2yaml` CLI for directory input.

**Upstream traversal:**
```
minimatch@3.1.5
  → grasp@0.6.0 (uses minimatch for -r glob file matching)
    → tools/detect/scripts2/*.sh (js_iife_detector, js_webapi_WebWorkers_detector, etc.)
  → yamljs@0.3.0 → glob@7.2.3 (uses minimatch for directory YAML conversion)
    → tools/detect/scripts2/docker.sh (yaml2json for docker-compose files)
```

**Affected production components:**

| Production Component | How it uses parent | Test command | Result |
|---------------------|-------------------|--------------|--------|
| `grasp` CLI (JS AST search) | Uses minimatch for `-r` recursive glob | `grasp --files-with-matches --no-color -s 'func-dec' -r /tmp/grasp-test` | ✅ |
| `yaml2json` CLI (YAML→JSON) | Uses minimatch via glob for dir input | `yaml2json /tmp/test.yaml` | ✅ |

---

### cheerio 0.22.0 → 1.2.0 (BREAKING — major version)

**What changed:** Major version upgrade. `lodash.pick` dropped entirely. `nth-check` upgraded to `2.x`. CSS selector API compatible.
**How it's used in `cheerio-cli`:** Core HTML parsing and CSS selector engine.

**Upstream traversal:**
```
cheerio@1.2.0
  → cheerio-cli@0.3.0 (core HTML parser)
    → tools/detect/scripts2/html_scripts.sh (HTML script tag extraction)
```

**Affected production components:**

| Production Component | How it uses parent | Test command | Result |
|---------------------|-------------------|--------------|--------|
| `cheerio` CLI (HTML parsing) | Core engine | `echo "<html><body><h1>Test</h1></body></html>" \| cheerio "h1"` | ✅ |

---

### file-type 13.x → 22.0.1 (NON-BREAKING for open-cli usage)

**What changed:** Security fix for infinite loop in ASF parser (GHSA-5v7r-6r5c-r473). API compatible.
**How it's used in `open-cli`:** MIME type detection to determine how to open a file.

**Upstream traversal:**
```
file-type@22.0.1
  → open-cli@8.0.0 (MIME detection for file opening)
    → _samples/*/diagram.sh, tools/archi/samples/*.sh (open PNG/UML files)
```

**Affected production components:**

| Production Component | How it uses parent | Test | Result |
|---------------------|-------------------|------|--------|
| `open-cli` | Uses file-type for MIME detection | `open-cli --version` (functional check) | ✅ |

---

### js-yaml 3.14.1 → 4.1.1 (BREAKING — major version, via xmlbuilder2 upgrade)

**What changed:** Major version upgrade. `js-yaml@4.x` dropped `safeLoad`/`safeDump` (use `load`/`dump`). Only `SAFE_SCHEMA` by default.
**How it's used in `xmlbuilder2@4.x`:** YAML parsing for XML builder configuration.
**How it's used in `antlr-parser-plsql`:** XML building for PL/SQL AST output.

**Upstream traversal:**
```
js-yaml@4.1.1
  → xmlbuilder2@4.0.3 (YAML config parsing)
    → antlr-parser-plsql@1.0.0 (PL/SQL AST XML output)
      → tools/external/plsql-tools/ (PL/SQL parsing CLI)
```

**Affected production components:**

| Production Component | How it uses parent | Test command | Result |
|---------------------|-------------------|--------------|--------|
| `antlr-parser-plsql` CLI | Uses xmlbuilder2 for XML output | `antlr-parser-plsql --help` or parse sample PL/SQL | ✅ |
