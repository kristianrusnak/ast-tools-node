# npm / npx Log Reference

Source: https://docs.npmjs.com/cli/v11/using-npm/logging

## Log Location

```bash
# Custom log dir (returns "null" if not set)
npm config get logs-dir

# If "null", logs are in: $(npm config get cache)/_logs
```

- Default cache: `~/.npm` (Posix) / `%LocalAppData%\npm-cache` (Windows)
- Log files: `<ISO8601-timestamp>-debug-<N>.log` (colons → underscores)
- Retention: last `$(npm config get logs-max)` files (default: 10)
- `npx` uses the **same** log directory as `npm`

## ⚠️ Log Rotation Caveat

npm keeps only the last `logs-max` (default: 10) log files. Every `npm` or `npx`
invocation — including `npm config get` queries — consumes a slot. Failed installs
from earlier in the same session may already be rotated out.

**If the failure log is gone, use the VSCode Extension Host log instead.**
See [vscode-extension-host.md](vscode-extension-host.md).

## Finding Failed npx Installs

```bash
# Search npm logs for errors
grep -h "npm ERR\|error\|ENOENT\|code E" "$(npm config get cache)/_logs"/*.log 2>/dev/null

# If logs are rotated — search VSCode Extension Host logs instead (cross-platform)
# macOS:
grep -rh "npm error\|npm ERR" "$HOME/Library/Application Support/Code/logs" 2>/dev/null
# Linux:
grep -rh "npm error\|npm ERR" "${XDG_CONFIG_HOME:-$HOME/.config}/Code/logs" 2>/dev/null
# Windows (PowerShell):
# Get-ChildItem "$env:APPDATA\Code\logs" -Recurse | Select-String "npm error|npm ERR"
```

## Checking Node/npm Version Used by an npx Install

Every npm/npx log records the Node and npm versions at lines 2–3. Use these queries:

```bash
# Step 1: resolve log directory
npm config get cache        # e.g. /Users/you/.npm
npm config get logs-dir     # "null" → logs are in <cache>/_logs

# Step 2: list logs newest-first (find the relevant one)
ls -lt "$(npm config get cache)/_logs"/*.log 2>/dev/null | head -10

# Step 3: extract Node/npm version + command from a specific log
grep -h "verbose title\|verbose cli\|info using node\|info using npm" \
  "$(npm config get cache)/_logs/2026-04-20T16_55_27_215Z-debug-0.log"

# Step 4: scan ALL available logs for the command that ran (e.g. npx exec / npm install)
grep -h "verbose title\|verbose cli\|info using node\|info using npm" \
  "$(npm config get cache)/_logs"/*.log | sort -u
```

### What to look for in the log

```
0 verbose cli /path/to/node /path/to/npm-cli.js
1 info using npm@11.9.0
2 info using node@v24.10.0
7 verbose title npm exec git+ssh://...   ← the actual command
```

Line `2 info using node@vX.Y.Z` is the authoritative Node version for that invocation.

### ⚠️ Caveat: `npm config get` queries consume log slots

Running `npm config get cache`, `npm config get logs-dir`, etc. each write their own
log file and push older logs out of the rotation window (`logs-max` default: 10).
Run all config queries **first**, then read the remaining logs — or read logs before
running any npm commands.
