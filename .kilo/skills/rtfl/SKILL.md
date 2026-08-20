---
name: rtfl
description: Read The F***ing Log — when the user asks to look at, debug, investigate, or understand logs from any tool, use this skill to locate the right log file before doing anything else.
---

<!-- Generated/modified by AI RooCode 3.52.1, used model google/claude-sonnet-4-6 -->

# RTFL: Read The F***ing Log

**Rule:** Before guessing at anything, find and read the actual log.

## Supported Log Sources

| Tool / Context | Reference |
|----------------|-----------|
| `npm` / `npx` | [logs/npm-npx.md](logs/npm-npx.md) |
| VSCode Extension Host (MCP servers, extensions) | [logs/vscode-extension-host.md](logs/vscode-extension-host.md) |

## Workflow

1. Identify the tool or context from the user's request.
2. Load the matching reference file from the table above to find the log location.
3. Resolve the log path at runtime (run the commands from the reference — never hardcode paths).
4. Read the log — extract the relevant section for the user's question (errors, warnings, activity, timing, or whatever they need).
5. Report findings with exact log lines and context.

If the tool is not in the table, discover the log location dynamically:
- Check `--help` output for log flags
- Check the tool's config file for `logfile` / `log-dir` keys
- Check `$XDG_DATA_HOME`, `$TMPDIR`, `/var/log/` as fallbacks
