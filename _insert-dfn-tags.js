require(["_dom-writers", "_tag-builders"], function(writers, builders){
  var wordSets = {
    imi: {
      readerId: "imi-reader",
      writerId: "definitions-writer",
      builder: builders.buildJaDfnTag,
      seperator: builders.buildBr
    },
    yomi: {
      readerId: "yomi-reader",
      writerId: "definitions-writer",
      builder: builders.buildReadingDfnTag
    },
    namae: {
      readerId: "namae-reader",
      writerId: "definitions-writer",
      builder: builders.buildNameDfnTag
    },
    eigo: {
      readerId: "imi-reader",
      writerId: "eigo-writer",
      builder: builders.buildEnDfnTag,
      seperator: builders.buildBr
    }
  };

  writers.writeDfnTags(wordSets);
});
