<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — gitattributes examples

## Find Git LFS tracked patterns

**Goal:** Find all file patterns configured for Git LFS in `.gitattributes` files, grouped by file.

**Query file:** `gitattributes-lfs-filter.scm` (`ast-tools-queries show gitattributes-lfs-filter`)
```scheme
; Finds file patterns that are configured to use Git LFS.
; An anonymous parent `_` identifies the sibling relationship between a
; `pattern` and its `attribute`.
(
  (pattern) @pattern
  (attribute
    (builtin_attr) @key
    (attr_set)
    (string_value) @value
    (#eq? @key "filter")
    (#eq? @value "lfs")
  )
)
```

**Command:**
```bash
find . -name ".gitattributes" | \
  ast-tools-query gitattributes -f gitattributes-lfs-filter.scm --compact | \
  jq '[.[] | {file: .file, patterns: [.captures[] | select(.name == "pattern") | .text] | unique} | select(.patterns | length > 0)]'
```

**Output:**
```json
[
  {
    "file": "./.gitattributes",
    "patterns": ["demo.gif", "assets/docs/demo.gif"]
  }
]
```
