define(["_dom-readers", "_dom-writers", "_tag-builders", "_array-helpers", "_data-readers"], function(readers, writers, builders, arrays, datas){

  var jaWriterId = "definitions-writer";
  var namaeWriterId = "namae-writer";
  var eigoWriterId = "eigo-writer";
  var chigaiWriterId = "chigai-writer";
  var baseWriterId = "base-data-writer";
  var wagoReaderId =  "wago-reader";
  var kangoReaderId =  "kango-reader";
  var supplementaryReaderId = "corresponding-reader";

  return { main: main };

  function main(){
    writers.writeTagsFromBuilderSets(buildSimpleContent());
    insertKanjiMatchingWords();
    writers.readWordsWriteDfnTags(buildWordSets());
  }

  function insertKanjiMatchingWords(){
    writeWordsToPlaceHolder(readWords());
  }

  function readWords(){
    return datas.readMatcingWords(readKanji());
  }

  function readKanji(){
    return readers.readTagContents("kanji-data-writer");
  }

  function writeWordsToPlaceHolder(words){
    arrays.removeElements(words, listedWords());
    writers.appendTextToElement(supplementaryReaderId, words.join(","));
  }

  function listedWords(){
    return readers.readWords([wagoReaderId, kangoReaderId]);
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
