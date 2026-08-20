; Find top-level sourceCompatibility and targetCompatibility assignments
(
  (source_file
    (assignment
      (identifier) @property
      (_) @value
    )
  )
  (#match? @property "^(source|target)Compatibility$")
)
