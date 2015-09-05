var adjacentCodeExamples = {
  Ruby: ["[1, 2]", "{a: 1}", "[1, 2].freeze"],
  JavaScript: ["[1, 2]", "{a: 1}", ""],
  R: ["c(1, 2)", "list(a=1)", ""],
  Python: ["[1, 2]", "{'a': 1}", "(1, 2)"],
  CSS: ["(1, 2)", "(a: 1)", ""],
  SQL: ["(1, 2)", "", ""],
};

var data = {
  header: ["list", "mapping", "imm list"],
  tableClass: "small",
  tableData: {
    Ruby: ["Array", "Hash", ""],
    JavaScript: ["array", "map", ""],
    R: ["vector", "list", ""],
    Python: ["list", "dict", "tuple"],
    CSS: ["list", "map", ""],
    SQL: ["", "", ""],
  }
};

for (language in adjacentCodeExamples) {
  for (codeExampleNum in adjacentCodeExamples[language]) {
    var example = adjacentCodeExamples[language][codeExampleNum];
    var exampleTagString = ["<code>", example, "</code>"].join("");
    var structName = data["tableData"][language][codeExampleNum];
    data["tableData"][language][codeExampleNum] = [structName, exampleTagString].filter(Boolean).join(": ");
  }
};

require(["_tables"], function(tables){
  tables.writeTable(data);
});
