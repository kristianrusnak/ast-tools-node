<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — HTML examples

## Extract the title text from HTML files

**Goal:** Extract the `<title>` tag text. Files without a `<title>` are silently skipped.

```bash
git ls-files -- '*.html' | \
  ast-tools-query html \
    -q '(element (start_tag (tag_name) @_tag (#eq? @_tag "title")) (text) @title.text)' \
    --matches --compact | \
  jq '.[] | {file, title: .captures[1].text}'
```

**Single file:** `echo "path/to/file.html" | ast-tools-query html -q '…' --matches --compact | jq …`

**How it works:**
- The query matches any `element` whose `start_tag` contains a `tag_name` equal to `"title"`
  (`#eq?` predicate), then captures the `text` child as `@title.text`.
- `@_tag` is a helper capture required by the predicate; it is always at index `0`, so
  `@title.text` is always at index `1` and `captures[1].text` needs no `select()`.
- `--matches --compact` yields one result per match without position metadata.

**Output:**
```json
{"file": "docs/index.html", "title": "Project documentation"}
{"file": "web/500page.html", "title": "Error"}
```
