require(["_dom-writers", "_tag-builders"], function(writers, builders){
  var wordSets = {
    wago: {
      readerId: "wago-reader",
      writerId: "wago-writer",
      builder: builders.buildJaDfnTag,
      seperator: builders.buildBr
    },
    kango: {
      readerId: "kango-reader",
      writerId: "kango-writer",
      builder: builders.buildJaDfnTag,
      seperator: builders.buildBr
    },
    namae: {
      readerId: "namae-reader",
      writerId: "namae-writer",
      builder: builders.buildNameDfnTag
    },
    eigoWago: {
      readerId: "wago-reader",
      writerId: "eigo-writer",
      builder: builders.buildEnDfnTag,
      seperator: builders.buildBr
    },
    eigoKango: {
      readerId: "kango-reader",
      writerId: "eigo-writer",
      builder: builders.buildEnDfnTag,
      seperator: builders.buildBr
    },
    chigai: {
      readerId: "chigai-reader",
      writerId: "chigai-writer",
      builder: builders.buildReadingDfnTag
    },
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
    namae2: {
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
