// Generated/modified by AI RooCode 3.36.0, used model google/gemini-2.5-pro
// Based on QUnit's assert.propContains() - https://qunitjs.com/api/assert/propContains/
const { execFileSync } = require("node:child_process");
const assert = require("node:assert");

const QUERY_FILE = "java-type-block-comment.scm";
const SCRIPTS_PATH = "queries";

function assertContains(actual, expected) {
  for (const key in expected) {
    if (!(key in actual)) throw new Error(`Missing key: ${key}`);
    if (typeof expected[key] === 'object' && expected[key] !== null) {
      assertContains(actual[key], expected[key]);
    } else if (actual[key] !== expected[key]) {
      throw new Error(`Value mismatch for ${key}: expected ${expected[key]}, got ${actual[key]}`);
    }
  }
}

function runFullPipeline(filePath, script) {
  const input = filePath + "\n";
  const result = execFileSync("ast-tools-query", ["java", "-f", QUERY_FILE, "--matches", "--format", "json"], {
    input: input,
    maxBuffer: 1024 * 1024 * 10,
    stdio: ['pipe', 'pipe', 'ignore']
  });

  const scriptPath = SCRIPTS_PATH + "/" + script;
  const processed = execFileSync(scriptPath, {
    input: result.toString(),
    maxBuffer: 1024 * 1024 * 10,
    stdio: ['pipe', 'pipe', 'ignore']
  });

  return processed.toString().trim().split('\n').filter(l => l.length > 0).map(l => JSON.parse(l));
}

describe("ast-tools-query java type block comments", function() {
  it("SimpleClass.java - class with comment", function() {
    const filePath = "test/ast-tools-query/fixtures/SimpleClass.java";
    const results = runFullPipeline(filePath, "java-type-block-comment.sh");
    
    const expected = {
      file: "test/ast-tools-query/fixtures/SimpleClass.java",
      types: [
        {
          comment: "/**\n * Simple class comment.\n */",
          declaration: "class_declaration",
          name: "SimpleClass"
        }
      ]
    };
    assertContains(results[0], expected);
  });
  it("SimpleClass.java - class with comment, modifiers are now supported", function() {
    const filePath = "test/ast-tools-query/fixtures/SimpleClass.java";
    const results = runFullPipeline(filePath, "java-type-block-comment.sh");
    
    const expected = {
      file: "test/ast-tools-query/fixtures/SimpleClass.java",
      types: [
        {
          comment: "/**\n * Simple class comment.\n */",
          declaration: "class_declaration",
          name: "SimpleClass",
          modifiers: ["public"]
        }
      ]
    };
    assertContains(results[0], expected);
  });
  
  it("ComplexTypes.java - all top-level types with/without comments", function() {
    const filePath = "test/ast-tools-query/fixtures/ComplexTypes.java";
    const results = runFullPipeline(filePath, "java-type-block-comment.sh");
    
    const expected = JSON.parse(require("node:fs").readFileSync("test/ast-tools-query/fixtures/ComplexTypes.java.expected.json", "utf8"));
    assertContains(results[0], expected);
  });
});
