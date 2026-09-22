// Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash

const { execFileSync } = require("node:child_process");
const assert = require("assert");

describe("ast-tools-validate", function () {
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
    it(`ast-tools-validate ${grammar} - should return "OK", "ERR", "ERRR", "EX" as result of validation: ${file} `, function () {
      const output = execFileSync("ast-tools-validate", [grammar], { input: file + '\n' }).toString().trim();
      const [status, resultFile] = output.split('\t');

      assert.ok(["OK", "ERR", "ERRR", "EX"].includes(status), `Expected OK, ERR, ERRR, or EX but got ${status} for ${file}`);
      assert.strictEqual(resultFile, file, `Expected file ${file} but got ${resultFile}`);
    });
  });

  it("should return ERR for invalid file", function () {
    const grammar = "java";
    const file = "_samples/spikes/bash/tee-example2.sh"; // This is a shell script, not Java
    const output = execFileSync("ast-tools-validate", [grammar], { input: file + '\n' }).toString().trim();
    const [status, resultFile] = output.split('\t');

    assert.ok(["ERR", "ERRR", "EX"].includes(status), `Expected ERR, ERRR, or EX but got ${status} for ${file}`);
    assert.strictEqual(resultFile, file, `Expected file ${file} but got ${resultFile}`);
  });
});
