require(["_dom-readers", "_dom-updaters"], function(readers, updaters){
  replaceFrontWord();

  function replaceFrontWord(){
    var frontWord = readers.readElement("front").innerHTML;
    var main = readers.readMain();
    updaters.replaceRomanWord(frontWord, main);
  }
});
