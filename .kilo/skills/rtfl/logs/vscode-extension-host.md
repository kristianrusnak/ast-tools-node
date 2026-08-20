# VSCode Extension Host Log Reference

<!-- Generated/modified by AI RooCode 3.52.1, used model google/claude-sonnet-4-6 -->

## Log Location

The VSCode log directory is OS-specific. Resolve it at runtime:

```bash
# macOS
VSCODE_LOGS="$HOME/Library/Application Support/Code/logs"

# Linux
VSCODE_LOGS="${XDG_CONFIG_HOME:-$HOME/.config}/Code/logs"

# Windows (PowerShell)
# $env:APPDATA\Code\logs
```

- Each VSCode launch creates a timestamped session subdirectory (e.g. `20260420T140128`)
- Extension Host errors are written inside the session directory
- **Not rotated like npm logs** — persists across npm log rotation

## When to Use Instead of npm Logs

npm debug logs (`~/.npm/_logs/`) are rotated (default: last 10 files).
Any `npm`/`npx` invocation — including `npm config get` queries — consumes a slot.
If the failure logs are gone, use the VSCode Extension Host log instead.

| Scenario | Use |
|----------|-----|
| Recent npm/npx failure (last 10 ops) | `~/.npm/_logs/*.log` |
| MCP server npx failure (any time today) | VSCode Extension Host log |
| npm logs rotated away | VSCode Extension Host log |

## Finding Failed npx / MCP Installs

```bash
# macOS / Linux — all npm errors across all today's VSCode sessions
grep -rh "npm error\|npm ERR" "$VSCODE_LOGS" 2>/dev/null

# Filter to MCP server connection failures only
grep -rh "Failed to connect\|Failed to reconnect\|could not determine executable" \
  "$VSCODE_LOGS" 2>/dev/null

# Windows (PowerShell)
Get-ChildItem "$env:APPDATA\Code\logs" -Recurse -Filter "*.log" |
  Select-String "npm error|npm ERR|could not determine executable"
```

Example output for a failed `@playwright/mcp` npx install:
```
[error] Server "playwright" stderr: npm error could not determine executable to run
[error] Failed to connect to new MCP server playwright: McpError: MCP error -32000: Connection closed
```
