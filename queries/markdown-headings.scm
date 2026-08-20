; Generated/modified by AI RooCode 3.51.1, used model google/claude-sonnet-4-6
;
; Markdown Tree-sitter Query Patterns
; Select all headings (both ATX and Setext)

; ATX Headings (# to ######)
(atx_heading
  (atx_h1_marker) @heading.marker
  (inline) @heading.content) @heading.atx

(atx_heading
  (atx_h2_marker) @heading.marker
  (inline) @heading.content) @heading.atx

(atx_heading
  (atx_h3_marker) @heading.marker
  (inline) @heading.content) @heading.atx

(atx_heading
  (atx_h4_marker) @heading.marker
  (inline) @heading.content) @heading.atx

(atx_heading
  (atx_h5_marker) @heading.marker
  (inline) @heading.content) @heading.atx

(atx_heading
  (atx_h6_marker) @heading.marker
  (inline) @heading.content) @heading.atx

; Setext Headings (= for h1, - for h2)
(setext_heading
  (paragraph (inline) @heading.content)
  (setext_h1_underline) @heading.marker) @heading.setext

(setext_heading
  (paragraph (inline) @heading.content)
  (setext_h2_underline) @heading.marker) @heading.setext