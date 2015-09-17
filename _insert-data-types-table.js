require(["_tables"], function(tables){
  var data = {
    header: ["1", "1.0", "a", "true"],
    tableClass: "small",
    caption:"Data Types",
    tableData: {
      Ruby: ["Integer", "Float", "String", "TrueClass"],
      JavaScript: ["number", "number", "string", "boolean"],
      R: ["integer", "double", "character", "logical"],
      Python: ["int", "float", "str", "true"],
      Go: ["int", "float64", "string", "bool"],
      CSS: ["integer", "number", "string", "boolean"],
      SQL: ["INTEGER(p)", "FLOAT(p)", "CHARACTER", "BOOLEAN"],
  }
};

tables.writeAdjacentTable(data);
});
