// Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash

const { execFileSync } = require("node:child_process");
const assert = require("assert");

describe("ast-tools-parse", function() {
  this.timeout(10000); // sql grammar on the large chinook sample takes ~2s
  // To update this list, check the dependencies in `package.json` for packages named `tree-sitter-*`.
  // For each grammar, find a suitable sample file in the `_samples/spikes` directory.
  const validSamples = [
    { grammar: "bash", file: "_samples/spikes/bash/tee-example2.sh" },
    { grammar: "c-sharp", file: "_samples/spikes/csharp/AssemblyInfo.cs" },
    { grammar: "css", file: "_samples/spikes/css/imports.css" },
    { grammar: "gitattributes", file: "_samples/.gitattributes" },
    { grammar: "groovy", file: "_samples/spikes/gradle/java-single-prop.gradle" },
    { grammar: "html", file: "_samples/spikes/html/mix-inline-script.htm" },
    { grammar: "java", file: "_samples/spikes/java/Infer.java" },
    { grammar: "plsql", file: "_samples/spikes/sql/chinook-mysql.sql" },
    { grammar: "python", file: "_samples/spikes/call_commands-for-python-536/multiple_calls.py" },
    { grammar: "sql", file: "_samples/spikes/sql/chinook-mysql.sql" },
    { grammar: "toml", file: "_samples/spikes/python-pip-tools-project518/pyproject.toml" },
    { grammar: "typescript/tsx", file: "_samples/spikes/test.tsx" },
    { grammar: "typescript/typescript", file: "_samples/spikes/TypeScriptSamples/angular1/app/app.ts" }
  ];

  validSamples.forEach(({ grammar, file }) => {
    it(`should produce valid XML for: ${file} with grammar ${grammar}`, function() {
        execFileSync('xmlstarlet', ['val', '-'], {
          input: execFileSync("ast-tools-parse", [grammar], {
            input:file+"\n",
            maxBuffer: 1024 * 1024 * 10, // 10 MB
            stdio: ['pipe', 'pipe', 'ignore']
          })
        });
    });
  });

});
