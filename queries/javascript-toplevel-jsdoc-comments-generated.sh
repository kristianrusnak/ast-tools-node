#!/bin/bash
# Generated/modified by AI RooCode 3.52.0, used model google/claude-sonnet-4-6
#
# Find all JavaScript files with top-level JSDoc block comments containing @generated tag
# and extract the full @generated value (from @generated up to // or end of string).
#
# Usage (pipe in ast-tools-query output):
#   find /path -name '*.js' | \
#     ast-tools-query javascript -f javascript-toplevel-jsdoc-comments.scm --format json | \
#     tools/external/ast-tools/queries/javascript-toplevel-jsdoc-comments-generated.sh
#
# Output: JSON array with file and generated (text from @generated to // or end)

jq -r '[.[] |
  select(.captures != null and (.captures | length > 0)) |
  .file as $file |
  .captures[] |
  select(.name == "comment") |
  select(.text | test("@generated")) |
  .text as $comment |
  ($comment | match("(@generated(?:(?!//).)*?)(?:\\s*//|\\s*$)")) as $m |
  ($m.captures[0].string | rtrimstr(" ")) as $generated |
  {
    file: $file,
    generated: $generated
  }
] | unique_by(.file)'
