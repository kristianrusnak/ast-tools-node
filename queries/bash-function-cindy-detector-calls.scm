; Generated/modified by AI RooCode 3.36.0, used model google/claude-sonnet-4-6
;
; Bash Detector Function Calls Query
; Finds all bash functions with _detector in the name and captures
; all commands called within them, based on observed AST patterns.
;
; PRIMARY CONSUMER: detector-impls tool (tools/detect/bin/detector-impls)
; This query was designed specifically to power detector-impls, which wraps
; it with the jq pipeline below to produce the final JSON output.
;
; The capture name encodes the AST path context (e.g. call.pipeline, call.if, etc.)
; so jq can include the call context in the output JSON without needing patternIndex.
;
; IMPORTANT: Use --matches flag so each pattern match is returned separately,
; giving properly scoped function.name + call.CONTEXT pairs per match.
; Then use jq to group_by function name to collect all calls per function.
;
; Usage:
;   git grep -l -I '_detector' -- tools/detect/scripts tools/detect/scripts2 | \
;     ast-tools-query bash -f bash-function-cindy-detector-calls.scm --matches --compact | \
;     jq '[.[] | {
;       file: .file,
;       function: (.captures[] | select(.name == "function.name") | .text),
;       pattern: (.captures[] | select(.name | startswith("call.")) | .name | ltrimstr("call.")),
;       cmd: (.captures[] | select(.name | startswith("call.")) | .text)
;     }] |
;     group_by(.function) |
;     map({
;       file: .[0].file,
;       function: .[0].function,
;       calls: ([.[].cmd] | unique),
;       patterns: (group_by(.pattern) | map({pattern: .[0].pattern, calls: [.[].cmd]}))
;     })'
;
; Output per function: {file, function, calls:[cmd,...], patterns:[{pattern, calls:[cmd,...]}]}
; Use detector-impls tool which wraps this query.

; Pattern 1: direct command in function body
; path: function -> compound_statement -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (command name: (command_name) @call.direct)))

; Pattern 2: command in pipeline in function body
; path: function -> compound_statement -> pipeline -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (pipeline
      (command name: (command_name) @call.pipeline))))

; Pattern 3: command in if_statement body (direct)
; path: function -> compound_statement -> if_statement -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (if_statement
      (command name: (command_name) @call.if))))

; Pattern 4: command in pipeline inside while inside pipeline
; path: function -> compound_statement -> pipeline -> while_statement -> do_group -> pipeline -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (pipeline
      (while_statement
        body: (do_group
          (pipeline
            (command name: (command_name) @call.pipeline_while_pipeline)))))))

; Pattern 5: command in subshell inside pipeline in function body
; path: function -> compound_statement -> pipeline -> subshell -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (pipeline
      (subshell
        (command name: (command_name) @call.pipeline_subshell)))))

; Pattern 6: redirected command in function body (e.g. java-search 2>/dev/null ...)
; path: function -> compound_statement -> redirected_statement -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (redirected_statement
      body: (command name: (command_name) @call.redirected))))

; Pattern 7: redirected pipeline in function body (e.g. cfind | tr | xargs ... 2>/dev/null)
; path: function -> compound_statement -> redirected_statement -> pipeline -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (redirected_statement
      body: (pipeline
        (command name: (command_name) @call.redirected_pipeline)))))

; Pattern 8: pipeline directly in if_statement body (no compound_statement wrapper)
; path: function -> compound_statement -> if_statement -> pipeline -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (if_statement
      (pipeline
        (command name: (command_name) @call.if_pipeline)))))

; Pattern 9: redirected inner pipeline inside outer pipeline
; e.g. query-files2 | ast-tools-parse 2>/dev/null | xmlstarlet ...
; The inner "query-files2 | ast-tools-parse" is wrapped in redirected_statement
; as a child of the outer pipeline. Pattern 2 captures the outer commands
; (xmlstarlet, tr, ...) but misses the inner redirected sub-pipeline commands.
; path: function -> compound_statement -> pipeline -> redirected_statement -> pipeline -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (pipeline
      (redirected_statement
        body: (pipeline
          (command name: (command_name) @call.pipeline_redirected_pipeline))))))

; Pattern 10: subshell pipeline inside outer pipeline
; e.g. (query-files2 | sort | tr | xargs exiftool) | jsontool ...
; The inner pipeline is wrapped in a subshell node as a child of the outer pipeline.
; Pattern 2 captures the outer commands (jsontool) but misses the subshell commands.
; path: function -> compound_statement -> pipeline -> subshell -> pipeline -> command
(function_definition
  name: (word) @function.name
  (#match? @function.name "_detector")
  body: (compound_statement
    (pipeline
      (subshell
        (pipeline
          (command name: (command_name) @call.pipeline_subshell_pipeline))))))
