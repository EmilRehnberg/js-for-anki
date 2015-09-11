require(["_dom-readers", "_dom-writers", "_tag-builders", "_array-helpers"], function(readers, writers, builders, arrays){
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

  for(var setNum in wordSets){
    var readerId = wordSets[setNum].readerId;
    var writerId = wordSets[setNum].writerId;
    var tagBuilder = wordSets[setNum].builder;
    var seperator = wordSets[setNum].seperator;

    var words = readers.readWords([readerId]);
    if(words.length == 0){ continue; }

    var wordTags = [];
    for(var wordNum in words){
      var word = words[wordNum];
      var dfnTag = tagBuilder(word);
      wordTags.push(dfnTag);
    }
    if(seperator){ arrays.insertSeparators(wordTags, seperator); }

    writers.appendTags(writerId, wordTags);
  }
});
