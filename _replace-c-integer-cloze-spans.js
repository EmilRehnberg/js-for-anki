require(["_dom-updaters", "_dom-readers"], function(updaters, readers){
  var readerId = "text-reader";

  var expression = readers.readCodedHintExpr(readerId);
  if (expression){
    updaters.replaceClozeExpr(expression, readerId);
    updaters.insertHint(expression, readerId);
  }
});
