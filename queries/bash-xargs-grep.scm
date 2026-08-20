; Capture any command that calls xargs ... grep 
; duplicate captures removed by postprocessing 
; see also tools/external/ast-tools/bin/ast-tools-query-bash-xargs-cmd
(
  (command 
    name: (command_name (word) @cmd) 
    (_)* @xargs-args 
    (word) @grep
    (_)* @grep-args
    
    (#eq? @cmd "xargs") 
    (#any-not-eq? @xargs-args "grep")
    (#eq? @grep "grep") 
  ) @xargs_grep
) (#match? @xargs_grep "xargs.*grep")


