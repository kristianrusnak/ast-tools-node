; Generated/modified by AI RooCode 3.32.1, used model google/claude-sonnet-4-5
;
; Bash Commands Query
; Extracts command invocations from bash scripts
; Inspired by: tools/external/ast-tools/xslt/bash-commands.xslt

; Command nodes - captures the command element
(command
  name: (command_name) @command.name) @command

; Command with arguments
(command
  name: (command_name) @command.name
  argument: (_) @command.arg) @command.with_args

; Function definitions - for context
(function_definition
  name: (word) @function.name) @function.def

; Variable assignments with command substitution
(variable_assignment
  name: (variable_name) @var.name
  value: (command_substitution
    (command) @command.in_substitution))

; Pipeline commands
(pipeline
  (command) @command.in_pipeline)

; Commands in if/while/for conditions
(if_statement
  condition: (command) @command.in_condition)

(while_statement
  condition: (command) @command.in_condition)

(for_statement
  body: (do_group
    (command) @command.in_loop))