require(["_dom-updaters", "_dom-readers"], function(updaters, readers){
  var readerId = "text-reader";

  var anchorHint = readers.readAnchorContent();
  if (anchorHint){
    updaters.insertHint(anchorHint, readerId);
  }
});
