var writerFunctions = {
  appendTags: appendTags,
};

define(function(writers){ return writerFunctions; });

function appendTags(id, tags, position){
  var element = document.getElementById(id);
  if(element == undefined){ return; }
  for (var tagNum in tags) {
    appendTagToElement(element, tags[tagNum], position);
  }
}

function appendTagToElement(element, tag, position){
  var relPosition = (position) ? position : "beforeEnd";
  element.insertAdjacentElement(relPosition, tag);
}
