// Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3.

const { execFileSync } = require("node:child_process");
const assert = require("node:assert");
const fs = require("node:fs");
const path = require("node:path");

const queriesDir = path.join(__dirname, "..", "..", "queries");

function run(args, options = {}) {
  return execFileSync("ast-tools-queries", args, {
    maxBuffer: 1024 * 1024 * 10,
    ...options,
  }).toString();
}

describe("ast-tools-queries", function () {
  it("list — prints all bundled .scm query names, one per line", function () {
    const output = run(["list"]);
    const lines = output.trim().split("\n");
    assert.ok(lines.length > 0, "Expected at least one query file");
    lines.forEach(line => assert.ok(line.endsWith(".scm"), `Expected .scm name, got: ${line}`));
    for (const f of ["bash-commands.scm", "java-definitions.scm", "python-decorators.scm"]) {
      assert.ok(lines.includes(f), `Expected ${f} in list output`);
    }
  });

  it("list — matches the actual queries/ directory contents", function () {
    const expected = fs.readdirSync(queriesDir).filter(f => f.endsWith(".scm")).sort();
    const lines = run(["list"]).trim().split("\n");
    assert.deepStrictEqual(lines, expected);
  });

  it("list --language bash — only bash-prefixed queries", function () {
    const lines = run(["list", "--language", "bash"]).trim().split("\n");
    assert.ok(lines.length > 0, "Expected at least one bash query");
    lines.forEach(line => assert.ok(line.startsWith("bash-"), `Expected bash- prefix, got: ${line}`));
  });

  it("list --language java — only java-prefixed queries, no bash or javascript ones", function () {
    const lines = run(["list", "--language", "java"]).trim().split("\n");
    assert.ok(lines.length > 0, "Expected at least one java query");
    lines.forEach(line => assert.ok(line.startsWith("java-"), `Expected java- prefix, got: ${line}`));
    assert.ok(!lines.some(l => l.startsWith("bash-")), "Did not expect bash queries in java list");
    assert.ok(!lines.some(l => l.startsWith("javascript-")), "Did not expect javascript queries in java list");
  });

  it("list --language javascript — only javascript-prefixed queries", function () {
    const lines = run(["list", "--language", "javascript"]).trim().split("\n");
    assert.ok(lines.length > 0, "Expected at least one javascript query");
    lines.forEach(line => assert.ok(line.startsWith("javascript-"), `Expected javascript- prefix, got: ${line}`));
  });

  it("list --language with no matches — empty output, exit 0", function () {
    const output = run(["list", "--language", "nosuchgrammar"]);
    assert.strictEqual(output.trim(), "");
  });

  it("show NAME.scm — prints the exact query file content", function () {
    const output = run(["show", "bash-commands.scm"]);
    assert.strictEqual(output, fs.readFileSync(path.join(queriesDir, "bash-commands.scm"), "utf8"));
  });

  it("show NAME without extension — resolves NAME.scm", function () {
    const output = run(["show", "python-decorators"]);
    assert.strictEqual(output, fs.readFileSync(path.join(queriesDir, "python-decorators.scm"), "utf8"));
  });

  it("show NAME.sh — prints companion jq helper content", function () {
    const output = run(["show", "markdown-headings.sh"]);
    assert.strictEqual(output, fs.readFileSync(path.join(queriesDir, "markdown-headings.sh"), "utf8"));
  });

  it("show unknown NAME — exits non-zero and lists available queries", function () {
    assert.throws(
      () => execFileSync("ast-tools-queries", ["show", "no-such-query"], { stdio: ["pipe", "pipe", "pipe"] }),
      (err) => {
        const stderr = err.stderr.toString();
        assert.ok(stderr.includes("not found"), "Expected 'not found' in error");
        assert.ok(stderr.includes("bash-commands.scm"), "Expected available query list in error");
        return err.status !== 0;
      }
    );
  });

  it("show NAME with path traversal — rejected, stays inside queries/", function () {
    assert.throws(
      () => execFileSync("ast-tools-queries", ["show", "../package.json"], { stdio: ["pipe", "pipe", "pipe"] }),
      (err) => {
        const stderr = err.stderr.toString();
        assert.ok(stderr.includes("not found"), "Expected 'not found' in error");
        assert.ok(!err.stdout.toString().includes('"name"'), "Expected no package.json content in stdout");
        return err.status !== 0;
      }
    );
  });

  it("--help — prints usage with list and show commands", function () {
    let help;
    assert.throws(
      () => execFileSync("ast-tools-queries", ["--help"], { stdio: ["pipe", "pipe", "pipe"] }),
      (err) => {
        help = err.stdout.toString();
        return err.status !== 0;
      }
    );
    assert.ok(help.includes("ast-tools-queries list"), "Expected list command in help");
    assert.ok(help.includes("ast-tools-queries show"), "Expected show command in help");
    assert.ok(help.includes("Usage"), "Expected Usage section in help");
  });

  it("unknown command — exits non-zero with usage hint", function () {
    assert.throws(
      () => execFileSync("ast-tools-queries", ["explode"], { stdio: ["pipe", "pipe", "pipe"] }),
      (err) => {
        const stderr = err.stderr.toString();
        assert.ok(stderr.includes("Unknown command"), "Expected unknown command error");
        assert.ok(stderr.includes("--help"), "Expected --help hint");
        return err.status !== 0;
      }
    );
  });
});
