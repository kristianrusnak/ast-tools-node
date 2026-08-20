; Generated/modified by AI RooCode 3.36.0, used model google/claude-sonnet-4-6
;
; Java Tree-sitter Query: Find block comments directly above top-level type declarations
;
; This query finds block comments that appear immediately before:
; - Class declarations (top-level only, not nested)
; - Interface declarations
; - Enum declarations
; - Record declarations
; - Annotation type declarations
;
; Use with --matches flag to get separate results per pattern match, then pair by position.
;
; Patterns 0-4: Type declarations WITH preceding block comment (captureCount = 3)
; Note: The . operator matches siblings - block_comment and class_declaration are siblings under program
; Both are anchored under (program ...) to exclude nested classes/types.
(program
  (block_comment) @comment
  .
  (class_declaration (modifiers) @class.modifiers name: (identifier) @class.name)
)
(program
  (block_comment) @comment
  .
  (class_declaration name: (identifier) @class.name)
)
(program
  (block_comment) @comment
  .
  (interface_declaration (modifiers) @interface.modifiers name: (identifier) @interface.name)
)
(program
  (block_comment) @comment
  .
  (interface_declaration name: (identifier) @interface.name)
)
(program
  (block_comment) @comment
  .
  (enum_declaration (modifiers) @enum.modifiers name: (identifier) @enum.name)
)
(program
  (block_comment) @comment
  .
  (enum_declaration name: (identifier) @enum.name)
)
(program
  (block_comment) @comment
  .
  (record_declaration (modifiers) @record.modifiers name: (identifier) @record.name)
)
(program
  (block_comment) @comment
  .
  (record_declaration name: (identifier) @record.name)
)
(program
  (block_comment) @comment
  .
  (annotation_type_declaration (modifiers) @annotation.modifiers name: (identifier) @annotation.name)
)
(program
  (block_comment) @comment
  .
  (annotation_type_declaration name: (identifier) @annotation.name)
)

; Patterns 5-9: Type declarations WITHOUT preceding block comment (captureCount = 2 or 1)
; Match only direct children of program (top-level) - exclude nested classes
(program (class_declaration (modifiers) @class.modifiers name: (identifier) @class.name))
(program (class_declaration name: (identifier) @class.name))
(program (interface_declaration (modifiers) @interface.modifiers name: (identifier) @interface.name))
(program (interface_declaration name: (identifier) @interface.name))
(program (enum_declaration (modifiers) @enum.modifiers name: (identifier) @enum.name))
(program (enum_declaration name: (identifier) @enum.name))
(program (record_declaration (modifiers) @record.modifiers name: (identifier) @record.name))
(program (record_declaration name: (identifier) @record.name))
(program (annotation_type_declaration (modifiers) @annotation.modifiers name: (identifier) @annotation.name))
(program (annotation_type_declaration name: (identifier) @annotation.name))
