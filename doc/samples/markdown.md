<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — Markdown examples

Bundled queries: `ast-tools-queries list --language markdown`.

## Extract all headings

**Goal:** Extract all headings from Markdown files with their levels, using the bundled query and
its companion jq helper.

```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -f markdown-headings.scm --matches --format json | \
  bash <(ast-tools-queries show markdown-headings.sh)
```

**Output (one JSON object per file):**
```json
{"file":"README.md","headings":[{"level":1,"text":"Project Title"},{"level":2,"text":"Installation"}]}
```

## Find Markdown files with code blocks

**Goal:** Find all Markdown files containing code blocks (fenced or indented).

```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(fenced_code_block) @code (indented_code_block) @code" \
  --format json | jq -r '.[] | .file' | sort -u
```

## Find non-code language identifiers (e.g. diagrams)

**Goal:** Find fenced code blocks with non-code language identifiers (mermaid, plantuml, console,
text, regex, none) to locate inline diagrams or other non-code content.

**Step 1** — all unique language identifiers used in fenced code blocks:
```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(fenced_code_block (info_string (language) @lang) @block)" \
  --format json 2>/dev/null | jq -r '.[] | .captures[] | select(.name == "lang") | .text' | sort -u
```

**Step 2** — keep only the non-code ones:
```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(fenced_code_block (info_string (language) @lang) @block)" \
  --format json 2>/dev/null | jq -r '.[] | .file as $f | .captures[] | select(.name == "lang") | {file: $f, lang: .text}' | \
  jq -s 'map(select(.lang == "console" or .lang == "mermaid" or .lang == "none" or .lang == "plantuml" or .lang == "regex" or .lang == "text"))'
```

**Output:**
```json
[
  {"file": "docs/design.md", "lang": "mermaid"},
  {"file": "docs/flow.md", "lang": "plantuml"},
  {"file": "README.md", "lang": "console"}
]
```

## Find HTML blocks (TOC, tables, anchors)

**Goal:** Count HTML blocks embedded in each Markdown file.

```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(html_block) @html" \
  --format json | jq -r '.[] | .file as $f | .captures[] | {file: $f, html: .text}' | \
  jq -s 'group_by(.file) | map({file: .[0].file, html_blocks: map(.html) | length})'
```

**Output:**
```json
[
  {"file": "docs/html-in-md.md", "html_blocks": 5}
]
```

**Extract specific HTML content (e.g. a TOC):**
```bash
echo "docs/html-in-md.md" | ast-tools-query markdown \
  -q "(html_block) @html" --format json | \
  jq -r '.[] | .captures[].text' | grep -A5 '<ul id="toc">'
```
