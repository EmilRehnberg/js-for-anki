
var moduleFunctions = {
  buildAnchor: buildAnchor,
  buildSpan: buildSpan,
  builder: builder
};

define(function(tags){ return moduleFunctions; });

function buildAnchor(content, url) {
  var anchor = builder("a", content)();
  anchor.href = url;
  return anchor;
}

function buildSpan(content){
  return builder("span", content)();
}

function builder(tagName, content){
  return function(){
    var tag = document.createElement(tagName);
    tag.innerHTML = content;
    return tag;
  }
}
