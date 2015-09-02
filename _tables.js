var tableFunctions = {
  insertToDoc: insertToDoc
};

define(function(tables){ return tableFunctions; });

function insertToDoc(data) {
  var table = document.createElement("table");
  table = insertTableClass(table, data.tableClass);
  table = insertTableCaption(table, data.caption);
  table = insertTableHeader(table, data.header);
  table = insertTableData(table, data.tableData);
  insertTableToDocument(table, data);
}

function insertTableHeader(table, header){
  var headerRow = table.insertRow(0);
  headerRow.insertCell(0);
  for (var headerNum in header){
    var colName = header[headerNum];
    var th = createTableHeaderTag(colName);
    headerRow.appendChild(th);
  }
  return table;
}

function insertTableClass(table, tableClass){
  if (tableClass) {
    table.className = tableClass;
  }
  return table;
}

function insertTableCaption(table, caption){
  if (caption) {
    var captionTag = createCaptionTag(caption);
    table.appendChild(captionTag);
  }
  return table;
}

function insertTableData(table, data){
  var keys = Object.keys(tableData);
  for (var rowName in tableData) {
    var row = table.insertRow(-1);
    var th = createTableHeaderTag(rowName);
    row.appendChild(th);

    for (var colNum in tableData[rowName]){
      var td = createTableDataTag(tableData[rowName][colNum]);
      row.appendChild(td);
    }
  };
  return table;
}

function insertTableToDocument(table, options){
  var insertId = options.id || "additional";
  document.getElementById(insertId).insertAdjacentElement('beforeEnd', table);
}

function createTableHeaderTag(content){
  var th = document.createElement('th');
  th.innerHTML = content;
  return th;
}

function createTableDataTag(content){
  var td = document.createElement('td');
  td.innerHTML = content;
  return td;
}
