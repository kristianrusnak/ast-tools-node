;
; Finds file patterns that are configured to use Git LFS.
;
; This query finds a rule line that contains BOTH a file pattern
; and the specific 'filter=lfs' attribute, capturing only the
; file pattern associated with that rule.
;
(_
  (pattern) @pattern
  .
  (attribute
    (builtin_attr) @key
    (attr_set)
    (string_value) @value
    (#eq? @key "filter")
    (#eq? @value "lfs")
  )
)