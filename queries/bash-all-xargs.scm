; Generated/modified by AI RooCode 3.32.1, used model google/claude-sonnet-4-5
;
; All xargs Commands in Bash Scripts
; Finds all xargs command invocations anywhere in the script
; (not limited to function definitions)

; Capture any command that calls xargs
(command
  name: (command_name) @cmd
  (#eq? @cmd "xargs")) @xargs.command