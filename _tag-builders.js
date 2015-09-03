
var moduleFunctions = {
  buildAnchor: buildAnchor,
  buildDfn: buildDfn,
  buildJaDfnTag: buildJaDfnTag,
  buildReadingDfnTag: buildReadingDfnTag,
  buildNameDfnTag: buildNameDfnTag,
  buildEnDfnTag: buildEnDfnTag,
  buildSpan: buildSpan,
  buildTable: buildTable,
  createCaptionTag: createCaptionTag,
  buildTableData: buildTableData,
  buildTableHeader: buildTableHeader,
  builder: builder
};

define(function(tags){ return moduleFunctions; });

function buildAnchor(content, url) {
  var anchor = builder("a", content)();
  anchor.href = url;
  return anchor;
}

function buildDfn(entity, opt){
  var dfnTag = builder("dfn")();
  dfnTag.id = entity;
  if (opt.classAttr != undefined) { dfnTag.className = opt.classAttr; }
  dfnTag.innerHTML = (opt.tagContent == undefined) ? "" : opt.tagContent;
  return dfnTag;
};

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

function buildJaDfnTag(word){
  return buildDfn(word, {});
}

function buildNameDfnTag(name){
  return buildDfn(name, {tagContent: "+"});
}

function buildReadingDfnTag(word){
  return buildDfn(word, {classAttr: "reading"});
}

function buildEnDfnTag(word){
  return buildDfn(word, {classAttr: "en"});
}
