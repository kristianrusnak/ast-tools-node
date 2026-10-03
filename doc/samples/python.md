<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — Python examples

Bundled queries: `ast-tools-queries list --language python`.

## Extract all functions

```bash
git ls-files -- '*.py' | ast-tools-query python \
  -f python-definitions.scm \
  --format text
```

## Find decorated functions

```bash
git ls-files -- '*.py' | ast-tools-query python \
  -q "(decorated_definition (function_definition name: (identifier) @func.name)) @func" \
  --format text
```

The bundled `python-decorators.scm` is the same idea with richer captures.

## Extract import statements

```bash
git ls-files -- '*.py' | ast-tools-query python \
  -q "(import_statement) @import" \
  --format text
```

## Find `subprocess.run` calls

**Goal:** Find all calls to `subprocess.run` and list the command each one runs.

```bash
git ls-files -- '*.py' | \
  ast-tools-query python -f python-subprocess-calls.scm --compact | \
  jq '[.[] | {file: .file, commands: [.captures[] | select(.name == "command.name") | .text]}]'
```

**Output (snippet):**
```json
[
  {
    "file": "single_call.py",
    "commands": ["\"ls\""]
  },
  {
    "file": "multiple_calls.py",
    "commands": ["command1", "command2", "ls_executable", "\"ls\""]
  }
]
```

## Detect the `if __name__ == "__main__":` entry point

Query file: `python-main-module-entrypoint.scm` (`ast-tools-queries show python-main-module-entrypoint`).

```bash
# One file
echo "script.py" | ast-tools-query python -f python-main-module-entrypoint.scm

# All files, only the names of files that have a main guard
git ls-files -- '*.py' | ast-tools-query python -f python-main-module-entrypoint.scm --compact | \
  jq -r '.[] | select(.captureCount > 0) | .file'
```

**Why an AST query instead of grep:** `grep 'if __name__ == "__main__"'` also matches comments and
string literals and is sensitive to whitespace. The query matches the real `if_statement` node only.

**Predicate note:** when a pattern uses predicates such as `(#eq? @name "__name__")`, wrap the
pattern in an extra pair of parentheses: `((if_statement ...) (#eq? ...))`.
