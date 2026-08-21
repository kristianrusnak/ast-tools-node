module.exports = grammar({
  name: 'plsql',
  rules: {
    source_file: $ => repeat($.text_chunk),
    // Match any characters except newline, non-greedy
    text_chunk: $ => token(repeat1(/[^\n]+/)),
  }
});
