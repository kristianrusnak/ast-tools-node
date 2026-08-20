; Query to find Java main entry point pattern: public static void main(String[] args)

((method_declaration
  (modifiers) @mods
  (void_type)
  name: (identifier) @name
  parameters: (formal_parameters
    (formal_parameter
      type: (array_type
        element: (type_identifier) @param_type
        dimensions: (dimensions)
      )
    )
  ))
  (#eq? @name "main")
  (#match? @mods "public")
  (#match? @mods "static")
  (#eq? @param_type "String"))

; Query to find Java main entry point pattern: public static void main(String... args)

((method_declaration
  (modifiers) @mods
  (void_type)
  name: (identifier) @name
  parameters: (formal_parameters
    (spread_parameter
      (type_identifier) @param_type
    )
  ))
  (#eq? @name "main")
  (#match? @mods "public")
  (#match? @mods "static")
  (#eq? @param_type "String"))

; Query to find Java main entry point pattern: public static void main(String args[])

((method_declaration
  (modifiers) @mods
  (void_type)
  name: (identifier) @name
  parameters: (formal_parameters
    (formal_parameter
      type: (type_identifier) @param_type
      dimensions: (dimensions)
    )
  ))
  (#eq? @name "main")
  (#match? @mods "public")
  (#match? @mods "static")
  (#eq? @param_type "String"))
