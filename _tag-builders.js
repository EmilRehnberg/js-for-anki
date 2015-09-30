define(["_words-data", "_entity-data"], function(words, names){
  var moduleFunctions = {
    buildAnchor: buildAnchor,
    buildBr: buildBr,
    buildDetailsTag: buildDetailsTag,
    buildWordDfnTag: buildWordDfnTag,
    buildNameDfnTag: buildNameDfnTag,
    buildP: buildP,
    buildDelP: buildDelP,
    buildScript: buildScript,
    buildSpan: buildSpan,
    buildTable: buildTable,
    createCaptionTag: createCaptionTag,
    buildTableData: buildTableData,
    buildTableHeader: buildTableHeader,
    buildReaderP: buildReaderP,
    buildWriterSection: buildWriterSection,
    delWrap: delWrap,
    spaceSpanBuilder: spaceSpanBuilder,
    stackBuilder: stackBuilder,
    builder: builder
  };
  return moduleFunctions;

  function buildAnchor(content, url) {
    var anchor = builder("a", content)();
    anchor.href = url;
    return anchor;
  }

  function buildSpan(content){
    return builder("span", content)();
  }

  function buildP(content){
    return builder("p", content)();
  }

  function buildDiv(){
    return builder("div")();
  }

  function buildDelP(content){
    var pTag = builder("p", content)();
    return wrapInTag(pTag, "del");
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

  function buildWordDfnTag(word){
    var dfnTag = builder("dfn")();
    var wordData = words[word];
    if(wordData == undefined){ return buildNameDfnTag(word); }
    dfnTag.setAttribute("word", word);
    dfnTag.setAttribute("reading", wordData[0]);
    dfnTag.setAttribute("ja", wordData[1]);
    dfnTag.setAttribute("en", wordData[2]);
    return dfnTag;
  }

  function buildNameDfnTag(name){
    var dfnTag = builder("dfn")();
    var nameData = names[name];
    dfnTag.setAttribute("name", name);
    if(nameData == undefined){ return builder("dfn", name)(); }
    dfnTag.setAttribute("reading", nameData[0]);
    dfnTag.setAttribute("ja", nameData[1]);
    dfnTag.setAttribute("tag", nameData[2]);
    dfnTag.className = nameData[3];
    dfnTag.innerHTML = "»" + name;
    return dfnTag;
  }

  function buildWriterSection(id){
    var writerTag = builder("section")();
    writerTag.id = id;
    return writerTag;
  }

  function buildReaderP(id){
    var pTag = builder("p")();
    pTag.id = id;
    pTag.setAttribute("hidden", true);
    return pTag;
  }

  function buildScript(content){
    return builder("script", content)();
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

  function wrapInTag(tag, wrapperTagName){
    return insertElement(builder(wrapperTagName)(), tag);
  }

  function stackBuilder(tags){
    return tags.reduce(function(divTag, tag){
      return insertElement(divTag, tag);
    }, buildDiv());
  }

  function spaceSpanBuilder(){
    return builder("span", " ")();
  }

  function delWrap(content){
    return (content) ? ["<del>", content, "</del>"].join("") : content;
  }

  function insertElement(element, adjacentElement){
    element.insertAdjacentElement("beforeEnd", adjacentElement);
    return element;
  }
});

