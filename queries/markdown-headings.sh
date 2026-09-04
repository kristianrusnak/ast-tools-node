#!/bin/bash
# Generated/modified by AI RooCode 3.51.1, used model google/claude-sonnet-4-6
#
# Find all markdown headings with their levels
#
# Usage (pipe in ast-tools-query output):
#   query-files2 | jsontool -c 'this.ext == ".md"' -a file | prefix "$CINDY_REPO/" | \
#     ast-tools-query markdown -f markdown-headings.scm --matches --format json | \
#     markdown-headings.sh
#
# Output: JSON with file and array of headings with level and text

jq -c '
  def headingLevel:
    if .markerType == "atx_h1_marker" then 1
    else if .markerType == "atx_h2_marker" then 2
    else if .markerType == "atx_h3_marker" then 3
    else if .markerType == "atx_h4_marker" then 4
    else if .markerType == "atx_h5_marker" then 5
    else if .markerType == "atx_h6_marker" then 6
    else if .markerType == "setext_h1_underline" then 1
    else if .markerType == "setext_h2_underline" then 2
    else 0
    end end end end end end end end;
  group_by(.file) | .[] | 
  . as $fileGroup | 
  [.[] | {file: .file, markerType: ((.captures | map(select(.name == "heading.marker")) | first).type), text: ((.captures | map(select(.name == "heading.content")) | first).text), startByte: ((.captures | map(select(.name == "heading.content")) | first).startByte)}] as $rawHeadings |
  {
    file: ($rawHeadings | first).file,
    headings: [($rawHeadings | sort_by(.startByte) | .[]) | {level: headingLevel, text: .text}]
  }
'