var domReadersFunctions = {
  readAnchorContent: readAnchorContent,
  readBangHint: readBangHint,
  readBody: readBody,
  readClozeSpans: readClozeSpans,
  readCodedHintExpr: readCodedHintExpr,
  readFirstArticle: readFirstArticle,
  readMain: readMain,
  readTagContents: readTagContents,
  readWords: readWords,
  readElement: readElement,
};

define(function(readers){ return domReadersFunctions; });

function readWords(ids){
  var seperator = ",";
  var wordsString = readIdsInnerHtml(ids, seperator);
  return wordsString.split(seperator).filter(Boolean);
}

function readIdsInnerHtml(ids, seperator){
  return ids.map(readTagContents).join(seperator);
}

function readTagContents(id){
  var element = (id) ? readElement(id) : undefined;
  return (element) ? element.innerHTML : undefined;
}

function readClozeSpans(){
  return document.getElementsByClassName("cloze");
}

function readCodedHintExpr(fullTextId){
  var cIntRegex = /\[c(\d)\]/g;
  var cIntMatch = clozedHint().match(cIntRegex);
  if (cIntMatch){
    var cInt = parseInt(cIntMatch.toString().substring(2));
    var spanRegex = /<\/?(span)[^>]*>/igm;
    var textSpanSplit = readTagContents(fullTextId).split(spanRegex);
    return textSpanSplit.pop().substr(0,cInt);
  }
}

function readAnchorContent(){
  var anchorList = readTags('a');
  if (anchorList.length != 0) {
    return anchorList[0].text;
  }
}

function readBangHint(){
  var spans = readClozeSpans();
  var bangHints = readBangHintsFromSpans(spans);
  if (bangHints.length != 0) {
    return bangHints[0];
  }
}

function readBangHintsFromSpans(spans){
  return [].map.call(spans, readBangHintFromSpan).filter(Boolean);
}

function readBangHintFromSpan(span){
  var content = span.innerHTML;
  if(content == undefined){ return; }
  if(hasClozedBangHint(content)){
    return readClozedBangHint(content);
  }
}

function hasClozedBangHint(content){
  return content[1] == "!";
}

function readClozedBangHint(content){
  return content.slice(2,-1);
}

function clozedHint(){
  return readClozeSpans()[0].innerHTML;
}

function readFirstArticle(){
  return readTags("article")[0];
}

function readMain(){
  return readTags("main")[0];
}

function readTags(name){
  return document.getElementsByTagName(name);
}

function readElement(id){
  return document.getElementById(id);
}

function readBody(){
  return document.body;
}

