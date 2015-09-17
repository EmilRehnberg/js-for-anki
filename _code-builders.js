define(["_tag-builders"], function(tags){
  return {
    buildCodePair: buildCodePair,
  };

  function buildCodePair(io){
    return [buildCodePre(io.i), buildSampPre(io.o)].filter(Boolean);
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
