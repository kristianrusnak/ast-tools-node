; Generated/modified by AI RooCode 3.54.0, used model google/gemini-2.5-pro
; Matches the bash main guard idiom: if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
;
; Example:
; if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
;   main "$@"
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
) @main_guard
