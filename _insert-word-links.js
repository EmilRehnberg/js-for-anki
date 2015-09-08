var outId = "word-links-writer";
var articleId = "auxiliary";
require(["_tag-builders", "_dom-readers", "_dom-writers", "_array-helpers"], function(builders, domReaders, domWriters, arrayHelpers){
  var wordElementsIds = domReaders.readWords(["link-reader-ids"]);
  var words = domReaders.readWords(wordElementsIds);
  if (words.length == 0) { return; }
  var wordATags = mkWordATags(words);

  var detailsElement = builders.buildDetailsTag("", "単語リンク");
  detailsElement.id = outId;
  domWriters.appendTags(articleId, [detailsElement]);

  var tags = arrayHelpers.insertSeparators(wordATags, builders.builder("span", " "));
  domWriters.appendTags(outId, tags);

  function mkWordATags(words){
    var tags = [];
    for (var wordNum in words) {
      var word = words[wordNum];
      tags = tags.concat(builders.buildAnchor(word, wordDictUrl(word)));
    };
    return tags;
  }

  function wordDictUrl(word){
    return ["http://dictionary.goo.ne.jp/srch/all", word, "m0u/"].join("/");
  }

});
