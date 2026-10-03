<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — general usage

Language-independent rules for `ast-tools-query`. Language-specific examples:
`ast-tools-queries examples <language>` (run it without a language to see which are available).

## Rules to follow before writing any command

1. **Files come from stdin, never from arguments.** `ast-tools-query bash -f x.scm file.sh`
   fails with `File arguments are not supported`. Pipe the paths in instead.
2. **Prefer an existing bundled query** over an inline `-q` one:
   `ast-tools-queries list --language <language>`, then `ast-tools-queries show <name>`
   (the header comment of each query documents its captures and usage).
3. **`-f NAME.scm` resolves against the bundled `queries/` folder**; paths starting with
   `/`, `./` or `../` are used as-is.
4. **Some grammars have sub-grammars** — pass `typescript/typescript` (or `typescript/tsx`),
   not just `typescript`.

## Query syntax

```bash
# Piped input from git grep (recommended)
git grep -l -I "pattern" | ast-tools-query LANGUAGE -f my-query.scm

# Output formats
--format json    # Default: structured JSON
--format text    # Human-readable text
--format xml     # XML format for processing
```

## Single file analysis

**Goal:** Analyze a single file.

```bash
echo "path/to/your/file.ext" | ast-tools-query LANGUAGE -q "(your_query)"
```

**Example:** Find all subshell `()` calls in one bash script.
```bash
echo "scripts/deploy.sh" | ast-tools-query bash -f bash-subshells.scm --format text
```

## Output formats

### JSON (default)

One object per file; `captures` holds every captured node.

```json
[
  {
    "file": "src/Example.java",
    "captureCount": 5,
    "captures": [
      {
        "name": "definition.class",
        "text": "public class Example { ... }",
        "type": "class_declaration",
        "startPosition": { "row": 10, "column": 0 },
        "endPosition": { "row": 50, "column": 1 },
        "startByte": 200,
        "endByte": 1500
      }
    ]
  }
]
```

`--compact` drops the position fields. `--matches` outputs one result per query match
instead of one per file (needed when a multi-pattern query must keep its captures grouped).

### Text

```
# src/Example.java
Captures: 5
  @definition.class [11:0]: public class Example
  @name.definition.class [11:13]: Example
  @definition.method [15:1]: public void doSomething()
```

### XML

```xml
<query-results>
  <file path="src/Example.java" captures="5">
    <capture name="definition.class" line="11" column="0">
      public class Example { ... }
    </capture>
  </file>
</query-results>
```

## Predicates

Tree-sitter queries support predicates for filtering:

```bash
# Match specific patterns
-q '(method_declaration name: (identifier) @name (#match? @name "^test"))'

# Equality check
-q '(method_declaration name: (identifier) @name (#eq? @name "main"))'

# Not equal
-q '(method_declaration name: (identifier) @name (#not-eq? @name "constructor"))'
```

- Predicates go after the pattern, inside the same parentheses.
- Alternation `[]` combined with predicates does not work reliably — see
  [tree-sitter#1392](https://github.com/tree-sitter/tree-sitter/issues/1392). Use separate patterns.

## Combining with standard tools

### Filter results with jq

```bash
# Extract only method names from JSON
git ls-files -- '*.java' | ast-tools-query java \
  -q "(method_declaration name: (identifier) @method.name)" \
  --format json | \
  jq -r '.[] | .captures[] | select(.name == "method.name") | .text'
```

### Process with xmlstarlet

```bash
# Extract class names from XML
git ls-files -- '*.java' | ast-tools-query java \
  -f java-definitions.scm \
  --format xml | \
  xmlstarlet sel -t -v '//capture[@name="name.definition.class"]' -n
```

### Count occurrences

```bash
# Count number of functions in Python files
git ls-files -- '*.py' | ast-tools-query python \
  -q "(function_definition) @func" \
  --format json | \
  jq '[.[] | .captureCount] | add'
```

### Find files with specific patterns

```bash
# Find Java files with classes containing "Test"
git ls-files -- '*.java' | \
  ast-tools-query java \
    -q '(class_declaration name: (identifier) @name (#match? @name "Test"))' \
    --format json | \
  jq -r '.[] | select(.captureCount > 0) | .file'
```

### Extract and sort

```bash
# Get all function names sorted alphabetically
git ls-files -- '*.py' | \
  ast-tools-query python \
    -q "(function_definition name: (identifier) @func.name)" \
    --format json | \
  jq -r '.[] | .captures[] | .text' | \
  sort -u
```

### Generate reports

```bash
# Create a summary of classes per file
git ls-files -- '*.java' | \
  ast-tools-query java \
    -q "(class_declaration) @class" \
    --format json | \
  jq -r '.[] | "\(.file): \(.captureCount) classes"'
```

## Companion `.sh` helpers

Some queries ship a companion `.sh` script that post-processes `--format json` output with jq
(for example `markdown-headings.sh`). Show one with `ast-tools-queries show NAME.sh`; to run it
without knowing where the package is installed, feed it to bash and keep stdin for the data:

```bash
git ls-files -- '*.md' | ast-tools-query markdown -f markdown-headings.scm --matches --format json | \
  bash <(ast-tools-queries show markdown-headings.sh)
```

## Performance tips

- **Use `git ls-files` / `git grep -l -I` for file discovery.** It is faster than `find`,
  respects `.gitignore`, and avoids binary files that can crash the parser.
- **Be specific.** `-q "(class_declaration name: (identifier) @name)"` is faster than
  `-q "(_) @everything"`.
- **Parallelism is rarely needed.** `ast-tools-query` is usually fast enough on a piped list.
  For a huge file list, split it with `xargs -P`, running one tool invocation per chunk of paths
  fed through stdin.

## Troubleshooting

- **Parse errors** do not stop the run; the tool reports the file and continues:
  `[ast-tools-query] Parse errors in: file.sh`
- **Invalid query syntax** prints an error such as `Error: Invalid query syntax`.
- **No results** show up as an entry with `"captureCount": 0` and an empty `captures` array.
- **Missing `-q`/`-f`** prints the bundled queries that match the grammar.

## Creating custom queries

Query files use tree-sitter query syntax (`.scm`):

```scheme
; Comment
(node_type
  field: (child_type) @capture.name) @parent.capture

; With predicates
(method_declaration
  name: (identifier) @name
  (#match? @name "^test")) @test.method
```

Use `ast-tools-dump LANGUAGE file` to see the node types a file produces, and run a custom
file with `-f ./my-query.scm`.

## References

- [Tree-sitter query syntax](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries)
- [Tree-sitter playground](https://tree-sitter.github.io/tree-sitter/playground) — test queries interactively
