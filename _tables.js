define(["_tag-builders", "_dom-writers"], function(tagBuilders, writers){
  return { writeAdjacentTable: writeAdjacentTable };

  function writeAdjacentTable(data){
    var table = buildDataTable(data);
    writers.appendToFirstArticle(table);
  }

  function buildDataTable(data) {
    var table = tagBuilders.buildTable();
    insertTableClass(table, data.tableClass);
    insertTableCaption(table, data.caption);
    insertTableHeader(table, data.header);
    insertTableData(table, data.tableData);
    return table;
  }

  function insertTableClass(table, tableClass){
    if (tableClass) {
      table.className = tableClass;
    }
  }

  function insertTableCaption(table, caption){
    if (caption) {
      var captionTag = tagBuilders.createCaptionTag(caption);
      table.appendChild(captionTag);
    }
  }

  function insertTableHeader(table, header){
    var headerRow = table.insertRow(0);
    headerRow.insertCell(0);
    fillOutTableRow(headerRow, header, tagBuilders.buildTableHeader);
  }

  function insertTableData(table, tableData){
    var keys = Object.keys(tableData);
    for (var rowName in tableData) {
      var row = table.insertRow(-1);
      var th = tagBuilders.buildTableHeader(rowName);
      row.appendChild(th);
      var rowData = tableData[rowName];
      fillOutTableRow(row, rowData, tagBuilders.buildTableData);
    };
  }

  function fillOutTableRow(row, data, builder){
    for (var colNum in data){
      var cellData = data[colNum];
      var cell = builder(cellData);
      row.appendChild(cell);
    }
  }
});
