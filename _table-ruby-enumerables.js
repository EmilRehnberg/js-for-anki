require(["_tables"], function(tables){
  var data = {
    header: ["method", "alias", "inverse"],
    tableClass: "small",
    caption:"Ruby enumerables",
  };

  var tableData = {
    filter: ["find_all", "select", "reject"],
    match: ["find", "detect", ""],
    map: ["map", "collect", ""],
    reduce: ["reduce", "inject", ""],
  };

  data.tableData = tables.wrapMapContentsInCodeTag(tableData);
  tables.writeAdjacentTable(data);
});
