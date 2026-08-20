; Find cfind calls with multiple -iname/-ipath/-name/-path patterns
; to verify they have proper parentheses grouping with -type f

; Pattern: cfind with multiple name/path patterns using -o
(command
  name: (command_name) @cmd
  (#eq? @cmd "cfind")
  argument: (_)* @args
  (#match? @args "-(i)?(name|path)")
  (#match? @args "-o")
) @cfind_call

; Capture the entire command for context
(command
  name: (command_name) @cmd
  (#eq? @cmd "cfind")
) @cfind_command