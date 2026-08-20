---
name: npm-audit
description: Systematic npm audit investigation workflow — use when asked to run, investigate, fix, or understand npm audit vulnerabilities in any Node.js project.
---

<!-- Generated/modified by AI RooCode 3.53.0, used model google/claude-sonnet-4-6 -->

# npm-audit skill

**Applies to:** any Node.js / npm project.

Execute every step below in order. Do not skip steps. Do not jump straight to `npm audit fix --force`.
At each step, **run the commands and show the output** to the user before proceeding.

---

## STEP 1 — Run the audit and show the full picture

Run both commands and show their output:

```bash
# Full audit — all severities, all deps
npm audit

# Production-only, high+ severity (reduces noise)
npm audit --audit-level=high --omit=dev
```

**Then, for every vulnerable package listed**, trace who pulled it in — `npm audit` shows the vulnerable package but NOT the full dependency chain. Run:

```bash
npm ls <vulnerable-package>
```

Run this for **each** vulnerable package name. Show the full tree output.

For a structured summary of all vulnerabilities with their advisory URLs, run:

```bash
npm audit --json | node -e "
  const d = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
  Object.values(d.vulnerabilities).forEach(v =>
    console.log(v.severity.toUpperCase(), v.name,
      '←', v.via.map?.(x => x.url || x).join(', ') || String(v.via))
  );
"
```

**Important:** Show the output. Report to the user:
- How many vulnerabilities (by severity)
- For each: the vulnerable package, its severity, the advisory URL, and the full `npm ls` chain showing which direct dependency pulled it in

---

## STEP 2 — Supply chain attack check

Before proceeding with any fixes, verify that none of the packages in your dependency tree have been **compromised via supply chain attack** (account takeover, malicious maintainer, dependency confusion, typosquatting).

This is a separate concern from CVE vulnerabilities — a package can be "clean" in the audit but still contain malicious code injected by a compromised maintainer.

### 2a — Check for known compromised packages in your tree

For each **direct dependency** and any **high-profile transitive dep** (e.g. `axios`, `chalk`, `debug`, `lodash`, `minimatch`, `glob`), run:

```bash
npm ls axios chalk debug plain-crypto-js 2>&1
```

Then search for recent supply chain incidents affecting your packages:

```
site:github.com <package-name> supply chain attack 2025 2026
<package-name> npm compromised malicious maintainer takeover
```

Report:
- Is any installed package version known to be compromised?
- Are there known malicious lookalike packages (typosquatting) for any of your deps?
- Have any maintainer accounts been taken over recently for packages in your tree?

### 2b — Known compromised packages reference table

**Always check these packages** (update this list as new attacks emerge):

| Package | Incident | Affected versions | Date |
|---------|----------|-------------------|------|
| `axios` | North Korean UNC1069 account takeover; injected `plain-crypto-js` backdoor (WAVESHAPER.V2) | Check npm for compromised release | March 2026 |
| `chalk`, `debug` + 16 others | Maintainer phishing; malicious code injected into widely-used packages | Check npm advisory | September 2025 |
| `plain-crypto-js` | Malicious package — injected as dependency of compromised `axios` | All versions | March 2026 |

### 2c — If a compromised package is found

- **Do NOT run `npm install` or `npm audit fix`** until the package is removed/replaced
- Pin to a known-safe version or replace the package entirely
- Report to your security team immediately
- Check CI/CD logs for any runs that installed the compromised version

---

## STEP 3 — Check if upgrading direct parents fixes the issue

Before reaching for `overrides` or `--force`, check whether simply upgrading the **direct parent** package resolves the transitive vulnerability.

For each vulnerable transitive dependency identified in Step 1:

1. Identify the **direct parent** (the package in your `package.json` that pulls in the vulnerable transitive dep).
2. Check the latest version of that direct parent:
   ```bash
   npm show <direct-parent> version
   ```
3. Check what transitive deps the latest version would bring:
   ```bash
   npm show <direct-parent>@latest dependencies
   ```
4. Determine if the latest version pins a **fixed** version of the vulnerable transitive dep.

Report for each:
- Is the direct parent at its latest version already?
- Does the latest version of the direct parent fix the transitive vulnerability?
- Is upgrading the direct parent a breaking change (major semver bump)?
- If the direct parent is **abandoned** (no newer version, still pins old vulnerable dep) — document this and file an issue upstream if appropriate.

**Decision table:**

| Finding | Action |
|---------|--------|
| Direct parent has a newer version that fixes the transitive dep | Upgrade the direct parent |
| Direct parent is already latest but still pins vulnerable dep | Use `overrides` |
| Direct parent is abandoned / unmaintained | Use `overrides` + file upstream issue |
| Upgrading direct parent is a breaking major bump | Evaluate risk; prefer `overrides` if safe |

---

## STEP 4 — Dry-run before acting

Run and show the output:

```bash
npm audit fix --dry-run
```

Report to the user:
- Which packages would be updated and to what version
- Which fixes are **non-breaking** (patch/minor semver bump) — safe to apply
- Which fixes are **breaking** (major semver bump) — require code/test review
- Whether `--force` is required — if so, explain what it would downgrade/upgrade and why that is risky

Do not apply any fix yet.

---

## STEP 5 — Investigate upstream

For each vulnerability that cannot be fixed with a safe `npm audit fix` or direct parent upgrade:

1. Search the vulnerable package's issue tracker (GitHub/GitLab) for the CVE or GHSA advisory ID.
   Use web search: `site:github.com <package-name> <GHSA-id>` or `<package-name> <CVE-id> fix`.
2. Also search for **latest known vulnerabilities** beyond what `npm audit` reports — npm audit lags behind real-world disclosures:
   ```
   <package-name> CVE vulnerability 2025 2026 npm
   <package-name> security advisory latest patch
   ```
3. Report:
   - Is there a fix PR? What is its status (merged → which version? open? stale? no reviews?)?
   - Is the vulnerable code path actually reachable in this project? (Check what function/export is flagged and whether the project calls it.)
   - Are there **newer CVEs** not yet in the npm audit database?
4. Based on findings, recommend a fix strategy (see Step 6).

---

## STEP 6 — Apply the chosen fix strategy

Present the strategy to the user and confirm before applying. Choose based on Step 5 findings:

| Strategy | When to use | Command / Action |
|----------|-------------|-----------------|
| `npm audit fix` | Non-breaking fixes available | `npm audit fix` |
| `overrides` in `package.json` | Upstream fix exists but parent hasn't released it | Add `"overrides"` block (see below) |
| `npm audit fix --force` | Breaking fix is acceptable; tests updated | `npm audit fix --force` |
| Wait for upstream | Fix in beta/unreleased; low real-world risk | Document and skip |
| Accept the risk | Vulnerable code path never exercised | Document decision in commit/issue |

Apply fixes **one by one**, starting with the safest (non-breaking `npm audit fix`), then `overrides` one at a time, verifying after each.

### Using `overrides` (recommended workaround pattern)

When a transitive dependency has a fix but the direct parent hasn't released a new version yet, pin the transitive dep in `package.json`:

```json
{
  "overrides": {
    "serialize-javascript": ">=7.0.5"
  }
}
```

Then run:

```bash
npm install --legacy-peer-deps
```

This is a well-established community pattern. Show the user the exact `overrides` block to add.

### Using `--force` (breaking)

Only use when the major-version change has been verified safe:

```bash
npm audit fix --force --legacy-peer-deps
```

After applying, run the full test suite immediately and show the results.

---

## STEP 7 — Verify

> **MANDATORY:** Before running `npm audit`, you MUST follow the testing strategy defined in
> [testing-changes.md](./testing-changes.md). Failure to do so is an error.

### 7a — Test all affected production components

For every dependency that was changed (upgraded, overridden, or replaced):

1. Identify the **full upstream traversal**: changed dep → parent package → production component → repo usage
2. Report the traversal in the format defined in [testing-changes.md](./testing-changes.md)
3. Find realistic test inputs from actual repo usage (scripts, sample files, existing tests)
4. Run smoke tests for each affected production component
5. Report results as ✅ PASS or ❌ FAIL

**Never skip this step.** Even non-breaking patch upgrades must be smoke-tested on the actual code path that uses the changed dependency.

### 7b — Run npm audit

```bash
npm audit
npm test
```

Report:
- Number of remaining vulnerabilities (target: 0)
- Test suite result (pass/fail)

If vulnerabilities remain, return to Step 5 — there may be a second advisory or a transitive chain you missed.

---

## STEP 8 — Commit

Write a commit message referencing the CVE/GHSA advisory and the fix strategy. Example:

```
fix: resolve serialize-javascript GHSA-xxxx-xxxx-xxxx via overrides

mocha@11 pins serialize-javascript@^6; fix is in 7.0.5 (major bump).
Upstream PR open but unreviewed (mochajs/mocha#5873).
Added overrides.serialize-javascript = ">=7.0.5" — same pattern used
by dozens of projects referencing mochajs/mocha#5781.

npm audit: 0 vulnerabilities. All tests passing.
```

---

## Real example (roo-common, 2026-04-15)

- **Vulnerable package:** `serialize-javascript` (via `mocha@11.7.5` → `serialize-javascript@^6.0.2`)
- **`npm ls` output:** `mocha@11.7.5` → `serialize-javascript@6.0.2`
- **Fix version:** `7.0.5` (semver major — mocha pins `^6`)
- **Upstream status:** mocha issues #5780, #5781, #5872 open; PR #5873 has zero maintainer reviews
- **Fix applied:** `"overrides": { "serialize-javascript": ">=7.0.5" }` in `package.json`
- **Result:** 0 vulnerabilities, all tests passing

## Final report

After completing all steps, save a final report. Search for `npm audit Report` in `*.md` files to find existing report examples for format reference and place to save.
