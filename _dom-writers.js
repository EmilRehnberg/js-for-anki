define(["_dom-readers"], function(readers){
  var writerFunctions = {
    appendToBody: appendToBody,
    appendTags: appendTags,
    appendToFirstArticle: appendToFirstArticle,
  };

  return writerFunctions;

  function appendTags(id, tags, position){
    var element = readers.readElement(id);
    if(element == undefined){ return; }
    for (var tagNum in tags) {
      appendTagToElement(element, tags[tagNum], position);
    }
  }

  function appendTagToElement(element, tag, position){
    var relPosition = (position) ? position : "beforeEnd";
    element.insertAdjacentElement(relPosition, tag);
  }

  function appendToFirstArticle(element){
    var lastArticle = readers.readFirstArticle();
    lastArticle.insertAdjacentElement('beforeEnd', element);
  }

  function appendToBody(element){
    readers.readBody().insertAdjacentElement('beforeEnd', element);
  }
});
