define(["_dom-readers", "_array-helpers"], function(readers, arrays){
  var writerFunctions = {
    appendToBody: appendToBody,
    appendTags: appendTags,
    appendToFirstArticle: appendToFirstArticle,
    writeDfnTags: writeDfnTags,
    writeTemplates: writeTemplates,
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

  function writeDfnTags(wordSets){
    for(var setNum in wordSets){
      var readerId = wordSets[setNum].readerId;
      var writerId = wordSets[setNum].writerId;
      var tagBuilder = wordSets[setNum].builder;
      var seperator = wordSets[setNum].seperator;

      var words = readers.readWords([readerId]);
      if(words.length == 0){ continue; }

      var wordTags = [];
      for(var wordNum in words){
        var word = words[wordNum];
        var dfnTag = tagBuilder(word);
        wordTags.push(dfnTag);
      }
      if(seperator){ arrays.insertSeparators(wordTags, seperator); }

      appendTags(writerId, wordTags);
    }
  }

  function writeTemplates(readerId, writerId){
    var templates = readers.readWords([readerId]);
    for(templateNum in templates){
      var template = templates[templateNum];
      var templatePath = ["_tmpl-", template].join("");
      require([templatePath], function(tags){
        appendTags(writerId, tags);
      });
    }
  }
});
