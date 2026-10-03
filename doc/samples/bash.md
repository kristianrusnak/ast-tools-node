<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — Bash examples

Bundled queries: `ast-tools-queries list --language bash` (commands, subshells, command
substitutions, xargs calls, main guards, ...). Read a query's header with
`ast-tools-queries show <name>` before relying on its captures.

## Extract all functions

```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -q "(function_definition name: (word) @func.name) @func" \
  --format text
```

## Find functions calling a specific command

**Goal:** Find all functions that call `xargs`.

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

## Extract string literals

```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -q "(string) @str" \
  --format text
```

## Extract all commands

```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -f bash-commands.scm \
  --format json
```

In the JSON, each command contributes `command.name` and `command.arg` captures in source order.

## Find the value following a specific flag

**Goal:** Find every call of `mytool` that passes `--script` and report the value after the flag.
Pre-filter the files with `git grep` (cheap), then let the AST decide.

```bash
git grep -l -I 'mytool' | \
  ast-tools-query bash -f bash-commands.scm --compact | \
  jq '[.[] | .file as $file | .captures as $c | [range(0; $c | length) | select($c[.].name == "command.arg" and $c[.].text == "--script")] | map({file: $file, command: "mytool", parameter: $c[.].text, value: $c[. + 1].text})] | flatten | unique'
```

**Output:**
```json
[
  {"file": "deploy.sh", "command": "mytool", "parameter": "--script", "value": "other.ajs"},
  {"file": "deploy.sh", "command": "mytool", "parameter": "--script", "value": "run.ajs"}
]
```

The `$c[. + 1]` trick relies on the value being the next capture after the flag. This does not
check that the surrounding command is really `mytool` — add a `command.name` check when a
script mixes several tools.

## Find commands with arguments matching a regex

**Goal:** Report the command name and matching argument for every argument that mentions
`elements.csv` or `report`.

```bash
git grep -l -I -E 'elements\.csv|report' | \
  ast-tools-query bash -f bash-commands.scm --compact | \
  jq '[.[] | .file as $file | .captures | reduce .[] as $item ({last_cmd: null, items: []}; if $item.name == "command.name" then .last_cmd = $item.text else . end | if $item.name == "command.arg" and ($item.text | test("elements\\.csv|report")) then .items += [{file: $file, command: .last_cmd, arg: $item.text}] else . end) | .items] | flatten'
```

## Find all command substitutions

**Goal:** Find `$(...)` and `` `...` `` substitutions. They also create subshells.

```bash
git ls-files -- '*.sh' | ast-tools-query bash \
  -f bash-command-substitutions.scm \
  --format text
```

## Find subshells

```bash
git ls-files -- '*.sh' | ast-tools-query bash -f bash-subshells.scm --format text
```

## Find xargs calls without `-0` (security audit)

```bash
# xargs without -0 breaks on file names with spaces or special characters.
# Preferred form: tr "\n" "\0" | xargs -0 ...
git ls-files -- '*.sh' | \
  ast-tools-query bash --compact \
    -f bash-all-xargs.scm \
    --format json | \
  jq -r '.[] | select(.captures | map(select(.name == "xargs.command" and (.text | contains("-0") | not))) | length > 0) | .file'
```

Related queries: `bash-xargs-grep.scm` (xargs feeding `grep`) and `bash-xargs-commands.scm`
(xargs feeding any command, split into xargs flags, sub-command and its arguments). Use `--matches`
with them and read their headers — their known limitations (flags that take a value) are documented there.

## Find all exported variables

**Goal:** Find all `export` declarations (`export VAR=value` and `export VAR`).

```bash
git ls-files -- '*.sh' | ast-tools-query bash -q '
((declaration_command (variable_assignment (variable_name) @var)) @d (#match? @d "^export"))
((declaration_command . (variable_name) @var) @d (#match? @d "^export"))' --format json | \
jq '[
  .[] | .file as $file |
  .captures[] |
  select(.name == "var") |
  {file: $file, text: .text}
] | group_by(.file) | map(
  {file: .[0].file, exports: map(.text) | unique}
)'
```

**Anchors:** the `.` anchor requires `variable_name` to be the FIRST child of `declaration_command`.
This excludes `export -f func` (functions), where `-f` sits between `export` and the name.

**Alternation limitation:** `[]` alternation with predicates does not work (see
[tree-sitter#1392](https://github.com/tree-sitter/tree-sitter/issues/1392)); use two separate
patterns as above.

**All declaration types:** `export`, `declare`, `typeset`, `readonly`, `local` — replace `^export`
with the one you need.
