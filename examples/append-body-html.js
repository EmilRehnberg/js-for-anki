var docHtml = document.body.outerHTML
docHtml = mkLessThanHtmlSafe(docHtml);
docHtml = insertHtmlLineBreaks(docHtml);
appendLineSeperator();
appendDocumentHtml();

function mkLessThanHtmlSafe(htmlString){
  return htmlString.replace(/</g, '&lt;')
}

function insertHtmlLineBreaks(htmlString){
  return htmlString.replace(/\n/g, "<br />\n");
}

function appendLineSeperator(){
  document.body.innerHTML += "<hr />";
}

function appendDocumentHtml(){
  document.body.innerHTML += docHtml;
}
