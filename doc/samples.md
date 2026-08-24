<!--
Generated/modified by AI RooCode 3.51.1, used model google/claude-sonnet-4-6
-->

# ast-tools-query Usage Samples

This document provides practical examples of using `ast-tools-query` for various code analysis tasks.

## Basic Usage

### Query Syntax

```bash
# Piped input from git grep (recommended)
git grep -l -I "pattern" | ast-tools-query LANGUAGE -f my-query.scm

# Output formats
--format json    # Default: structured JSON
--format text    # Human-readable text
--format xml     # XML format for processing
```

## Single File Analysis

**IMPORTANT:** `ast-tools-query` does not accept file paths as direct arguments. You must pipe the file path to the command using `echo` or another command.

**Goal:** Analyze a single file.

**Command:**
```bash
echo "path/to/your/file.ext" | ast-tools-query LANGUAGE -q "(your_query)"
```

**Example:** Find all subshell `()` calls in a single bash script.
```bash
echo "tools/external/bin/status-all" | ast-tools-query bash -f bash-subshells.scm --format text
```

## Find Archi-CLI scripts using .ajs files

**Goal:** Find all shell scripts that execute `.ajs` files using `archi-cli`, and display the file, command, parameter, and the script value.

**Command:**
```bash
git grep -l -I 'archi-cli' -- . ':(exclude)db-data' | \
  ast-tools-query bash -f bash-commands.scm --compact | \
  jq '[.[] | .file as $file | .captures as $c | [range(0; $c | length) | select($c[.].name == "command.arg" and $c[.].text == "--script.runScript")] | map({file: $file, command: "archi-cli", parameter: $c[.].text, value: $c[. + 1].text})] | flatten | unique'
```

**Output (Snippet):**
```json
[
  {
    "file": "tools/archi/bin/archi-api-color-objects",
    "command": "archi-cli",
    "parameter": "--script.runScript",
    "value": "$p/colorElementsInFolder.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-create-view",
    "command": "archi-cli",
    "parameter": "--script.runScript",
    "value": "$p/createNewView.ajs"
  }
]
```

## Find Commands with Specific Arguments

**Goal:** Find all commands in the `_samples` directory with arguments mentioning `elements.csv` or `seqarch`, and display the file, command name, and the matching argument.

**Command:**
```bash
git grep -l -I -E 'elements\.csv|seqarch' -- _samples | \
  ast-tools-query bash -f bash-commands.scm --compact | \
  jq '[.[] | .file as $file | .captures | reduce .[] as $item ({last_cmd: null, items: []}; if $item.name == "command.name" then .last_cmd = $item.text else . end | if $item.name == "command.arg" and ($item.text | test("elements\\.csv|seqarch")) then .items += [{file: $file, command: .last_cmd, arg: $item.text}] else . end) | .items] | flatten'
```

**Output (Snippet):**
```json
[
  {
    "file": "_samples/detector-dependencies-issue168/export2archi.sh",
    "command": "archi-cli",
    "arg": "\"\$tmpDir/elements.csv\""
  },
  {
    "file": "_samples/export-tree2archi-relations-issue101/readme.md",
    "command": "pozri",
    "arg": "elements.csv"
  },
  {
    "file": "_samples/java_ee_web_url_patterns-issue124/java_ee_web2archi.sh",
    "command": "archi-api-import-csv",
    "arg": "$c/web-url/elements.csv"
  }
]
```

### Query Syntax

```bash
# Piped input from git grep (recommended)
git grep -l -I "pattern" | ast-tools-query LANGUAGE -f my-query.scm

# Output formats
--format json    # Default: structured JSON
--format text    # Human-readable text
--format xml     # XML format for processing
```

## Java Examples

### Extract All Class Definitions

**Goal:** Extract all Java class definitions from the repository.

**Command:**
```bash
git ls-files -- '*.java' | ast-tools-query java \
  -f java-definitions.scm \
  --format text
```

### Find Specific Classes

**Goal:** Find all class declarations in Java files.

**Command:**
```bash
git ls-files -- '*.java' | ast-tools-query java \
  -q "(class_declaration name: (identifier) @class.name) @class" \
  --format text
```

### Extract Method Names Only

**Goal:** Extract just the names of all methods from Java files.

**Command:**
```bash
git ls-files -- '*.java' | ast-tools-query java \
  -q "(method_declaration name: (identifier) @method.name)" \
  --format json | jq -r '.[] | .captures[] | .text'
```

## Gradle (Groovy) Examples

### Extract Top-Level Gradle Properties

**Goal:** Extract all top-level `sourceCompatibility` and `targetCompatibility` properties from Gradle files, ignoring any nested properties within tasks or other blocks.

**Query File:** `tools/external/ast-tools/queries/groovy-top-level-compatibility.scm`
```scheme
; Find top-level sourceCompatibility and targetCompatibility assignments
(
  (source_file
    (assignment
      (identifier) @property
      (_) @value
    )
  )
  (#match? @property "^(source|target)Compatibility$")
)
```

**Command:**
```bash
git ls-files -- '_sample_repos/spikes/gradle/*.gradle' | ast-tools-query groovy --compact -f groovy-top-level-compatibility.scm | jq '[.[] | {file: .file, source: (.captures | map(.name == "property" and .text == "sourceCompatibility") | index(true)) as $source_idx | if $source_idx then .captures[$source_idx + 1].text else null end, target: (.captures | map(.name == "property" and .text == "targetCompatibility") | index(true)) as $target_idx | if $target_idx then .captures[$target_idx + 1].text else null end}]'
```

**Explanation:**

This command combines a precise `ast-tools-query` with a robust `jq` filter.

1.  The `ast-tools-query` uses the `groovy-top-level-compatibility.scm` file. This query is designed to only match `assignment` nodes that are direct children of the `source_file` root node, effectively ignoring nested assignments.
2.  The `--compact` flag provides a concise JSON output for each file.
3.  The `jq` filter then processes this stream of JSON objects. For each object, it defines variables (`$source_idx`, `$target_idx`) to find the index of the `sourceCompatibility` and `targetCompatibility` properties.
4.  It then constructs a new JSON object with `file`, `source`, and `target` keys. It uses the indices to safely access the corresponding value, returning `null` if a property is not found in a given file.

**Output:**
```json
[
  {
    "file": "_sample_repos/spikes/gradle/java-single-prop.gradle",
    "source": "\"1.9\"",
    "target": null
  },
  {
    "file": "_sample_repos/spikes/gradle/java17-source-target.gradle",
    "source": "\"1.7\"",
    "target": "\"1.7\""
  }....
]
```

## Markdown Examples

### Extract All Headings

**Goal:** Extract all headings from markdown files with their levels.

**Command:**
```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -f markdown-headings.scm --matches --format json | \
  tools/external/ast-tools/queries/markdown-headings.sh
```

**Output:**
```json
{
  "file": "README.md",
  "headings": [
    {"level": 1, "text": "Project Title"},
    {"level": 2, "text": "Installation"},
    {"level": 2, "text": "Usage"}
  ]
}
```

### Find Markdown Files with Code Blocks

**Goal:** Find all markdown files that contain code blocks (fenced or indented).

**Command:**
```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(fenced_code_block) @code (indented_code_block) @code" \
  --format json | jq -r '.[] | .file' | sort -u
```

**Output:**
```text
README.md
_samples/example.md
tools/external/ast-tools/doc/samples.md
...
```

### Find Non-Code Language Identifiers in Markdown (e.g., Diagrams)

**Goal:** Find all fenced code blocks with non-code language identifiers (like mermaid, plantuml, console, text, regex, none) to identify inline diagrams or other non-code content.

**Step 1:** First, get all unique language identifiers used in fenced code blocks:

```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(fenced_code_block (info_string (language) @lang) @block)" \
  --format json 2>/dev/null | jq -r '.[] | .captures[] | select(.name == "lang") | .text' | sort -u
```

**Step 2:** Filter for non-code language identifiers (diagrams, text, etc.):

```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(fenced_code_block (info_string (language) @lang) @block)" \
  --format json 2>/dev/null | jq -r '.[] | .file as $f | .captures[] | select(.name == "lang") | {file: $f, lang: .text}' | \
  jq -s 'map(select(.lang == "console" or .lang == "mermaid" or .lang == "none" or .lang == "plantuml" or .lang == "regex" or .lang == "text"))'
```

**Output:**
```json
[
  {"file": ".roo/commands/document-roo-task.md", "lang": "plantuml"},
  {"file": "_samples/gephri-issue332/readme.md", "lang": "mermaid"},
  {"file": "_samples/js-chaos-issue633/js-detectors-analysis.md", "lang": "mermaid"},
  {"file": "_samples/python-docs/pyproject.toml.md", "lang": "mermaid"},
  {"file": "_samples/reports/xx-design-patterns.md", "lang": "mermaid"},
  {"file": "_samples/tree-sitter-markdown-issue628/README.md", "lang": "none"},
  {"file": "docs/tools-doc/toolkit-analysis-report.md", "lang": "mermaid"},
  {"file": "tools/external/ast-tools/doc/samples.md", "lang": "text"},
  {"file": "README.md", "lang": "console"},
  {"file": "_sample_repos/spikes/gradle/README.md", "lang": "regex"}
]
```

**Analysis:** This reveals 6 files with inline diagrams (mermaid/plantuml), plus files with console output, regex examples, and unlabeled code blocks.

### Find HTML Blocks in Markdown (TOC, Tables, Links)

**Goal:** Find all HTML blocks embedded in markdown files (e.g., TOC with links, tables, explicit anchors).

**Command:**
```bash
git ls-files -- '*.md' | ast-tools-query markdown \
  -q "(html_block) @html" \
  --format json | jq -r '.[] | .file as $f | .captures[] | {file: $f, html: .text}' | \
  jq -s 'group_by(.file) | map({file: .[0].file, html_blocks: map(.html) | length})'
```

**Sample Output:**
```json
[
  {"file": "_samples/tree-sitter-markdown-issue628/html-in-md.md", "html_blocks": 5}
]
```

**Extract specific HTML content (e.g., TOC with links):**
```bash
echo "_samples/tree-sitter-markdown-issue628/html-in-md.md" | ast-tools-query markdown \
  -q "(html_block) @html" --format json | \
  jq -r '.[] | .captures[].text' | grep -A5 '<ul id="toc">'
```

**Output:**
```html
<ul id="toc">
  <li><a href="#section-1">Section 1: Introduction</a></li>
  <li><a href="#section-2">Section 2: Details</a></li>
  <li><a href="#section-3">Section 3: Conclusion</a></li>
</ul>
```

**Sample file created:** `_samples/tree-sitter-markdown-issue628/html-in-md.md` contains:
- HTML TOC with anchor links (`<ul id="toc">`)
- Explicit anchors (`<a name="section-1">`, `<a id="section-2">`)
- HTML div notes (`<div class="note">`)
- HTML tables (`<table>`)
- HTML line breaks (`<br/>`)

## Python Examples

### Extract All Functions

**Goal:** Extract all function definitions from Python files.

**Command:**
```bash
git ls-files -- '*.py' | ast-tools-query python \
  -f python-definitions.scm \
  --format text
```

### Find Decorated Functions

**Goal:** Find all functions that have decorators.

**Command:**
```bash
git ls-files -- '*.py' | ast-tools-query python \
  -q "(decorated_definition (function_definition name: (identifier) @func.name)) @func" \
  --format text
```

### Extract Import Statements

**Goal:** Extract all import statements from Python files.

**Command:**
```bash
git ls-files -- '*.py' | ast-tools-query python \
  -q "(import_statement) @import" \
  --format text
```

### Find `subprocess.run` calls

**Goal:** Find all calls to `subprocess.run` in Python files and extract the file, the full code of the call, and the first argument.

**Command:**
```bash
find _sample_repos/spikes/call_commands-for-python-536/ -name '*.py' | \
ast-tools-query python -f python-subprocess-calls.scm --compact | \
jsontool -A -e '
  this.result = this.map(item => (
    {
      file: item.file, 
      commands: item.captures.filter(c => c.name === "command.name").map(c => c.text)
    }
  ))
' result
```

**Output (Snippet):**
```json
[
  {
    "file": "_sample_repos/spikes/call_commands-for-python-536//single_call.py",
    "commands": [
      "\"ls\""
    ]
  },
  {
    "file": "_sample_repos/spikes/call_commands-for-python-536//multiple_calls.py",
    "commands": [
      "command1",
      "command2",
      "ls_executable",
      "\"ls\""
    ]
  }
]
```

## Bash Examples

### Extract All Functions

**Goal:** Extract all function definitions from shell script files.

**Command:**
```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -q "(function_definition name: (word) @func.name) @func" \
  --format text
```

### Find Functions Calling Specific Commands

**Goal:** Find all functions that call the `xargs` command.

**Command:**
```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -q '(function_definition
        name: (word) @func.name
        body: (compound_statement
          (pipeline
            (command
              name: (command_name) @cmd
              (#match? @cmd "xargs"))))) @func' \
  --format text
```

### Extract String Literals

**Goal:** Extract all string literals from shell script files.

**Command:**
```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -q "(string) @str" \
  --format text
```

### Extract All Commands

**Goal:** Extract all commands from shell script files.

**Command:**
```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -f bash-commands.scm \
  --format json
```

### Find All Command Substitutions

**Goal:** Find all command substitution `$()` or `` `...` `` invocations in shell script files. These also create subshells.

**Command:**
```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -f bash-command-substitutions.scm \
  --format text
```

### Find All xargs Commands (Security Audit)

```bash
# Find all xargs commands without -0 flag (security vulnerability)
git ls-files -- 'tools/**/*.sh' | \
  ast-tools-query bash --compact \
    -f bash-all-xargs.scm \
    --format json | \
  jq -r '.[] | select(.captures | map(select(.name == "xargs.command" and (.text | contains("-0") | not))) | length > 0) | .file'

# xargs without -0 flag is vulnerable to filenames with spaces or special characters
# All xargs should use: tr "\n" "\0" | xargs -0 ...
```

### xargs calling grep, xmlstarlet or any other command

**Goal:** Find all calls to xargs ... grep, print xargs atrtributes and grep attributes
``` bash
  git ls-files -- 'tools/detect/*/*.sh' | ast-tools-query-bash-xargs-cmd grep
```
similar for xmlstarlet:

``` bash
  git ls-files -- 'tools/detect/*/*.sh' | ast-tools-query-bash-xargs-cmd xmlstralet
```

Sample Output:
``` json
{
  "file": "tools/detect/scripts2/sql.sh",
  "xargs_grep": {
    "name": "xargs_grep",
    "text": "xargs -0 grep -l -i 'EXECUTE\\s\\+IMMEDIATE'",
    "type": "command",
    "startPosition": {
      "row": 41,
      "column": 16
    },
    "endPosition": {
      "row": 41,
      "column": 58
    },
    "startByte": 1635,
    "endByte": 1677
  },
  "xargs-args": [
    "-0"
  ],
  "grep-args": [
    "'EXECUTE\\s\\+IMMEDIATE'",
    "-i",
    "-l"
  ]
}
```

### xargs calling ANY command (generic — all invocations)

<!-- Generated/modified by AI RooCode 3.53.0, used model google/claude-sonnet-4-6 -->

**Goal:** Find ALL xargs invocations in bash scripts, extracting xargs own flags, the sub-command name, and sub-command arguments — for any sub-command.

**Tool:** `ast-tools-query-bash-xargs-cmds` (uses `bash-xargs-commands.scm`)

``` bash
  git ls-files -- 'tools/detect/*/*.sh' | ast-tools-query-bash-xargs-cmds
```

Filter to a specific sub-command:
``` bash
  git ls-files -- 'tools/detect/*/*.sh' | ast-tools-query-bash-xargs-cmds | jq 'select(.cmd == "xmlstarlet")'
```

List all unique sub-commands called via xargs:
``` bash
  git ls-files -- 'tools/detect/*/*.sh' | ast-tools-query-bash-xargs-cmds | jq -s '[.[].cmd] | unique'
```

Sample Output (one JSON object per xargs invocation):
``` json
{
  "file": "tools/detect/scripts2/sql.sh",
  "xargs_cmd": {
    "name": "xargs_cmd",
    "text": "xargs -0 sql-detect-dialect",
    "type": "command",
    "startPosition": { "row": 10, "column": 16 },
    "endPosition":   { "row": 10, "column": 43 },
    "startByte": 412,
    "endByte": 439
  },
  "xargs-args": ["-0"],
  "cmd": "sql-detect-dialect",
  "cmd-args": []
}
```

### Find All Exported Variables

**Goal:** Find all `export` declarations in bash scripts (both `export VAR=value` and `export VAR`).

**Query using anchor to exclude `export -f` (functions):**
```bash
git ls-files -- '*.sh' | ast-tools-query bash -q '
((declaration_command (variable_assignment (variable_name) @var)) @d (#match? @d "^export"))
((declaration_command . (variable_name) @var) @d (#match? @d "^export"))' --format json | \
jq '[
  .[] as $parent |
  .captures[] |
  select(.name == "var") |
  {file: $parent.file, text: .text}
] | group_by(.file) | map(
  {file: .[0].file, exports: map(.text) | unique}
)'
```

**Note on anchors:** The `.` anchor requires `variable_name` to be the FIRST child of `declaration_command`. This excludes `export -f func` (functions) where `-f` is between `export` and the variable name.

**Alternation limitation:** Alternation `[]` with predicates doesn't work - see [tree-sitter#1392](https://github.com/tree-sitter/tree-sitter/issues/1392). Use two separate patterns instead.

**All declaration types (grammar):** `export`, `declare`, `typeset`, `readonly`, `local`

Replace `^export` with `^declare`, `^typeset`, `^readonly`, or `^local` to match other types.

## Gitattributes Examples

### Find Git LFS Tracked Patterns

**Goal:** Find all file patterns that are configured for Git LFS tracking in `.gitattributes` files, and group them by file.

**Query File:** `tools/external/ast-tools/queries/gitattributes-lfs-filter.scm`
```scheme
;
; Finds file patterns that are configured to use Git LFS.
;
; This query uses an anonymous parent `_` to correctly identify
; the sibling relationship between a `pattern` and its `attribute`
; as defined by the inlined grammar rules.
;

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
find . -name ".gitattributes" | \\
  ast-tools-query gitattributes -f gitattributes-lfs-filter.scm | \\
  jsontool -e 'const patterns = [...new Set(this.captures.filter(c => c.name === "pattern").map(c => c.text))]; if (patterns.length > 0) { this.result = { file: this.file, patterns: patterns }; }' | \\
  jsontool -ga result
```

**Output:**
```json
[
  {
    "file": "./_sample_repos/Roo-Code/.gitattributes",
    "patterns": [
      "demo.gif",
      "assets/docs/demo.gif",
      "src/assets/docs/demo.gif"
    ]
  }
]
```

## Advanced Queries

### Using Predicates

Tree-sitter queries support predicates for filtering:

```bash
# Match specific patterns
-q '(method_declaration name: (identifier) @name (#match? @name "^test"))'

# Equality check
-q '(method_declaration name: (identifier) @name (#eq? @name "main"))'

# Not equal
-q '(method_declaration name: (identifier) @name (#not-eq? @name "constructor"))'
```

### Combining with Standard Tools

#### Filter Results with jq

```bash
# Extract only method names from JSON
git ls-files -- '*.java' | ast-tools-query java \
  -q "(method_declaration name: (identifier) @method.name)" \
  --format json | \
  jq -r '.[] | .captures[] | select(.name == "method.name") | .text'
```

#### Process with xmlstarlet

```bash
# Extract class names from XML
git ls-files -- '*.java' | ast-tools-query java \
  -f java-definitions.scm \
  --format xml | \
  xmlstarlet sel -t -v '//capture[@name="name.definition.class"]' -n
```

#### Count Occurrences

```bash
# Count number of functions in Python files
git ls-files -- '*.py' | ast-tools-query python \
  -q "(function_definition) @func" \
  --format json | \
  jq '[.[] | .captureCount] | add'
```

## Pipeline Examples

### Find Files with Specific Patterns

```bash
# Find Java files with classes containing "Test"
git ls-files -- '*.java' | \
  ast-tools-query java \
    -q "(class_declaration name: (identifier) @name (#match? @name "Test"))" \
    --format json | \
  jq -r '.[] | select(.captureCount > 0) | .file'
```

### Extract and Sort

```bash
# Get all function names sorted alphabetically
git ls-files -- '*.py' | \
  ast-tools-query python \
    -q "(function_definition name: (identifier) @func.name)" \
    --format json | \
  jq -r '.[] | .captures[] | .text' | \
  sort -u
```

### Generate Reports

```bash
# Create a summary of classes per file
git ls-files -- '*.java' | \
  ast-tools-query java \
    -q "(class_declaration) @class" \
    --format json | \
  jq -r '.[] | "\(.file): \(.captureCount) classes"'
```


## Output Format Examples

### JSON Output (Default)

```json
[
  {
    "file": "src/Example.java",
    "captureCount": 5,
    "captures": [
      {
        "name": "definition.class",
        "text": "public class Example { ... }",
        "startPosition": { "row": 10, "column": 0 },
        "endPosition": { "row": 50, "column": 1 },
        "startByte": 200,
        "endByte": 1500
      }
    ]
  }
]
```

### Text Output

```
# src/Example.java
Captures: 5
  @definition.class [11:0]: public class Example
  @name.definition.class [11:13]: Example
  @definition.method [15:1]: public void doSomething()
```

### XML Output

```xml
<query-results>
  <file path="src/Example.java" captures="5">
    <capture name="definition.class" line="11" column="0">
      public class Example { ... }
    </capture>
  </file>
</query-results>
```

## Performance Tips

### Limit File Scope

```bash
# Process only recently modified files
# Note: git grep is generally preferred for repository-wide searches.
find . -name "*.java" -mtime -7 | ast-tools-query java -q "..."
```

### Use `git grep` for File Discovery

For repository-wide searches, `git grep -l -I` is almost always preferable to `find`. It is faster, respects `.gitignore`, and avoids binary files that can crash the parser.

### Use Specific Queries

```bash
# More specific queries are faster
# Good: Target specific nodes
-q "(class_declaration name: (identifier) @name)"

# Avoid: Overly broad queries
-q "(_) @everything"
```

### Parallel Processing

```bash
# Process files in parallel with xargs
# Note: While xargs can be used for parallel processing, ast-tools-query
# is often fast enough when processing a piped list of files.
# Use this pattern only when you have a very large number of files.
git ls-files -- '*.py' | \
  xargs -P 4 -I {} ast-tools-query python -q "(function_definition) @func" {}
```

## Troubleshooting

### Parse Errors

If you see parse errors, the tool will continue processing other files:

```
[ast-tools-query] Parse errors in: file.sh
```

### Query Syntax Errors

Invalid query syntax will show an error:

```
Error: Invalid query syntax
Expected '(' or identifier
```

### No Results

If no captures are found:

```json
[
  {
    "file": "test.java",
    "captureCount": 0,
    "captures": []
  }
]
```

## Available Query Files

Current query files in `tools/external/ast-tools/queries/`:

- `java-definitions.scm` - Java classes, methods, fields, constructors
- `python-definitions.scm` - Python functions, classes, imports
- `bash-commands.scm` - Bash command invocations
- `bash-string-literals.scm` - Bash string literals
- `bash-all-xargs.scm` - All xargs command invocations (for security auditing)
- `bash-subshells.scm` - Bash subshell `()` invocations
- `bash-command-substitutions.scm` - Bash command substitution `$()` and `` `...` `` invocations

## Creating Custom Queries

### Query File Format

Query files use tree-sitter query syntax (`.scm` files):

```scheme
; Comment
(node_type
  field: (child_type) @capture.name) @parent.capture

; With predicates
(method_declaration
  name: (identifier) @name
  (#match? @name "^test")) @test.method
```


## References

- [Tree-sitter Query Syntax](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries)
- [Tree-sitter Playground](https://tree-sitter.github.io/tree-sitter/playground) - Test queries interactively

## Python Main Module Entry Point Detection

### Query File
`tools/external/ast-tools/queries/python-main-module-entrypoint.scm`

### Purpose
Detects the Python main entry point idiom: `if __name__ == "__main__":`

This is a common pattern used in Python scripts to determine if the script is being run directly or imported as a module.

### Query Content
```scheme
; Query to find Python main entry point pattern: if __name__ == "__main__":

((if_statement
  condition: (comparison_operator
    (identifier) @name
    (string) @main_string))
  (#eq? @name "__name__")
  (#eq? @main_string "\"__main__\""))
```

### Usage Example

#### Basic Usage
```bash
# Single file
echo "script.py" | ast-tools-query python -f python-main-module-entrypoint.scm

# Multiple files
git ls-files -- '*.py' | ast-tools-query python -f python-main-module-entrypoint.scm
```

#### Integration with query-files2 (Detector Pattern)
```bash
# Alternative to grep-based python_main_module_entrypoint_detector_001
query-files2 "" "" -c "
  this.detectors.includes('python_py') &&
  this.detectors.includes('python_ast')
" -a file | \
ast-tools-query python -f python-main-module-entrypoint.scm | \
jq -c '.[] | {file: .file, detector: "python_main_module_entrypoint"}'
```

### Output Format
```json
{
  "file": "./script.py",
  "captureCount": 2,
  "captures": [
    {
      "name": "name",
      "text": "__name__",
      "startPosition": {"row": 10, "column": 3},
      "endPosition": {"row": 10, "column": 11},
      "startByte": 250,
      "endByte": 258
    },
    {
      "name": "main_string",
      "text": "\"__main__\"",
      "startPosition": {"row": 10, "column": 15},
      "endPosition": {"row": 10, "column": 25},
      "startByte": 262,
      "endByte": 272
    }
  ]
}
```

### Advantages over grep

#### Old grep approach (from python_main.sh):
```bash
grep -I -l 'if \+__name__ \+== \+"__main__"'
```

**Limitations:**
- Regex-based, not syntax-aware
- May match patterns in comments or string literals
- No position information
- Sensitive to whitespace variations
- Cannot distinguish between actual code and text in strings/comments

#### New AST-based approach:
```bash
ast-tools-query python -f python-main-module-entrypoint.scm
```

**Benefits:**
- **Syntax-aware parsing**: Understands Python AST structure
- **Exact pattern matching**: Uses tree-sitter predicates (#eq?) for precise matching
- **Rich metadata**: Provides exact line/column positions and byte offsets
- **No false positives**: Won't match the pattern in comments or string literals
- **Handles all formatting**: Works with any valid Python formatting/whitespace

### Tree-sitter Predicate Syntax

This query demonstrates the use of tree-sitter predicates:

- `(#eq? @capture "value")` - Exact equality check
- Predicates must be placed after the pattern, outside the main S-expression
- The pattern must be wrapped in double parentheses when using predicates: `(( ... ))`

### Testing the Query

```bash
# Test on a known file
echo "./_sample_repos/cinderella/tools/report/detector-report/report-detectors.py" | \
  ast-tools-query python -f python-main-module-entrypoint.scm

# Test on multiple files and count matches
git ls-files -- '*.py' | \
  ast-tools-query python -f python-main-module-entrypoint.scm | \
  jq '[.[] | .captureCount] | add'
```
- Query files: `tools/external/ast-tools/queries/`

### Find all ajs scripts executed by archi-cli

```bash
git grep -l -I 'archi-cli' -- '**/bin/*' | ast-tools-query bash -f bash-commands.scm --compact | jq '[.[] | .file as $file | .captures as $c | [range(0; $c | length) | select($c[.].name == "command.arg" and $c[.].text == "--script.runScript")] | map({file: $file, script: $c[. + 1].text})] | flatten | unique'
```

**Description:**

This command finds all files in `tools/archi/bin`, extracts all bash commands, and then uses `jq` to filter for `archi-cli` commands that use the `--script.runScript` argument. It then extracts the path to the `.ajs` script that follows.

**Output:**

```json
[
  {
    "file": "tools/archi/bin/archi-api-color-objects",
    "script": "$p/colorElementsInFolder.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-create-view",
    "script": "$p/createNewView.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-export-view-png",
    "script": "$p/exportViewsAsPng.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-export-view-png",
    "script": "$p/printModelName.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-export-views-png",
    "script": "$p/exportViewsAsPng.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-export-views-png",
    "script": "$p/printModelName.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-export-views-png",
    "script": "$p/printViewNames.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-import-csv",
    "script": "$p/changeModelName.ajs"
  },
  {
    "file": "tools/archi/bin/archi-api-mv-to-folder",
    "script": "$p/mvToFolder.ajs"
  },
  {
    "file": "tools/archi/bin/archi-cli-run-script",
    "script": "\"\$AJS_SCRIPT\""
  }
]
```

## HTML Examples

### Extract Title Text from HTML Files

**Goal:** Extract the `<title>` tag text from HTML files. Files without a `<title>` are silently skipped.

**Command:**
```bash
find _sample_repos -name "*.html" | \
  ast-tools-query html \
    -q '(element (start_tag (tag_name) @_tag (#eq? @_tag "title")) (text) @title.text)' \
    --matches --compact | \
  jq '.[] | {file, title: .captures[1].text}'
```

**Single file:**
```bash
echo "path/to/file.html" | \
  ast-tools-query html \
    -q '(element (start_tag (tag_name) @_tag (#eq? @_tag "title")) (text) @title.text)' \
    --matches --compact | \
  jq '.[] | {file, title: .captures[1].text}'
```

**Explanation:**
- The query matches any `element` whose `start_tag` contains a `tag_name` equal to `"title"` (via `#eq?` predicate), then captures the `text` child as `@title.text`.
- `@_tag` is a helper capture required by the `#eq?` predicate; it is always at index `0`.
- `@title.text` is always at index `1`, so `captures[1].text` extracts it with no `select()` needed.
- `--matches --compact` outputs one result per query match with no position metadata, minimising post-processing.
- Files without a `<title>` produce no matches and are silently omitted from output.

**Output:**
```json
{"file": "_sample_repos/alfresco-community-share/web-framework-commons/src/main/java/org/alfresco/web/config/forms/package.html", "title": "org.alfresco.web.config.forms package"}
{"file": "_sample_repos/alfresco-community-share/wcmquickstart-module/wcmquickstartwebsite/src/main/webapp/WEB-INF/500page.html", "title": "Error"}
```

<!-- Generated/modified by AI RooCode 3.52.0, used model google/claude-sonnet-4-6 -->

## JavaScript Examples

### Find Top-Level JSDoc Comments Containing @generated

**Goal:** Find all JavaScript files that have a top-level JSDoc block comment (`/** ... */`) at the program level containing the `@generated` tag.

**Command:**
```bash
find /path/to/js/files -name '*.js' | \
  ast-tools-query javascript -f javascript-toplevel-jsdoc-comments.scm --format json | \
  tools/external/ast-tools/queries/javascript-toplevel-jsdoc-comments-generated.sh
```

**Output (Snippet):**
```json
[
  {
    "file": ".../views/acm/001-acm-user/Screen.js",
    "generated": "@generated by OraFormViewer"
  },
  {
    "file": ".../views/home/Screen.js",
    "generated": "@generated by TemplateWizard, v.2013/02/27"
  }
]
```

**Notes:**
- Query file: [`javascript-toplevel-jsdoc-comments.scm`](queries/javascript-toplevel-jsdoc-comments.scm) — selects `comment` nodes that are direct children of `program` matching `^/\*\*` (JSDoc only); iterates ALL captures named `comment` per file
- Processing script: [`javascript-toplevel-jsdoc-comments-generated.sh`](queries/javascript-toplevel-jsdoc-comments-generated.sh) — filters captures by `@generated`, extracts full `@generated` text up to `//` or end of string into `generated` field

## TypeScript Examples

### Get Statistics on First Node Types

**Goal:** Get statistics on the first AST node type in all TypeScript files.

**Command:**

```bash
git ls-files -- '*.ts' | ./tools/external/ast-tools/bin/ast-tools-query typescript/typescript -q '(program (_) @element)' | jq '[.[] | select(.captureCount > 0) | .captures[0].type] | group_by(.) | map({type: .[0], count: length}) | sort_by(-.count)'
```

**Output:**

```json
[
  {
    "type": "comment",
    "count": 16
  },
  {
    "type": "expression_statement",
    "count": 12
  },
  {
    "type": "export_statement",
    "count": 2
  },
  {
    "type": "import_statement",
    "count": 2
  },
  {
    "type": "type_alias_declaration",
    "count": 2
  }
]
```

### Get Statistics on Last Node Types

**Goal:** Get statistics on the last AST node type in all TypeScript files.

**Command:**

```bash
git ls-files -- '*.ts' | ./tools/external/ast-tools/bin/ast-tools-query typescript/typescript -q '(program (_) @element)' | jq '[.[] | select(.captureCount > 0) | .captures[-1].type] | group_by(.) | map({type: .[0], count: length}) | sort_by(-.count)'
```

**Output:**

```json
[
  {
    "type": "ambient_declaration",
    "count": 13
  },
  {
    "type": "expression_statement",
    "count": 13
  },
  {
    "type": "export_statement",
    "count": 6
  },
  {
    "type": "comment",
    "count": 2
  }
]
```
