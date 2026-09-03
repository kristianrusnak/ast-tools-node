#!/usr/bin/env bash
# Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash.
#
# _ast_tools.sh — shared runtime helpers for the ast-tools-node CLI scripts.
# Lives in bin/lib/.
#
# Provides the PATH bootstrap that lets any CLI script resolve its sibling tools
# (ast-tools-parse, ast-checksum, awk-uniq, ...) by bare name, no matter which
# subdirectory they live in. Add more shared helpers here instead of duplicating
# them across bin/* scripts.
#
# Layout:
#   bin/lib/            shared helpers (this file, awk-uniq)
#   bin/ast/            tree-sitter AST tools (ast-tools-*, ast-checksum)
#
# USAGE — paste this ONE line near the top of any bin/* shell script (after the
# shebang and argument parsing). It resolves the script's real directory even when
# the script is reached through a node_modules/.bin symlink, then sources this
# library so the sibling tool directories land on PATH:
#
#   # shellcheck source=/dev/null
#   . "$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || printf '%s' "${BASH_SOURCE[0]}")")" && pwd -P)/../lib/_ast_tools.sh"
#
# The bootstrap is idempotent: sourcing it repeatedly is a no-op.
# Note: `readlink -f` (GNU) is used; on systems without it (old macOS) the fallback
# still works for direct invocation but not for node_modules/.bin symlink lookups.

# Prepend this package's tool directories (bin/lib and bin/ast) to PATH if they
# are not already present. Sibling CLIs are then resolvable by bare name no matter
# how the current script was invoked (direct path, PATH lookup, or an npm
# node_modules/.bin symlink).
_ast_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P 2>/dev/null)"
_ast_bin_dir="$(dirname "$_ast_lib_dir")"
for _ast_dir in "$_ast_lib_dir" "$_ast_bin_dir/ast"; do
  case ":${PATH:-}:" in
    *":$_ast_dir:"*) : ;;
    *) export PATH="$_ast_dir${PATH:+:$PATH}" ;;
  esac
done
unset _ast_lib_dir _ast_bin_dir _ast_dir
