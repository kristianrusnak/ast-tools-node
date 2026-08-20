; Query to find Python decorators with context
; Captures ALL decorators in a decorated_definition (handles multiple decorators)

; Pattern 1: Decorated method inside a class (captures all decorators)
(class_definition
  name: (identifier) @outer_class_name
  body: (block
    (decorated_definition
      (decorator)+ @decorator.method
      (function_definition
        name: (identifier) @method_name
      )
    )
  )
)

; Pattern 2: Decorated nested class inside a class (captures all decorators)
(class_definition
  name: (identifier) @outer_class_name
  body: (block
    (decorated_definition
      (decorator)+ @decorator.nested_class
      (class_definition
        name: (identifier) @inner_class_name
      )
    )
  )
)

; Pattern 3: Top-level decorated function (captures all decorators)
(module
  (decorated_definition
    (decorator)+ @decorator.function
    (function_definition
      name: (identifier) @function_name
    )
  )
)

; Pattern 4: Top-level decorated class (captures all decorators)
(module
  (decorated_definition
    (decorator)+ @decorator.class
    (class_definition
      name: (identifier) @class_name
    )
  )
)