define(["_dom-readers", "_array-helpers", "_object-helpers", "_tag-builders"], function(readers, arrays, objects, builders){
  var writerFunctions = {
    appendTextToElement: appendTextToElement,
    appendToBody: appendToBody,
    appendTags: appendTags,
    appendToFirstArticle: appendToFirstArticle,
    insertNameDfnToPlaceHolders: insertNameDfnToPlaceHolders,
    readWordsWriteDfnTags: readWordsWriteDfnTags,
    writeDfnTags: writeDfnTags,
    writeLetter: writeLetter,
    writeTagsFromBuilderSets: writeTagsFromBuilderSets,
    writeTemplates: writeTemplates,
  };

  return writerFunctions;

  function appendTags(id, tags, position){
    var element = readers.readElement(id);
    if(element == undefined){ return; }
    tags.forEach(appendTagToElementBuilder(element, position));
  }

  function appendTagToElementBuilder(element, position){
    return function(tag){
      var relPosition = (position) ? position : "beforeEnd";
      element.insertAdjacentElement(relPosition, tag);
    };
  }

  function appendToFirstArticle(element){
    var lastArticle = readers.readFirstArticle();
    lastArticle.insertAdjacentElement('beforeEnd', element);
  }

  function appendToBody(element){
    readers.readBody().insertAdjacentElement('beforeEnd', element);
  }

  function writeLetter(contentsMap){
    appendToBody(builders.buildLetter(contentsMap));
  }

  function writeTagsFromBuilderSets(builderSets){
    objects.forEach(builderSets, writeTagFromBuilderSet);
  }

  function writeTagFromBuilderSet(set){
    var tag = buildContentOrPlaceHolderTag(set.builder, set.readerId, set.tagId);
    appendTags(set.writerId, [tag]);
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
    objects.forEach(wordSets, readWriteFromSet);
  }

  function readWriteFromSet(set){
    set.words = readWords(set);
    if(set.words.length == 0){ return; }
    writeDfnTags(set);
  }

  function writeDfnTags(wordSet){
    var writerId = wordSet.writerId;
    var wordTags = buildWordTags(wordSet);
    var tagStack = builders.stackBuilder(wordTags);
    appendTags(writerId, [tagStack]);
  }

  function buildWordTags(wordSet){
    var wordTags = wordSet.words.map(builders.buildWordDfnTag);
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
    templates.forEach(writeTemplateTags(writerId));
  }

  function writeTemplateTags(writerId){
    return function(template){
      var templatePath = ["_tmpl-", template].join("");
      require([templatePath], function(tags){
        appendTags(writerId, tags);
      });
    };
  }

  function insertNameDfnToPlaceHolders(names){
    names.forEach(findNameClassesAndInsertDfnTags);
  }

  function findNameClassesAndInsertDfnTags(name){
    var placeHolders = readers.readClassNameElements(name);
    [].forEach.call(placeHolders, insertNameDfnToPlaceHolder(name));
  }

  function insertNameDfnToPlaceHolder(name){
    return function(placeHolder){
      var dfnTag = builders.buildNameDfnTag(name);
      placeHolder.insertAdjacentElement('beforeEnd', dfnTag);
    }
  }

  function appendTextToElement(id, text){
    readers.readElement(id).insertAdjacentText("beforeEnd", text);
  }
});
