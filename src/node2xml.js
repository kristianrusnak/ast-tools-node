const e = require('xml-escape');

function serialize(n, write, file, hasError) {
  if (n.isNamed) {
    write("<" + e(n.type) + (file ? ' file="' + e(file) + '"' : "") + (hasError ? ' hasError="' + e(`${hasError}`) + '"' : "") +">")
    //if(!n.namedChildCount){
    if (!n.childCount) {
      write(e(n.text));
    }
    n.children.forEach((n) => serialize(n, write));
    write("</" + e(n.type) + ">")
  } else {
    write(e(n.text))
    n.children.forEach((n) => serialize(n, write));
  }
}
module.exports = {
  node2xml: serialize
}