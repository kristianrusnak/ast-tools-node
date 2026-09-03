---
ai_marking: "Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash"
---

# @ainthek/ast-tools-node

Stand-alone Node.js tree-sitter tooling: parse, dump, query, and validate source files as
ASTs. Extracted from the cinderella monorepo (`tools/external/ast-tools`) so the Node engine
can be reused independently of cinderella.

## Contents

| CLI | Purpose |
| --- | --- |
| `ast-tools-parse <grammar> <file>` | Parse a file (or files from stdin) to an XML AST wrapped in `<ast-cache>`. |
| `ast-tools-parse-stdin <grammar>` | Parse an ad-hoc snippet from stdin (single grammar). |
| `ast-tools-dump <grammar> <file>` | Print a file's tree-sitter AST as plain text (`tree.rootNode.toString()`). |
| `ast-tools-query <grammar> [-q \| -f] [--matches] [--format json\|text\|xml]` | Run a tree-sitter query against files from stdin; emit captures. |
| `ast-tools-validate <grammar> [<file>]` | Report `OK`/`ERR`/`ERRR`/`EX` per file (syntax-error check with a 1s timeout). |
| `ast-checksum <grammar> <file> [level]` | Hash a file's AST into three checksum columns: full tree / comment-filtered / comment-filtered + line-unique. |

The bundled CLIs resolve their sibling `bin/` helpers automatically (each wrapper
self-locates its directory and prepends the tool directories to `PATH`), so no manual
PATH setup is needed on the consuming host after `npm install`. The source layout is
hierarchical — `bin/ast/` holds the tree-sitter CLIs (`ast-tools-*`, `ast-checksum`) and
`bin/lib/` holds shared helpers (`_ast_tools.sh`, `awk-uniq`) — but all seven `bin`
entries still install into the host's single `node_modules/.bin`. The PATH bootstrap
logic lives once in `bin/lib/_ast_tools.sh`; every shell CLI sources it with a one-liner
at the top (see the usage comment in that file), so future tools inherit it without
rewriting it.

## Queries

`ast-tools-query` resolves a bare query name (`-f python-decorators.scm`) against the bundled
`queries/` directory (next to `bin/`). Absolute and `./`/`../` paths are used as-is. The
bundled `.scm` set is copied from cinderella's `tools/external/ast-tools/queries/*.scm`.

## Dependencies

The standard tree-sitter grammars (bash, c-sharp, css, gitattributes, groovy, html, java,
javascript, markdown, python, sql, toml, typescript) plus `tree-sitter` and `xml-escape` are
declared in `package.json` and install with the package — so the package is self-contained
for those grammars.

**`plsql` is bundled.** The `tree-sitter-plsql` grammar is vendored in this repo at
`tree-sitter-plsql/` and wired in via `file:./tree-sitter-plsql`, so `ast-tools-parse plsql`
works out of the box. Its native binding is compiled at `npm install` via `node-gyp-build`
(the `build/` output is git-ignored, like the other generated artifacts).

## Installing

Intended distribution is a private `git+https` source (no public npm publish). Consume it
from a host package.json, pinning a tag:

```json
"@ainthek/ast-tools-node": "git+https://github.com/kristianrusnak/ast-tools-node.git#v1.1.3"
```

Its seven `bin` entries (the five `ast-tools-*` CLIs, plus `ast-checksum` and the `awk-uniq` helper) are linked into the host's `node_modules/.bin`, putting all of them on `PATH`. For one-off use, `npx git+https://github.com/kristianrusnak/ast-tools-node.git ast-tools-parse <…>` also works.

_Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash_
