#!/bin/bash
# Generated/modified by AI RooCode 3.36.0, used model google/claude-sonnet-4-6
#
# Find all Java top-level type declarations with their block comments (if any)
#
# Usage (pipe in ast-tools-query output):
#   query-files2 | jsontool -c 'this.ext == ".java"' -a file | prefix "$CINDY_REPO/" | \
#     ast-tools-query java -f java-type-block-comment.scm --matches --format json | \
#     java-type-block-comment.sh
#
# Output: JSON with file and all types with/without comments

jq -c '
  def declType:
    if . | index("class") then "class_declaration"
    else if . | index("interface") then "interface_declaration"
    else if . | index("enum") then "enum_declaration"
    else if . | index("record") then "record_declaration"
    else if . | index("annotation") then "annotation_type_declaration"
    else "unknown_declaration"
    end end end end end;
  group_by(.file) | .[] | 
  . as $fileGroup | 
  (map({
    captureCount: .captureCount,
    captureName: (.captures | map(.name) | map(select(. != "comment")) | map(split(".")[0]) | first),
    comment: ((.captures | map(select(.name == "comment")) | first) // null | if . then .text else null end),
    modifiers: (.captures | map(select(.name | contains(".modifiers"))) | map(.text)),
    name: (.captures | map(select(.name | contains(".name"))) | first).text, 
    startByte: (.captures | map(select(.name | contains(".name"))) | first).startByte
  })) as $types |
  {
    file: (.[0].file),
    types: [$types | sort_by(.comment == null) | .[] | {declaration: (.captureName | declType), name: .name, modifiers: .modifiers, comment: .comment, startByte: .startByte}] | unique_by(.name) | sort_by(.startByte) | map(del(.startByte))
  }
'