require(["_dom-readers", "_dom-writers", "_tag-builders", "_array-helpers", "_data-readers"], function(readers, writers, builders, arrays, datas){

  var jaWriterId = "definitions-writer";
  var namaeWriterId = "namae-writer";
  var eigoWriterId = "eigo-writer";
  var chigaiWriterId = "chigai-writer";
  var baseWriterId = "base-data-writer";
  var wagoReaderId =  "wago-reader";
  var kangoReaderId =  "kango-reader";
  var supplementaryReaderId = "corresponding-reader";
  var namaeReaderId = "namae-reader";

  writers.writeTagsFromBuilderSets(buildSimpleContent());
  insertKanjiMatchingExpressions();
  writers.readWordsWriteDfnTags(buildWordSets());

  function insertKanjiMatchingExpressions(){
    var entityMap = buildEntityMap(readKanji());
    writeEntityMapToPlaceHolders(entityMap);
  }

  function buildEntityMap(kanji){
    return idDataPairs(kanji).reduce(function(entityMap, pair){
      entityMap[pair.id] = pair.data;
      return entityMap;
    }, {});
  }

  function readWords(kanji){
    var words = datas.readMatcingWords(kanji);
    return arrays.removeElements(words, listedWords());
  }

  function readNames(kanji){
    return datas.readMatcingNames(kanji);
  }

  function writeEntityMapToPlaceHolders(entityMap){
    Object.keys(entityMap).forEach(function(id){
      writers.appendTextToElement(id, entityMap[id].join(","));
    });
  }

  function listedWords(){
    return readers.readWords([wagoReaderId, kangoReaderId]);
  }

  function readKanji(){
    return readers.readTagContents("kanji-reader");
  }

  function idDataPairs(kanji) {
    return [
      {
        id: supplementaryReaderId,
      data: readWords(kanji),
      },
      {
        id: namaeReaderId,
      data: readNames(kanji),
      },
    ];
  }

  function buildSimpleContent(){
    return {
      radical: {
        readerId: "radical-reader",
        writerId: baseWriterId,
        builder: builders.buildP,
      },
      ja: {
        tagId: jaWriterId,
        writerId: baseWriterId,
        builder: builders.buildWriterP,
      },
      jaOldWago: {
        readerId: "old-wago-reader",
        writerId: baseWriterId,
        builder: builders.buildP,
      },
      jaOldKango: {
        readerId: "old-kango-reader",
        writerId: baseWriterId,
        builder: builders.buildP,
      },
      namae: {
        tagId: namaeWriterId,
        writerId: baseWriterId,
        builder: builders.buildWriterP,
      },
      chigai: {
        tagId: chigaiWriterId,
        writerId: baseWriterId,
        builder: builders.buildWriterP,
      },
      chigaiOld: {
        readerId: "old-chigai-reader",
        writerId: baseWriterId,
        builder: builders.buildDelP,
      },
      story: {
        readerId: "story-reader",
        writerId: baseWriterId,
        builder: builders.buildP,
      },
      eigo: {
        tagId: eigoWriterId,
        writerId: "aux-data-writer",
        builder: builders.buildWriterP,
      },
      audio: {
        readerId: "audio-reader",
        writerId: baseWriterId,
        builder: builders.buildP,
      },
      supplementary: {
        tagId: supplementaryReaderId,
        writerId: "bottom",
        builder: builders.buildReaderP,
      },
    };
  }

  function buildWordSets(){
    return {
      wago: {
        readerId: wagoReaderId,
        writerId: jaWriterId,
        seperator: builders.buildBr
      },
      kango: {
        readerId: kangoReaderId,
        writerId: jaWriterId,
        seperator: builders.buildBr
      },
      namae: {
        readerId: "namae-reader",
        writerId: namaeWriterId,
        seperator: builders.buildBr,
      },
      eigoWago: {
        readerId: wagoReaderId,
        writerId: eigoWriterId,
        seperator: builders.buildBr
      },
      eigoKango: {
        readerId: kangoReaderId,
        writerId: eigoWriterId,
        seperator: builders.buildBr
      },
      chigai: {
        readerId: "chigai-reader",
        writerId: chigaiWriterId,
      },
      supplementary: {
        readerId: supplementaryReaderId,
        writerId: jaWriterId,
      },
      supplementaryEn: {
        readerId: supplementaryReaderId,
        writerId: eigoWriterId,
        seperator: builders.spaceSpanBuilder,
      },
    };
  }
});
