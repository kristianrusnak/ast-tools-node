# gitlab-check-file-presence-render-md.jq
# Render gitlab-check-file-presence JSON output as a Markdown table.
#
# Usage: jq -rf .roo/skills/search-repos/gitlab-check-file-presence-render-md.jq /tmp/all.json
#
# Outputs a single string (joined with newlines) so the agent can paste it directly.
# Columns are derived dynamically from the first row's paths keys.
# Rows with at least one match (found_main or found_some) are sorted first.
#
# Generated/modified by AI RooCode 3.53.0, used model google/claude-sonnet-4-6

def render_state:
  .state as $s | .branch as $b |
  if $s == "found_main" then "🟢 Yes (" + $b + ")"
  elif $s == "found_some" then "🟡 Yes (" + $b + ")"
  else "○ No" end;

(.[0].paths | keys_unsorted) as $cols |

[
  "| Server | Repository | " + ($cols | join(" | ")) + " |",
  "|---|---|" + ($cols | map(":---:") | join("|")) + "|"
] +
(
  sort_by(.paths | to_entries | map(select(.value.state | startswith("found"))) | length | . * -1)
  | map(
      . as $row |
      "| " + $row.server + " | " + $row.project_path + " | " +
      ([$cols[] | $row.paths[.] | render_state] | join(" | ")) + " |"
    )
) |
join("\n")
