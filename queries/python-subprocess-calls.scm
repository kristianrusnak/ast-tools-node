; Generated/modified by AI RooCode 3.36.0, used model google/gemini-2.5-pro
;
; Finds calls to subprocess.run and captures only the command name.
; This file contains multiple, non-overlapping queries to handle different
; argument structures accurately.
;

; Query 1: Handles when the command is a single identifier.
; e.g., subprocess.run(my_command)
(call
  function: (attribute
    object: (identifier) @object
    attribute: (identifier) @method)
  arguments: (argument_list
    .
    (identifier) @command.name
  )
  (#eq? @object "subprocess")
  (#eq? @method "run")
) @call

; Query 2: Handles when the command is a single string.
; e.g., subprocess.run("ls -l", shell=True)
(call
  function: (attribute
    object: (identifier) @object
    attribute: (identifier) @method)
  arguments: (argument_list
    .
    (string) @command.name
  )
  (#eq? @object "subprocess")
  (#eq? @method "run")
) @call

; Query 3: Handles when the command is a list.
; Captures only the first element of the list (which can be a string or an identifier).
; e.g., subprocess.run(["ls", "-l"])
; e.g., subprocess.run([my_executable, "-l"])
(call
  function: (attribute
    object: (identifier) @object
    attribute: (identifier) @method)
  arguments: (argument_list
    .
    (list
      .
      [
        (identifier) @command.name
        (string) @command.name
      ]
    )
  )
  (#eq? @object "subprocess")
  (#eq? @method "run")
) @call