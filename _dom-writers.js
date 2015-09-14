define(["_dom-readers", "_array-helpers", "_tag-builders"], function(readers, arrays, builders){
  var writerFunctions = {
    appendToBody: appendToBody,
    appendTags: appendTags,
    appendToFirstArticle: appendToFirstArticle,
    insertNameDfnToPlaceHolders: insertNameDfnToPlaceHolders,
    readWordsWriteDfnTags: readWordsWriteDfnTags,
    writeDfnTags: writeDfnTags,
    writeTagsFromBuilderSets: writeTagsFromBuilderSets,
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

  function writeTagsFromBuilderSets(builderSets){
    for(var setNum in builderSets){
      var writerId = builderSets[setNum].writerId;
      var readerId = builderSets[setNum].readerId;
      var tagBuilder = builderSets[setNum].builder;
      var tagId = builderSets[setNum].tagId;

      var tag = buildContentOrPlaceHolderTag(tagBuilder, readerId, tagId);
      appendTags(writerId, [tag]);
    }
  }

  function buildContentOrPlaceHolderTag(tagBuilder, readerId, tagId){
    if (tagId){
      return tagBuilder(tagId);
    }else{
      var content = readers.readTagContents(readerId);
      return tagBuilder(content);
    }
  }

  function readWordsWriteDfnTags(wordSets){
    for(var setNum in wordSets){
      var wordSet = wordSets[setNum];
      wordSet.words = readWords(wordSet);
      if(wordSet.words.length == 0){ continue; }
      writeDfnTags(wordSet);
    }
  }

  function writeDfnTags(wordSet){
    var writerId = wordSet.writerId;
    var wordTags = buildWordTags(wordSet);
    appendTags(writerId, wordTags);
  }

  function buildWordTags(wordSet){
    var words = wordSet.words;
    var wordTags = [];
    for(var wordNum in words){
      var word = words[wordNum];
      var dfnTag = builders.buildWordDfnTag(word);
      wordTags.push(dfnTag);
    }
    insertSeparators(wordSet, wordTags);
    return wordTags;
  }

  function insertSeparators(wordSet, wordTags){
    var seperator = wordSet.seperator;
    if(seperator){ arrays.insertSeparators(wordTags, seperator); }
  }

  function readWords(wordSet){
    var readerId = wordSet.readerId;
    return readers.readWords([readerId]);
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

  function insertNameDfnToPlaceHolders(names){
    for(nameNum in names){
      var name = names[nameNum];
      var placeHolders = document.getElementsByClassName(name);
      for (var holderNum = 0; holderNum < placeHolders.length; holderNum++) {
        var placeHolder = placeHolders[holderNum];
        var dfnTag = builders.buildNameDfnTag(name);
        placeHolder.insertAdjacentElement('beforeEnd', dfnTag);
      }
    }
  }
});
