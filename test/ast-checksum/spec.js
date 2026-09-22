// Generated/modified by AI Kilo Code 7.4.22-gratex-016, used model deepseek-v4-flash

const { execFileSync } = require("node:child_process");
const assert = require("assert");

const SAMPLE_WITH_COMMENTS = "_samples/spikes/java/ClassicDocument.java";
const SAMPLE_WITHOUT_COMMENTS = "_samples/spikes/java/Infer.java";

const HEX_SHA1 = /^[0-9a-f]{40}$/;

function runChecksum(args) {
  return execFileSync("ast-checksum", args, {
    encoding: "utf8",
    maxBuffer: 1024 * 1024 * 10,
    stdio: ["pipe", "pipe", "ignore"]
  }).trim();
}

function parseChecksums(output) {
  const fields = output.split(":");
  assert.strictEqual(fields.length, 4, `expected 4 colon-separated fields, got: ${output}`);
  assert.match(fields[1], HEX_SHA1, `checksum not sha1 hex: ${fields[1]}`);
  assert.match(fields[2], HEX_SHA1, `checksum_no_comment not sha1 hex: ${fields[2]}`);
  assert.match(fields[3], HEX_SHA1, `checksum_no_comment_unique not sha1 hex: ${fields[3]}`);
  return { file: fields[0], checksum: fields[1], checksumNoComment: fields[2], checksumUnique: fields[3] };
}

describe("ast-checksum", function() {
  it("prints usage and exits non-zero with -h", function() {
    assert.throws(() => execFileSync("ast-checksum", ["-h"], { encoding: "utf8" }), (err) => {
      assert.strictEqual(err.status, 1);
      assert.ok(err.stdout.includes("Calculates checksum from ast structure"), err.stdout);
      return true;
    });
  });

  it("prints usage and exits non-zero without arguments", function() {
    assert.throws(() => execFileSync("ast-checksum", [], { encoding: "utf8" }), (err) => {
      assert.strictEqual(err.status, 1);
      assert.ok(err.stdout.includes("Usage:"), err.stdout);
      return true;
    });
  });

  it("outputs 4 colon-separated fields with sha1 hex values", function() {
    const out = parseChecksums(runChecksum(["java", SAMPLE_WITHOUT_COMMENTS]));
    assert.strictEqual(out.file, SAMPLE_WITHOUT_COMMENTS);
  });

  it("is deterministic for the same file", function() {
    const a = runChecksum(["java", SAMPLE_WITHOUT_COMMENTS]);
    const b = runChecksum(["java", SAMPLE_WITHOUT_COMMENTS]);
    assert.strictEqual(a, b);
  });

  it("filters comments out of the checksum for files with comments", function() {
    const out = parseChecksums(runChecksum(["java", SAMPLE_WITH_COMMENTS]));
    assert.notStrictEqual(out.checksum, out.checksumNoComment);
  });

  it("keeps checksum equal to no-comment checksum for comment-free files", function() {
    const out = parseChecksums(runChecksum(["java", SAMPLE_WITHOUT_COMMENTS]));
    assert.strictEqual(out.checksum, out.checksumNoComment);
  });

  it("supports LEVEL filtering of the ast element path", function() {
    const full = runChecksum(["java", SAMPLE_WITHOUT_COMMENTS]);
    const filtered = parseChecksums(runChecksum(["java", SAMPLE_WITHOUT_COMMENTS, "1,2"]));
    assert.notStrictEqual(filtered.checksum, full.split(":")[1]);
  });

  it("produces the same checksum when stdin is a TTY", function() {
    const nonTtyChecksum = runChecksum(["java", SAMPLE_WITHOUT_COMMENTS]).split(":")[1];
    const cmd = `ast-checksum java "${SAMPLE_WITHOUT_COMMENTS}"`;
    let ttyOutput;
    try {
      // util-linux `script` runs the command under a pseudo-terminal,
      // so ast-tools-parse would see stdin as a TTY and print help instead of parsing.
      ttyOutput = execFileSync("script", ["-qec", cmd, "/dev/null"], {
        encoding: "utf8",
        maxBuffer: 1024 * 1024
      });
    } catch (err) {
      if (err.code === "ENOENT") {
        this.skip(); // `script` (util-linux) not available
        return;
      }
      throw err;
    }
    const fields = ttyOutput.replace(/\r/g, "").trim().split(":");
    assert.strictEqual(fields.length, 4, `tty output malformed: ${JSON.stringify(ttyOutput)}`);
    assert.strictEqual(fields[1], nonTtyChecksum, "checksum changed when stdin is a TTY (ast-tools-parse printed help?)");
  });
});
