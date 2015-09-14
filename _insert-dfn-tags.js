require(["_dom-writers", "_tag-builders"], function(writers, builders){
  var wordSets = {
    imi: {
      readerId: "imi-reader",
      writerId: "definitions-writer",
      seperator: builders.buildBr,
    },
    yomi: {
      readerId: "yomi-reader",
      writerId: "reading-writer",
    },
    namae: {
      readerId: "namae-reader",
      writerId: "namae-writer",
    },
    eigo: {
      readerId: "imi-reader",
      writerId: "eigo-writer",
      seperator: builders.buildBr,
    }
  };

  writers.readWordsWriteDfnTags(wordSets);

});
