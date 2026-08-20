# Phase 2: Mandatory Verification (Measure Twice, Cut Once)

**Description:** Mandatory Verification (Measure Twice, Cut Once)

All Unknown items identified in Phase 1 must be verified or resolved before proceeding. For each Unknown:

1. **Version Grounding (Repo-First):** Check the repo for clues about this item's version or usage:
   - If a dependency, find it in lockfiles/config (`package-lock.json`, `.csproj`, `vcpkg.json`) and note the pinned version.
   - If an API or config value, search the codebase for its usage.
   - Record what you find. If unreferenced, assume the latest version and mark that assumption.
2. **External Verification (Tool-aided):** ALWAYS use the appropriate tool/method:
   - **API or library:** Query official docs or an AI context/MCP tool (Exa, Tavily, `browser.search`) for usage examples.
   - **Concept or method:** Search the code, or use web search tools for background.
   - **Error-prone step:** Look up known issues via web search.
   - Aim to find **facts**: signatures, compatibility notes, correct usage patterns.
3. **Collect Evidence:** For each Unknown, prepare a Verification entry:
   - **Component:** name of the Unknown.
   - **Version/Details:** version/detail found (or "latest assumed").
   - **Tool/Source Used:** e.g. "Docs search", "NPM registry", "StackOverflow".
   - **Verified Facts:** brief note on what you verified.
   - **Evidence Link or Reference:** URL or pointer for traceability.
   - **Verified?** YES or NO.
4. **Repeat for all Unknowns.** If any remain unverified (any NO), you **must not proceed**. Stop and output `status=blocked`, explaining what couldn't be verified so the user can assist or decide.
5. **If all Unknowns = YES:** summarize that verification is complete.

## Exit Criteria

- Every item in the Unknowns list has a verification result (YES or NO).
- `Unknowns_remaining == 0` (all resolved), otherwise the process is blocked here.

## Output Format

```markdown
## Phase 2 Verification

| **Unknown**          | **Version/Detail**    | **Source**      | **Key Findings**             | **Verified?** |
|----------------------|-----------------------|-----------------|------------------------------|--------------|
| Library ABC          | v1.4 (package.json)   | Official docs   | Has function X() for our need| YES          |
| API XYZ endpoint     | (assume latest)       | StackOverflow   | Requires auth token          | YES          |
| Something unverified | -                     | -               | *Unable to find info*        | NO           |

**Verification Complete?** NO – *Blocked on unverified items: "Something" needs info on…*
```
(If complete, state "Verification Complete? YES – all Unknowns resolved.")
