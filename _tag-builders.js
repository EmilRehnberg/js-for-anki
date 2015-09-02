
var moduleFunctions = {
  buildAnchor: buildAnchor,
  buildSpan: buildSpan,
  buildTable: buildTable,
  createCaptionTag: createCaptionTag,
  buildTableData: buildTableData,
  buildTableHeader: buildTableHeader,
  buildTableData: buildTableData,
  builder: builder
};

define(function(tags){ return moduleFunctions; });

function buildAnchor(content, url) {
  var anchor = builder("a", content)();
  anchor.href = url;
  return anchor;
}

function buildSpan(content){
  return builder("span", content)();
}

function buildTable(){
  return builder("table")();
}

function buildTableHeader(content){
  return builder("th", content)();
}

function buildTableData(content){
  return builder("td", content)();
}

function createCaptionTag(content){
  return builder("caption", content)();
}

function builder(tagName, content){
  return function(){
    var tag = document.createElement(tagName);
    if (content){ tag.innerHTML = content; }
    return tag;
  }
}
