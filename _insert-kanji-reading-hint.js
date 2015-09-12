require(["_tag-builders", "_dom-readers", "_dom-writers"], function(builders, readers, writers){
  var wagoReaderId = "wago-reader";
  var kangoReaderId = "kango-reader";
  var chigaiReaderId = "chigai-reader";
  var oldWagoReaderId = "old-wago-reader";
  var oldKangoReaderId = "old-kango-reader";
  var oldChigaiReaderId = "old-chigai-reader";
  var wagoNumId = "wago-number-reader";
  var kangoNumId = "kango-number-reader";
  var writerId = "kanji-data-writer";

  writers.appendTags(writerId, [buildKanjiHintSpan()]);

  function buildKanjiHintSpan(){
    var wagoHint = buildHint(wagoSymbolSpan(), wagoNumId, wagoIsPresent());
    var kangoHint = buildHint(kangoSymbolSpan(), kangoNumId, kangoIsPresent());
    var hints = [wagoHint, kangoHint].filter(Boolean).join(delAnd());
    if (hints == ""){ return builders.buildSpan(""); }
    return builders.buildSpan([delLeftPara(), hints, delRightPara()].join(""));
  }

  function buildHint(readingSymbol, numId, isPresent){
    var hintNum = readers.readTagContents(numId);
    if(hintNum){ return readNumSpan(hintNum) + readingSymbol; }
    return (isPresent) ? readingSymbol : "";
  }

  function readNumSpan(num){
    return buildSpanString(num, "class='reading-no'");
  }

  function wagoSymbolSpan(){
    return buildSpanString("訓", "id='kunyomi'");
  }

  function kangoSymbolSpan(){
    return buildSpanString("音", "id='onyomi'");
  }

  function buildSpanString(content, extra){
    var attributes = (extra) ? extra : "";
    return ["<span ", attributes, ">", content, "</span>"].join("");
  }

  function wagoIsPresent(){
    return readingIsAvailable(wagoReaderId, oldWagoReaderId);
  }

  function kangoIsPresent(){
    return readingIsAvailable(kangoReaderId, oldKangoReaderId);
  }

  function readingIsAvailable(readerId, oldReaderId){
    var reading = readers.readTagContents(readerId);
    var oldReading = readers.readTagContents(oldReaderId);
    return [reading, oldReading].filter(Boolean).length > 0;
  }

  function delAnd(){
    return builders.delWrap("と");
  }

  function delLeftPara(){
    return builders.delWrap("(");
  }

  function delRightPara(){
    return builders.delWrap(")");
  }
});
