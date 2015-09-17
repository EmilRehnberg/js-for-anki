define(["_dom-readers", "_dom-writers", "_tag-builders", "_string-helpers"], function(readers, writers, builders, strings){
  var domUpdaterFunctions = {
    insertHint: insertHint,
    replaceClozeExpr: replaceClozeExpr,
    replaceWithLength: replaceWithLength,
  };

  return domUpdaterFunctions;

  function replaceClozeExpr(expression, fullTextId){
    var firstClozedSpan = readers.readClozeSpans()[0];
    firstClozedSpan.outerHTML = "";
    var textElement = readers.readElement(fullTextId);
    exprRegex = new RegExp(expression, "g");
    textElement.innerHTML = textElement.innerHTML.replace(exprRegex, firstClozedSpan.outerHTML);
  }

  function insertHint(expression, fullTextId){
    replaceClozedWLength(expression);
    insertClozedTextHint(expression, fullTextId);
  }

  function insertClozedTextHint(expr, fullTextId){
    var hintId = "hint";
    var pHintTag = builders.buildWriterP(hintId);

    writers.appendTags(fullTextId, [pHintTag], "afterEnd");
    var wordSet = {
      words: [expr],
      writerId: hintId,
    };
    writers.writeDfnTags(wordSet);
  }

  function replaceClozedWLength(expr) {
    var clozeSpans = readers.readClozeSpans();
    for (clozeNum in clozeSpans){
      replaceWithLength(clozeSpans[clozeNum], expr);
    }
  }

  function replaceWithLength(element, expression){
    element.innerHTML = dottifyExpression(expression);
  }

  function dottifyExpression(expression){
    return strings.dottifyTxt(strings.removeNumbers(expression));
  }
});
