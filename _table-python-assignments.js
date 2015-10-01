require(["_tables"], function(tables){
  var data = {
    header: ["operator", "example"],
    tableClass: "small",
    caption:"python transform assignments",
  };

  var tableData = {
    add: ["+=", "x = 1; x += 2"],
    subtract: ["-=", "x = 1; x -= 2"],
    multiply: ["*=", "x = 1; x *= 2"],
    divide: ["/=", "x = 1; x /= 2"],
    floor: ["//=", "x = 1; x //= 2"],
    modulus: ["%=", "x = 1; x %= 2"],
    power: ["**", "x = 1; x **= 2"],
  };

  data.tableData = tables.wrapMapContentsInCodeTag(tableData);
  tables.writeAdjacentTable(data);
});
