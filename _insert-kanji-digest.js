require(["_dom-readers", "_dom-writers", "_tag-builders"], function(readers, writers, builders){
  var readerId = "text-reader";
  var articleId = "auxiliary";

  var kanji = readKanji(readerId);
  writeKanji(articleId, kanji);

  function readKanji(readerId){
    var text = readers.readTagContents(readerId);
    return extractKanji(text);
  }

  function writeKanji(articleId, kanji){
    if (Boolean(kanji) == false) { return; }
    var detailsElement = builders.buildDetailsTag(kanji, "単語を入る補");
    writers.appendTags(articleId, [detailsElement]);
  }

  function extractKanji(txt) {
    return txt.match(/[\u4E00-\u9FAF]/g).join("");
  }
});
