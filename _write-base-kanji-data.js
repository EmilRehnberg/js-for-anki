require(["_dom-writers", "_tag-builders"], function(writers, builders){
  var jaWriterId = "definitions-writer";
  var namaeWriterId = "namae-writer";
  var eigoWriterId = "eigo-writer";
  var chigaiWriterId = "chigai-writer";

  var simpleContent = {
    radical: {
      readerId: "radical-reader",
      writerId: "base-data-writer",
      builder: builders.buildP,
    },
    ja: {
      tagId: jaWriterId,
      writerId: "base-data-writer",
      builder: builders.buildWriterP,
    },
    jaOldWago: {
      readerId: "old-wago-reader",
      writerId: "base-data-writer",
      builder: builders.buildP,
    },
    jaOldKango: {
      readerId: "old-kango-reader",
      writerId: "base-data-writer",
      builder: builders.buildP,
    },
    namae: {
      tagId: namaeWriterId,
      writerId: "base-data-writer",
      builder: builders.buildWriterP,
    },
    chigai: {
      tagId: chigaiWriterId,
      writerId: "base-data-writer",
      builder: builders.buildWriterP,
    },
    chigaiOld: {
      readerId: "old-chigai-reader",
      writerId: "base-data-writer",
      builder: builders.buildDelP,
    },
    story: {
      readerId: "story-reader",
      writerId: "base-data-writer",
      builder: builders.buildP,
    },
    eigo: {
      tagId: eigoWriterId,
      writerId: "aux-data-writer",
      builder: builders.buildWriterP,
    },
    audio: {
      readerId: "audio-reader",
      writerId: "base-data-writer",
      builder: builders.buildP,
    },
  };
  var wordSets = {
    wago: {
      readerId: "wago-reader",
      writerId: jaWriterId,
      seperator: builders.buildBr
    },
    kango: {
      readerId: "kango-reader",
      writerId: jaWriterId,
      seperator: builders.buildBr
    },
    namae: {
      readerId: "namae-reader",
      writerId: namaeWriterId,
    },
    eigoWago: {
      readerId: "wago-reader",
      writerId: eigoWriterId,
      seperator: builders.buildBr
    },
    eigoKango: {
      readerId: "kango-reader",
      writerId: eigoWriterId,
      seperator: builders.buildBr
    },
    chigai: {
      readerId: "chigai-reader",
      writerId: chigaiWriterId,
    },
  };
  writers.writeTagsFromBuilderSets(simpleContent);
  writers.readWordsWriteDfnTags(wordSets);
});
