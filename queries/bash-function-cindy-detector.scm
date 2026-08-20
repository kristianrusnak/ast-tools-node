; Generated/modified by AI RooCode 3.51.1, used model minimax-m2.5
;
; Bash Function Cindy Detector Query
; Finds all bash functions with _detector in the name
; Usage:
;   git grep -l -I '_detector' -- tools/detect/scripts tools/detect/scripts2 | \
;     ast-tools-query bash -f bash-function-cindy-detector.scm --compact | \
;     jq '[.[] | {file: .file, function: .captures[] | select(.name == "function.name") | .text}] | unique'

; Function definitions with _detector in the name
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")) @function.def