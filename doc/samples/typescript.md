<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — TypeScript examples

**Grammar name:** use `typescript/typescript` (or `typescript/tsx` for `.tsx` files); a bare
`typescript` fails to load.

## Statistics on first node types

**Goal:** Count the type of the first top-level AST node in each TypeScript file.

```bash
git ls-files -- '*.ts' | ast-tools-query typescript/typescript -q '(program (_) @element)' | jq '[.[] | select(.captureCount > 0) | .captures[0].type] | group_by(.) | map({type: .[0], count: length}) | sort_by(-.count)'
```

**Output (snippet):**
```json
[
  { "type": "comment", "count": 16 },
  { "type": "expression_statement", "count": 12 },
  { "type": "export_statement", "count": 2 }
]
```

## Statistics on last node types

Same command with `.captures[-1].type` instead of `.captures[0].type`.
