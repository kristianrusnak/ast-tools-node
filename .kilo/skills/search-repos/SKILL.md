---
name: search-repos
description: Search GitLab repositories (scopes defined in scopes.md) for usage of a given technology, framework, or library. Uses node CLI tools in this directory.
---

# Search Repos Skill

Finds which projects use a given technology/framework/library across GitLab instances.
No caching — scripts run fresh every time via the GitLab REST blobs API.

## Files

| File | Committed | Purpose |
|---|---|---|
| `SKILL.md` | ✅ | This file — skill instructions |
| `gitlab-api.js` | ✅ | Shared CJS module (fetch, retry, pagination, pool) |
| `gitlab-search-blobs` | ✅ | CLI: search one project |
| `gitlab-search-all-projects-v3` | ✅ | **CLI: search all projects in a scope** |
| `gitlab-list-languages` | ✅ | CLI: list dominant languages per project in a scope |
| `gitlab-check-file-presence` | ✅ | CLI: check whether specific files exist across all projects in a scope |
| `jsconfig.json` | ✅ | VS Code IDE only — silences false TS errors |
| `.gitignore` | ✅ | Excludes learn.md (future cache) |
| `scopes.md` | optional | Instance-specific URL globs — commit if desired, or let skill infer from `git remote` |

---

## STEP 0 — Determine scopes

### If `scopes.md` exists:
Read it — one URL glob per line, blank lines and `#` comments ignored.

Format:
```
https://gitlab.example.com/*/*
https://gitlab.example.com/my-group/*
```

### If `scopes.md` is missing — infer from `git remote -v`:

Run: `git remote -v`

Parse the fetch URL (first remote, fetch line). Extract:
- `{host}` — the GitLab hostname
- `{group}` — the top-level group/namespace of the current repo path

Construct scope: `https://{host}/{group}/*`

Example: remote `https://gitlab.example.com/my-team/my-repo.git` → scope `https://gitlab.example.com/my-team/*`

If `git remote -v` returns nothing → warn user and stop:
> ⚠️ No `scopes.md` found and no git remote detected. Please create `scopes.md` (next to this SKILL.md) with one URL glob per line.

---

## STEP 1 — Detect MCPs + derive env vars from `.roo/mcp.json`

For each scope URL, extract the hostname.

### 1a — Match MCP server

Scan available tool names in the current LLM session. Find tools whose MCP server name contains a recognizable fragment of the scope hostname.

Tool names follow pattern: `mcp--{mcp-server-name}--{tool-name}`

Match laxly — e.g. for `gitlab.acme.com`, look for MCP server names containing `acme`.

**Detect capabilities per matched instance:**
- Has `get_file_contents` → can fetch files ✓
- Has `list_commits` → can check commit SHAs ✓
- Has `execute_graphql` → can enumerate groups via GraphQL ✓
- Has `list_issues` → can search issues ✓

If no MCP found for a scope → skip it, warn: ⚠️ No MCP available for `{hostname}` — skipping.

### 1b — Derive `GITLAB_SEARCH_URI` and `GITLAB_SEARCH_TOKEN` from `.roo/mcp.json`

Read `.roo/mcp.json`. For the matched MCP server entry, derive:

| Env var | How to derive |
|---|---|
| `GITLAB_SEARCH_URI` | If entry has `env.GITLAB_API_URL` → use it directly (already ends in `/api/v4`). Else extract base URL from `url` field and append `/api/v4`. |
| `GITLAB_SEARCH_TOKEN` | If entry has `env.GITLAB_PERSONAL_ACCESS_TOKEN` → expand that env var name from shell. If entry has `headers.Authorization` containing `${env:VAR_NAME}` → expand `VAR_NAME` from shell. |

**Never hardcode** any URL or token name — always derive from `.roo/mcp.json` at runtime.

---

## STEP 2 — Issue search (fast, run first)

```
list_issues  scope:all  search:<keyword>  per_page:20
```
Run on all instances with `list_issues` available. Note project paths found.

---

## STEP 3 — File content search via `gitlab-search-all-projects-v3`

**Preferred method** — searches actual file content across all projects in a scope.
Uses a true producer-consumer pipeline: project enumeration and searching run concurrently — no barrier between pages.

### Scope URL formats

| Scope URL | Behaviour |
|-----------|-----------|
| `https://host/group/*` | All projects in group + subgroups |
| `https://host/*/*` | All accessible projects on instance |
| `https://host/group/project` | Single project (fast path, no pool) |

### Run:

```bash
# Streaming JSONL output (default) — one JSON object per project with hits, emitted immediately
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-all-projects-v3 \
  "<scope_url>" "<keyword>" [--filter "extension:py"] [--concurrency 8]

# Hits only — suppress zero-hit projects from stdout
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-all-projects-v3 \
  "<scope_url>" "<keyword>" [--filter "extension:py"] [--concurrency 8] --hits-only

# JSON array output — buffer all results, dump single array at end
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-all-projects-v3 \
  "<scope_url>" "<keyword>" [--filter "extension:py"] [--concurrency 8] --json

# Save to JSONL file
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-all-projects-v3 \
  "<scope_url>" "<keyword>" --filter "filename:.gitmodules" --hits-only \
  > /tmp/results.jsonl
```

The `<scope_url>` is the exact line from `scopes.md` (or the inferred scope from STEP 0).

The script automatically:
- Detects scope type (group / all-projects / single-project)
- Paginates through all projects while consumers search simultaneously
- Searches each project in parallel (default concurrency: 8)
- Retries on HTTP 429 with exponential backoff (respects `Retry-After` header)

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `--filter <str>` | none | Inline filter: `extension:py`, `filename:*.json`, `path:src/` |
| `--concurrency <n>` | 8 | Max parallel project searches |
| `--per-page <n>` | 20 | Results per project (max 100) |
| `--ref <branch>` | project default | Branch/tag to search |
| `--hits-only` | false | Suppress zero-hit projects from stdout |
| `--json` | false | Output single JSON array instead of JSONL stream |

### Single project search (direct, no scope enumeration):

```bash
# Via v3 (preferred — supports single-project scope URL):
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-all-projects-v3 \
  "https://host/group/project" "<keyword>" [--filter "extension:py"]

# Via gitlab-search-blobs (low-level, by project ID or path):
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-blobs \
  <project_id_or_path> "<keyword>" [--filter "extension:py"] [--per-page 20]
```

### Available filters and multi-keyword syntax:

Filters are appended inline to the search term (e.g. `langchain extension:py`).
Multiple filters can be combined in one `--filter` string.

| Filter | Example | Notes |
|---|---|---|
| By file extension | `--filter "extension:py"` | Exact, no dot, no wildcards |
| By filename glob | `--filter "filename:*.json"` | Glob `*` supported |
| By path prefix | `--filter "path:src/"` | Partial path match |
| Exclude extension | `--filter "-extension:yml"` | Prefix with `-` |
| Multiple filters | `--filter "extension:py -path:test"` | Space-separated |

**Multiple keywords** — pass them as the keyword argument (space = OR on Free tier):
```bash
# OR search: finds projects using either library
./scripts/gitlab-search-all-projects-v3 "<scope>" "langchain langgraph"
```
Note: Boolean AND (`+`), phrase (`"..."`), exclude (`-`) between keywords require Elasticsearch (Premium/Ultimate).

### JSON output schema (v3 JSONL — one object per line):

```json
{ "project_id": 42, "project_path": "group/project", "default_branch": "main", "hits": [{ "path": "src/foo.py", "startline": 10, "ref": "main", "data": "..." }] }
```

> Note: v3 does not include `head_sha`. Use legacy `--commits-only` if SHA is needed.

### Limitations:
- **Project-level only** — works on Free tier without Elasticsearch
- Global/group blobs (`GET /api/v4/search?scope=blobs`) requires Elasticsearch (Premium/Ultimate)
- If global blobs returns `{"error":"scope does not have a valid value"}` → Elasticsearch not enabled

### Fallback — manual dependency file scan

If blobs API is unavailable, fall back to fetching known files via MCP `get_file_contents` in parallel batches of 4-6:
- Python: `requirements.txt`, `pyproject.toml`
- Node: `package.json`
- Monorepo subdirs: `<subdir>/requirements.txt`, `<subdir>/package.json`

Check both hyphen and underscore variants: `browser-use` = `browser_use`.

---

## STEP 3b — File/directory/glob presence check via `gitlab-check-file-presence`

Use this instead of STEP 3 when the goal is **"does this path exist?"** rather than searching file content.
No content is downloaded. Works on Free tier — no Elasticsearch required.

### When to use:
- Checking for a known file at a known path: `AGENTS.md`, `Dockerfile`, `.gitlab-ci.yml`, `.roo/mcp.json`
- Checking for a directory: `.roo/`, `src/`, `.github/`
- Checking for any file matching a pattern **when you know the parent directory**: `.roo*` (root-level), `src/*.json` (inside `src/`)
- Generating a yes/no presence matrix across all repos in a scope

### ⚠️ Critical limitation — path must be specified from repo root

All three modes require the argument to be specified **from the repo root**. The glob mode splits on the **last `/`** to determine which directory to list, then filters entry names by the glob. This means:

- `src/*.json` → lists `src/` entries, matches names like `foo.json` ✓
- `SKILL*` → lists root entries, matches names like `SKILL.md` at root only ✓
- ❌ **Cannot search across all subdirectories** — there is no `**` recursive wildcard support

**If the file can be in any subdirectory at unknown depth** (e.g. `SKILL.md` inside `.roo/skills/any-skill/SKILL.md`), use STEP 3 instead:
```bash
# Use gitlab-search-all-projects-v3 with filename filter — finds files by name anywhere in the repo
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-search-all-projects-v3 \
  "<scope_url>" "SKILL.md" --filter "filename:SKILL.md" --hits-only
```

### Three modes — determined by argument syntax, no heuristics:

| Mode | Syntax rule | API used | Examples |
|---|---|---|---|
| **file** | No trailing `/`, no `*` or `?` | `HEAD /repository/files/:path` | `AGENTS.md` `.roo/mcp.json` `.gitignore` |
| **dir** | **Must end with `/`** | `GET /repository/tree?path=<dir>` | `.roo/` `src/` `.github/` |
| **glob** | Contains `*` or `?` | `GET /repository/tree?path=<parent>` + name filter (non-recursive) | `.roo*` `*.yml` `src/*.json` |

The mode is printed in stderr for each arg so you can verify detection.

### Run — pass all args after the scope URL:

```bash
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-check-file-presence \
  "<scope_url>" <arg1> [<arg2> ...] [--concurrency 10] [--any-branch]
```

All paths are checked in parallel per project. Each becomes one column in the output.

**`--any-branch` flag:** Check all branches instead of just the default branch. When used:
- 🟢 = found on default branch
- 🟡 (branch-name) = found on another branch (shows which branch)
- ○ = not found on any branch

Without `--any-branch` (default):
- 🟢 = found on default branch
- ○ = not found

Example — check `AGENTS.md` (file), `.roo/` (directory), `.roo*` (glob) across all projects:

```bash
GITLAB_SEARCH_URI=https://gitlab.ashlin.gratex.ai/api/v4 \
GITLAB_SEARCH_TOKEN=$GITLAB_MCP_PAT_ASHLIN_READ \
  ./scripts/gitlab-check-file-presence \
  "https://gitlab.ashlin.gratex.ai/*/*" AGENTS.md ".roo/" ".roo*"
```

Example with `--any-branch` to find files on any branch:

```bash
GITLAB_SEARCH_URI=https://gitlab01.hq.gratex.com/api/v4 \
GITLAB_SEARCH_TOKEN=$GITLAB_MCP_PAT_GITLAB01_READ \
  ./scripts/gitlab-check-file-presence \
  "https://gitlab01.hq.gratex.com/ai/*" AGENTS.md --any-branch
```

### ⚠️ MANDATORY: Present results as one merged Markdown table

**Always** present results as a **single flat Markdown table** — this is not optional.

Rules:
- **Include ALL repos** — matched AND unmatched. Do NOT filter out repos where all paths are `○ No`.
- One table combining **all scopes** — do NOT split by scope, by file, or into sections
- Columns: **Server | Repository | `<arg1>` | `<arg2>` | ...**
  - `Server` = the `server` field from JSON output (short hostname fragment, e.g. `ashlin`, `gitlab01`)
  - Column headers = args exactly as passed (`.roo/` stays `.roo/`, `.roo*` stays `.roo*`)
- Cells: render from JSON `state` field using the jq recipe below
- Sort: rows with at least one 🟢/🟡 first, then ○-only rows below
- **Do not add prose, sections, or summaries around the table** — the table is the answer

```markdown
| Server | Repository | AGENTS.md | .roo/ | .roo* |
|---|---|:---:|:---:|:---:|
| ashlin | mygroup/my-repo | 🟢 Yes (main) | 🟢 Yes (main) | 🟢 Yes (main) |
| ashlin | mygroup/other-repo | 🟢 Yes (main) | ○ No | 🟢 Yes (main) |
| gitlab01 | ai/InnovAIte | 🟢 Yes (main) | 🟢 Yes (main) | 🟢 Yes (main) |
| ashlin | mygroup/bare-repo | ○ No | ○ No | ○ No |
| gitlab01 | ai/chat-bot | ○ No | ○ No | ○ No |
```

**Exception:** if the user explicitly asks for CSV, output bare comma-separated values instead.

### JSON output schema

The script **always outputs JSON** to stdout. Progress is written to stderr.

```json
[{
  "server":         "ashlin",
  "project_path":   "group/repo",
  "default_branch": "main",
  "paths": {
    "AGENTS.md": { "state": "found_main",     "branch": "main" },
    ".roo/":     { "state": "not_found_main", "branch": null   },
    ".roo*":     { "state": "found_some",     "branch": "dev"  },
    ".kilo*":    { "state": "not_found_any",  "branch": null   }
  }
}]
```

**State values** (4-state, unambiguous):

| `state` | Meaning | Icon |
|---|---|:---:|
| `found_main` | Found on default branch | 🟢 |
| `not_found_main` | Not found on default branch; other branches not checked | ○ |
| `found_some` | Found on some non-default branch (`--any-branch` only) | 🟡 |
| `not_found_any` | Not found on any branch (`--any-branch` only) | ○ |

### Combining results from multiple scopes

Run each scope **once**, save to a file, merge with `jq -s add` — all in one `&&` chain. **Do NOT re-run the script to merge.**

```bash
GITLAB_SEARCH_URI=https://gitlab.ashlin.gratex.ai/api/v4 \
GITLAB_SEARCH_TOKEN=$GITLAB_MCP_PAT_ASHLIN_READ \
  ./scripts/gitlab-check-file-presence \
  "https://gitlab.ashlin.gratex.ai/*/*" AGENTS.md ".roo/" ".roo*" \
  > /tmp/ashlin.json && \
GITLAB_SEARCH_URI=https://gitlab01.hq.gratex.com/api/v4 \
GITLAB_SEARCH_TOKEN=$GITLAB_MCP_PAT_GITLAB01_READ \
  ./scripts/gitlab-check-file-presence \
  "https://gitlab01.hq.gratex.com/ai/*" AGENTS.md ".roo/" ".roo*" \
  > /tmp/gitlab01.json && \
jq -s 'add' /tmp/ashlin.json /tmp/gitlab01.json > /tmp/all.json
```

The script runs **twice total** (once per scope). `jq -s add` reads the saved files — it does not re-run the script.

### Rendering — use the `.jq` files in this skill directory

Rendering scripts are saved as `.jq` files to avoid terminal escaping issues.
**Always use `jq -rf` (with `-r` flag) — without `-r`, jq outputs quoted JSON strings instead of raw text.**

**Markdown table** (save to file, then paste content into response):
```bash
jq -rf ./scripts/gitlab-check-file-presence-render-md.jq /tmp/all.json > /tmp/results.md
cat /tmp/results.md
```

**TSV table:**
```bash
jq -rf ./scripts/gitlab-check-file-presence-render-tsv.jq /tmp/all.json
```

Both renderers:
- Derive columns dynamically from the first row's `paths` keys — no hardcoding needed
- Sort matched rows (🟢/🟡) first, then unmatched rows
- Output a single string (joined with `\n`) — paste the `cat` output directly as Markdown
- Include ALL repos — never filter out unmatched rows

⚠️ **Never use `select()` to filter rows** — the table must include every repo, even those where all paths are `○ No`. Filtering hides repos and gives an incomplete picture.

**Count repos with at least one match:**
```bash
jq '[.[] | select(.paths | to_entries | map(select(.value.state | startswith("found"))) | length > 0)] | length' /tmp/all.json
```

---

## STEP 3c — List dominant languages per project via `gitlab-list-languages`

Use this when the goal is **"which projects use language X (e.g. JavaScript)?"** rather than searching file content.
Uses `GET /api/v4/projects/:id/languages` (analogous to GitHub `/repos/:owner/:repo/languages`) — works on Community Edition, no Elasticsearch required.

> ⚠️ `languages` is **per-project only** — it is not returned in the `/projects` list. This script calls the endpoint once per project.

### Run — pass the scope URL, optionally filter with jq:

```bash
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-list-languages \
  "<scope_url>" [--concurrency 8]

# JSON array output (instead of JSON Lines):
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-list-languages \
  "<scope_url>" --json
```

The scope URL uses the same formats as STEP 3 (`group/*`, `*/*`, or a single `group/project`).

### Filtering — find all JS/TS projects (pipe into jq):

```bash
# Projects with any JavaScript or TypeScript share:
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-list-languages "<scope_url>" \
  | jq 'select((.languages.JavaScript // 0) + (.languages.TypeScript // 0) > 0)'

# Top language per project (JSON Lines input):
GITLAB_SEARCH_URI=<api_base> GITLAB_SEARCH_TOKEN=<token> \
  ./scripts/gitlab-list-languages "<scope_url>" \
  | jq -c '{project_path, top: (.languages | to_entries | sort_by(-.value) | .[0])}'
```

### JSON output schema (JSON Lines — one object per line):

```json
{ "project_id": 42, "project_path": "group/project", "default_branch": "main", "languages": { "JavaScript": 83.78, "TypeScript": 16.22 } }
```

`languages` maps language name → percentage share (sorted descending). It is `{}` for repos where GitLab has not computed languages (e.g. empty/imported repos).

---

## STEP 4 — Compile and present results

Present results grouped by project. For each match include:
- Project path + URL
- Matched file path, line number, branch
- Snippet of matched content

Update `docs/00-overview/00-overview.md` under the technology section with repo links and usage description if that file exists.
