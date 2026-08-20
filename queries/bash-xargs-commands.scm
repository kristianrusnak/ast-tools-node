; Generated/modified by AI RooCode 3.53.0, used model google/claude-sonnet-4-6
;
; Generic xargs command extractor for Bash scripts.
;
; PURPOSE:
;   Generalisation of bash-xargs-grep.scm — captures xargs invocations for
;   ANY sub-command (not just grep). Designed to be used with
;   ast-tools-query-bash-xargs-cmd or post-processed with jq.
;
; DESIGN NOTES:
;   In the bash tree-sitter grammar, ALL arguments to a command (xargs own
;   flags, the sub-command name, and the sub-command's arguments) are flat
;   `argument:` children of the `command` node — structurally identical.
;
;   This query uses the same (_)* wildcard pattern as bash-xargs-grep.scm
;   and ast-tools-query-bash-xargs-cmd to capture:
;
;     @xargs          - the literal word "xargs"
;     @xargs-args     - zero or more arguments before the sub-command
;                       (xargs own flags: -0, -I{}, -n1, -P4, -r, -t, etc.)
;     @cmd            - the sub-command name (first non-flag word after xargs)
;     @cmd-args       - zero or more arguments after the sub-command
;                       (sub-command flags and positional arguments)
;     @xargs_cmd      - the entire xargs command node (full invocation text)
;
;   CONSTRAINT: @cmd must not start with "-" (it is the sub-command name,
;   not a flag). This is enforced by (#match? @cmd "^[^-]").
;
;   KNOWN LIMITATION:
;     xargs flags that accept a value argument (e.g. -I {}, -n 1, -P 4,
;     -E eof, -a file, -d delim, -s size) where the value does not start
;     with "-" will be captured as @cmd (the sub-command name) rather than
;     as @xargs-args. Post-processing must account for this by knowing which
;     xargs flags consume a following argument.
;     Common value-consuming xargs flags: -I, -n, -P, -E, -a, -d, -s, -L.
;
;   DUPLICATE CAPTURES:
;     Tree-sitter produces duplicate captures for the same node because the
;     outer `((...) (#match?...))` wrapper causes two matches per invocation.
;     Use the same deduplication approach as ast-tools-query-bash-xargs-cmd:
;     keep the last occurrence by index (group_by + max index).
;
;   MULTIPLE XARGS PER FILE:
;     Files with multiple xargs invocations produce all captures in a single
;     flat array per file. Use @xargs_cmd (with startByte/endByte position)
;     as the grouping key to separate individual xargs invocations.
;     Each @xargs_cmd node's byte range defines which other captures belong
;     to it (all captures with startByte within [xargs_cmd.startByte,
;     xargs_cmd.endByte] belong to that invocation).
;
; Captures:
;   @xargs_cmd   - entire xargs command node (full invocation text + position)
;   @xargs       - the word "xargs"
;   @xargs-args  - xargs own flags/options (before the sub-command)
;   @cmd         - the sub-command name (first non-flag argument)
;   @cmd-args    - sub-command arguments (after the sub-command name)
;
; USAGE:
;   git ls-files -- '*.sh' | ast-tools-query bash -f bash-xargs-commands.scm --format json
;
; POST-PROCESSING EXAMPLE (jq) — extract sub-command name per invocation:
;   ... | jq '[.[] | .file as $f | .captures |
;     {file: $f,
;      cmd:  (map(select(.name=="cmd"))  | first | .text),
;      xargs_args: [map(select(.name=="xargs-args")) | .[].text],
;      cmd_args:   [map(select(.name=="cmd-args"))   | .[].text]}]'
;
; SEE ALSO:
;   bash-xargs-grep.scm              — same pattern, grep-specific
;   bash-all-xargs.scm               — simpler, whole-node capture only
;   ast-tools-query-bash-xargs-cmd   — CLI wrapper for a specific sub-command
;   ast-tools-query-bash-xargs-cmds  — CLI wrapper using this SCM (all commands)

(
  (command
    name: (command_name (word) @xargs)
    (_)* @xargs-args
    (word) @cmd
    (_)* @cmd-args

    (#eq? @xargs "xargs")
    (#match? @cmd "^[^-]")
  ) @xargs_cmd
) (#match? @xargs_cmd "xargs")
