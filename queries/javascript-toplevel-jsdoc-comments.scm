; Generated/modified by AI RooCode 3.52.0, used model google/claude-sonnet-4-6
;
; JavaScript Tree-sitter Query: Find top-level JSDoc block comments in JS files
;
; This query finds JSDoc block comments (/** ... */) that are direct children
; of the program node (top-level only, not nested inside functions/classes).
;
; In tree-sitter JavaScript, both // and /* */ comments use the "comment" node type.
; The #match? predicate on "^/\*\*" filters to JSDoc comments only (/** style).
;
; Usage:
;   find /path -name '*.js' | ast-tools-query javascript -f javascript-toplevel-jsdoc-comments.scm --format json
;   git ls-files -- '*.js' | ast-tools-query javascript -f javascript-toplevel-jsdoc-comments.scm --format json
;
(program
  (comment) @comment
  (#match? @comment "^/\\*\\*")
)
