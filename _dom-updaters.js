define(["_dom-readers", "_dom-writers", "_tag-builders", "_expression"], function(readers, writers, builders, Expression){
  var domUpdaterFunctions = {
    insertHint: insertHint,
    insertWritingHint: insertWritingHint,
    replaceWithLength: replaceWithLength,
    replaceRomanWord: replaceRomanWord,
  };

  return domUpdaterFunctions;

  function insertHint(expressionText, fullTextId){
    var hintId = "hint";
    var expression = Expression({ text: expressionText });
    replaceClozedWLength(expression);
    buildAndInsertHint(expression, fullTextId, hintId);
  }

  function insertWritingHint(expressionText, fullTextId){
    var hintId = "writing-hint";
    var expression = Expression({ text: expressionText });
    buildAndInsertHint(expression, fullTextId, hintId);
  }

  function buildAndInsertHint(expr, fullTextId, hintId){
    var pHintTag = builders.buildWriterSection(hintId);

    writers.appendTags(fullTextId, [pHintTag], "afterEnd");
    var wordSet = {
      words: [expr.text],
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
    element.innerHTML = expression.dottify();
  }

  function replaceRomanWord(word, element){
    var wordRegex = new RegExp(word, "gi");
    element.innerHTML = element.innerHTML.replace(wordRegex, "<span class='cloze'>＊</span>")
  }
});
