define(["_tag-builders", "_dom-writers", "_array-helpers"], function(tags, writers, arrays){
  return {
    buildCodeTagsSet: buildCodeTagsSet,
    writeAdjacentCode: writeAdjacentCode,
  };

  function writeAdjacentCode(ioSets){
    var preTags = buildCodeTagsSet(ioSets);
    var tagStack = tags.stackBuilder(preTags);
    writers.appendToFirstArticle(tagStack);
  }

  function buildCodeTagsSet(ioSets){
    return ioSets.
      map(setToLineTags).
      reduce(arrays.concat).
      filter(Boolean);
  }

  function setToLineTags(set){
    return [
        buildCommentPre(set.c),
        buildCodePre(set.i),
        buildSampPre(set.o),
        ];
  }

  function buildCommentPre(lines){
    if(lines == undefined){ return; }
    var commentTag = buildPre(lines);
    commentTag.className = "code-comment";
    return commentTag;
  }

  function buildCodePre(lines){
    var codeTag = tags.builder("code")();
    return buildPre(lines, codeTag);
  }

  function buildSampPre(lines){
    var sampTag = tags.builder("samp")();
    return buildPre(lines, sampTag);
  }

  function buildPre(lines, wrapperTag){
    var preTag = tags.builder("pre", lines.join("\n"))();
    if(wrapperTag){
      wrapperTag.insertAdjacentElement('beforeEnd', preTag);
      return wrapperTag;
    } else {
      return preTag;
    }
  }
});
