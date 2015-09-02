var outId = "word-links-writer";
require(["_tag-builders", "_dom-readers", "_dom-writers", "_array-helpers"], function(tagBuilders, domReaders, domWriters, arrayHelpers){
  var wordElementsIds = domReaders.readWords(["link-reader-ids"]);
  var words = domReaders.readWords(wordElementsIds);
  if (words.length == 0) { return; }
  var wordATags = mkWordATags(words);
  var tags = arrayHelpers.insertSeparators(wordATags, tagBuilders.builder("span", " "));
  domWriters.appendTags(outId, tags);

  function mkWordATags(words){
    var tags = [];
    for (var wordNum in words) {
      var word = words[wordNum];
      tags = tags.concat(tagBuilders.buildAnchor(word, wordDictUrl(word)));
    };
    return tags;
  }

  function wordDictUrl(word){
    return ["http://dictionary.goo.ne.jp/srch/all", word, "m0u/"].join("/");
  }

});
