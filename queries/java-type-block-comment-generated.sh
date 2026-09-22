#!/bin/bash
# Generated/modified by AI RooCode 3.52.0, used model google/claude-sonnet-4-6
#
# Find all Java files with block comments above class declarations containing @generated tag
# and extract the full @generated value (from @generated up to // or end of string).
#
# Usage (pipe in ast-tools-query output):
#   query-files2 '' 'java_type_class' -a file | \
#     ast-tools-query java -f java-type-block-comment.scm --matches --format json | \
#     tools/external/ast-tools/queries/java-type-block-comment-generated.sh
#
# Output: JSON array with file and generated (text from @generated to // or end)

jq -r '[.[] |
  select(.captures != null) |
  .captures as $caps |
  select($caps | any(.name == "comment" and (.text | test("@generated")))) |
  {
    file: .file,
    comment: ($caps | map(select(.name == "comment")) | first | .text)
  }
] | unique_by(.file) | .[] |
select(.comment) |
.comment as $c |
($c | match("(@generated(?:(?!//).)*?)(?:\\s*//|\\s*$)")) as $m |
($m.captures[0].string | rtrimstr(" ")) as $generated |
{
  file: .file,
  generated: $generated
}' | jq -s '.'
