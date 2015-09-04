var domReadersFunctions = {
  readAnchorContent: readAnchorContent,
  readClozeSpans: readClozeSpans,
  readCodedHintExpr: readCodedHintExpr,
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
  var contents = [];
  for (var idNum in ids){
    var id = ids[idNum];
    contents = contents.concat(readTagContents(id));
  };
  return contents.join(seperator);
}

function readTagContents(id){
  var element = readElement(id);
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
  var anchorList = document.getElementsByTagName('a');
  if (anchorList.length != 0) {
    return anchorList[0].text;
  }
}

function clozedHint(){
  return readClozeSpans()[0].innerHTML;
}

function readElement(id){
  return document.getElementById(id);
}

