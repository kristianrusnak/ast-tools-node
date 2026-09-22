#!/usr/bin/env bats
# Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash
# model google/gemini-2.5-pro failed to rewrite spec.js to bats.

# Repo root derived from the test file location (test/ast-tools-parse/spec.bats -> ../..)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

@test "ast-tools-parse should be an executable on the PATH" {
  type ast-tools-parse
}

@test "\$REPO_ROOT should be directory" {
  [ -d "$REPO_ROOT" ]
}

@test "should produce valid XML for: _samples/spikes/bash/tee-example2.sh with grammar bash" {
  ast-tools-parse bash <<< "$REPO_ROOT/_samples/spikes/bash/tee-example2.sh" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/csharp/AssemblyInfo.cs with grammar c-sharp" {
  ast-tools-parse c-sharp <<< "$REPO_ROOT/_samples/spikes/csharp/AssemblyInfo.cs" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/css/imports.css with grammar css" {
  ast-tools-parse css <<< "$REPO_ROOT/_samples/spikes/css/imports.css" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/.gitattributes with grammar gitattributes" {
  ast-tools-parse gitattributes <<< "$REPO_ROOT/_samples/.gitattributes" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/gradle/java-single-prop.gradle with grammar groovy" {
  ast-tools-parse groovy <<< "$REPO_ROOT/_samples/spikes/gradle/java-single-prop.gradle" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/html/mix-inline-script.htm with grammar html" {
  ast-tools-parse html <<< "$REPO_ROOT/_samples/spikes/html/mix-inline-script.htm" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/java/Infer.java with grammar java" {
  ast-tools-parse java <<< "$REPO_ROOT/_samples/spikes/java/Infer.java" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/sql/chinook-mysql.sql with grammar plsql" {
  ast-tools-parse plsql <<< "$REPO_ROOT/_samples/spikes/sql/chinook-mysql.sql" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/call_commands-for-python-536/multiple_calls.py with grammar python" {
  ast-tools-parse python <<< "$REPO_ROOT/_samples/spikes/call_commands-for-python-536/multiple_calls.py" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/sql/chinook-mysql.sql with grammar sql" {
  ast-tools-parse sql <<< "$REPO_ROOT/_samples/spikes/sql/chinook-mysql.sql" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/python-pip-tools-project518/pyproject.toml with grammar toml" {
  ast-tools-parse toml <<< "$REPO_ROOT/_samples/spikes/python-pip-tools-project518/pyproject.toml" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/test.tsx with grammar typescript/tsx" {
  ast-tools-parse typescript/tsx <<< "$REPO_ROOT/_samples/spikes/test.tsx" |\
  xmlstarlet val -
}

@test "should produce valid XML for: _samples/spikes/TypeScriptSamples/angular1/app/app.ts with grammar typescript/typescript" {
  ast-tools-parse typescript/typescript <<< "$REPO_ROOT/_samples/spikes/TypeScriptSamples/angular1/app/app.ts" |\
  xmlstarlet val -
}
