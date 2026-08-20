; Generated/modified by AI RooCode 3.32.1, used model google/claude-sonnet-4-5
;
; Python Tree-sitter Query Patterns
; Adapted from: _sample_repos/Roo-Code/src/services/tree-sitter/queries/python.ts

; Class definitions (including decorated)
(class_definition
  name: (identifier) @name.definition.class) @definition.class

(decorated_definition
  definition: (class_definition
    name: (identifier) @name.definition.class)) @definition.class

; Function and method definitions (including async and decorated)
(function_definition
  name: (identifier) @name.definition.function) @definition.function

(decorated_definition
  definition: (function_definition
    name: (identifier) @name.definition.function)) @definition.function

; Lambda expressions
(expression_statement
  (assignment
    left: (identifier) @name.definition.lambda
    right: (parenthesized_expression
      (lambda)))) @definition.lambda

; Generator functions (functions containing yield)
(function_definition
  name: (identifier) @name.definition.generator
  body: (block
    (expression_statement
      (yield)))) @definition.generator

; Import statements
(import_from_statement) @definition.import
(import_statement) @definition.import