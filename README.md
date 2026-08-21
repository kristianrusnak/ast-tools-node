---
ai_marking: "Generated/modified by AI Kilo Code 7.4.17-gratex-009, used model qwen3.8-27b"
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
"@ainthek/ast-tools-node": "git+https://github.com/ainthek/ast-tools-node.git#v1.0.0"
```

Its five `bin` entries are linked into the host's `node_modules/.bin`, exposing the
`ast-tools-*` commands on `PATH`. For one-off use, `npx git+https://github.com/ainthek/ast-tools-node.git ast-tools-parse <…>` also works.

_Generated/modified by AI Kilo Code 7.4.17-gratex-009, used model qwen3.8-27b_
