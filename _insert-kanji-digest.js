var readerId = "text-reader";
var writerId = "kanji-digest-writer";

var kanji = readKanji(readerId);
writeKanji(writerId ,kanji);

function readKanji(readerId){
  var readerElement = document.getElementById(readerId);
  if (readerElement == undefined) {return ;}
  return extractKanji(readerElement.innerHTML);
}

function writeKanji(writerId, kanji){
  if (Boolean(kanji) == false) { return; }
  var writerElement = document.getElementById(writerId);
  if (writerElement == undefined){ return; }
  writerElement.insertAdjacentText('beforeEnd', kanji);
}

function extractKanji(txt) {
  return txt.match(/[\u4E00-\u9FAF]/g).join("");
}
