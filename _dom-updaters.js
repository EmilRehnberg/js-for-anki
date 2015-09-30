define(["_dom-readers", "_dom-writers", "_tag-builders", "_string-helpers"], function(readers, writers, builders, strings){
  var domUpdaterFunctions = {
    insertHint: insertHint,
    replaceWithLength: replaceWithLength,
    replaceRomanWord: replaceRomanWord,
  };

  return domUpdaterFunctions;

  function insertHint(expression, fullTextId){
    replaceClozedWLength(expression);
    insertClozedTextHint(expression, fullTextId);
  }

  function insertClozedTextHint(expr, fullTextId){
    var hintId = "hint";
    var pHintTag = builders.buildWriterSection(hintId);

    writers.appendTags(fullTextId, [pHintTag], "afterEnd");
    var wordSet = {
      words: [expr],
      writerId: hintId,
    };
    writers.writeDfnTags(wordSet);
  }

  function replaceClozedWLength(expr) {
    [].forEach.call(
        readers.readClozeSpans(),
        function(span){ replaceWithLength(span, expr); }
        );
  }

  function replaceWithLength(element, expression){
    element.innerHTML = dottifyExpression(expression);
  }

  function dottifyExpression(expression){
    return strings.dottifyTxt(strings.removeNumbers(expression));
  }

  function replaceRomanWord(word, element){
    var wordRegex = new RegExp(word, "gi");
    element.innerHTML = element.innerHTML.replace(wordRegex, "<span class='cloze'>＊</span>")
  }
});
