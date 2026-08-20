; Generated/modified by AI RooCode 3.32.1, used model google/claude-sonnet-4-5
;
; Java Tree-sitter Query Patterns
; Adapted from: _sample_repos/Roo-Code/src/services/tree-sitter/queries/java.ts

; Class declarations
(class_declaration
  name: (identifier) @name.definition.class) @definition.class

; Interface declarations
(interface_declaration
  name: (identifier) @name.definition.interface) @definition.interface

; Enum declarations
(enum_declaration
  name: (identifier) @name.definition.enum) @definition.enum

; Method declarations
(method_declaration
  name: (identifier) @name.definition.method) @definition.method

; Constructor declarations
(constructor_declaration
  name: (identifier) @name.definition.constructor) @definition.constructor

; Field declarations
(field_declaration
  declarator: (variable_declarator
    name: (identifier) @name.definition.field)) @definition.field

; Annotation type declarations
(annotation_type_declaration
  name: (identifier) @name.definition.annotation) @definition.annotation

; Record declarations (Java 14+)
(record_declaration
  name: (identifier) @name.definition.record) @definition.record