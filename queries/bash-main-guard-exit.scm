; Matches the bash 'must be sourced' idiom.
;
; This pattern is a specialization of the main guard, where the script
; explicitly exits if it is not sourced.
;
; Example:
; if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
;     echo "This script must be sourced."
;     exit 1
; fi

(if_statement
  condition: (test_command
    (binary_expression
      left: (string
        (expansion
          (subscript
            (variable_name) @var_name
            (#eq? @var_name "BASH_SOURCE")
          )
        )
      )
      operator: "=="
      right: (string
        (expansion
          (special_variable_name) @special_var
          (#eq? @special_var "0")
        )
      )
    )
  )
  (command
    (command_name
      (word) @cmd_name
      (#eq? @cmd_name "exit")
    )
  )
) @must_be_sourced
