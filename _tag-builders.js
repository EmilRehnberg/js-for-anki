
var moduleFunctions = {
  buildAnchor: buildAnchor,
  buildBr: buildBr,
  buildCodePair: buildCodePair,
  buildDetailsTag: buildDetailsTag,
  buildDfn: buildDfn,
  buildDefDfn: buildDefDfn,
  buildJaDfnTag: buildJaDfnTag,
  buildReadingDfnTag: buildReadingDfnTag,
  buildNameDfnTag: buildNameDfnTag,
  buildEnDfnTag: buildEnDfnTag,
  buildScript: buildScript,
  buildSpan: buildSpan,
  buildTable: buildTable,
  createCaptionTag: createCaptionTag,
  buildTableData: buildTableData,
  buildTableHeader: buildTableHeader,
  buildWriterP: buildWriterP,
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
  if (opt.wrapperTag) { dfnTag = wrapInTag(dfnTag, opt.wrapperTag); }
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
  var content = ["«", name, "»"].join("");
  return builder("p", content)();
}

function buildReadingDfnTag(word){
  return buildDfn(word, {classAttr: "reading"});
}

function buildEnDfnTag(word){
  return buildDfn(word, {classAttr: "en"});
}

function buildDefDfn(word){
  return buildDfn(word, {classAttr: "definition"});
}

function buildWriterP(id){
  var pTag = builder("p")();
  pTag.id = id;
  return pTag;
}

function buildScript(content){
  return builder("script", content)();
}

function buildCodePair(io){
  return [buildCodePre(io.i), buildSampPre(io.o)].filter(Boolean);
}

function buildCodePre(lines){
  var codeTag = builder("code")();
  return buildPre(lines, codeTag);
}

function buildSampPre(lines){
  var sampTag = builder("samp")();
  return buildPre(lines, sampTag);
}

function buildPre(lines, wrapperTag){
  var preTag = builder("pre", lines.join("\n"))();
  if(wrapperTag){
    wrapperTag.insertAdjacentElement('beforeEnd', preTag);
    return wrapperTag;
  } else {
    return preTag;
  }
}

function buildDetailsTag(detailsText, summaryText){
  var detailsElement = builder("details", detailsText)();
  if (Boolean(summaryText)){
    var summaryElement = builder("summary", summaryText)();
    detailsElement.insertAdjacentElement('afterBegin', summaryElement);
  }
  return detailsElement;
}

function buildBr(){
  return builder("br")();
}
