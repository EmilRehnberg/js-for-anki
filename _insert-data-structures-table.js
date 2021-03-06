require(["_tables"], function(tables){
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
    caption: "Data Stuctures",
    tableData: {
      Ruby: ["Array", "Hash", ""],
      JavaScript: ["array", "map", ""],
      R: ["vector", "list", ""],
      Python: ["list", "dict", "tuple"],
      CSS: ["list", "map", ""],
      SQL: ["", "", ""],
    }
  };

  Object.keys(adjacentCodeExamples).forEach(function(language){
    adjacentCodeExamples[language].forEach(function(example, codeExampleNum){
      var exampleTagString = ["<code>", example, "</code>"].join("");
      var structName = data["tableData"][language][codeExampleNum];
      data["tableData"][language][codeExampleNum] = [structName, exampleTagString].filter(Boolean).join(": ");
    });
  });

  tables.writeAdjacentTable(data);
});
