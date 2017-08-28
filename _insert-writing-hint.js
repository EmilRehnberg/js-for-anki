require(["_dom-updaters", "_dom-readers"], function(updaters, readers){
  var writerId = "kanji-data-writer";

  var hintText = readers.readHintReader();
  if (hintText){
    updaters.insertWritingHint(hintText, writerId);
  }
});
