var domReadersFunctions = {
  readWords: readWords
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

function readElement(id){
  return document.getElementById(id);
}

