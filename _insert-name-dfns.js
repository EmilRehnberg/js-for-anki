require(["_dom-readers", "_entity-data"], function(readers, entities){
  var nameSepRegex = new RegExp(/[«»]/);

  insertNameDfn();

  function insertNameDfn(){
    var main = readers.readMain();
    var newInnerHTML = replaceNamesWDfn(main.innerHTML);
    main.innerHTML = newInnerHTML;
  }

  function replaceNamesWDfn(markup){
    var splits = markup.split(nameSepRegex);
    if (splits.length == 1){ return markup; }
    for(var i = 1; i < splits.length; i+=2){
      var entity = splits[i];
      splits[i] = buildDfnMarkup(entity);
    };
    return splits.join("");
  }

  function buildDfnMarkup(entity){
    var entityData = entities[entity];
    if (entityData == undefined) { return buildMissingMarkup(entity); }
    var ja = [entity,"〔", entityData[0],"〕", entityData[1], "〈", entityData[2],"〉"].join("");
    var className = entityData[3];
    var dfnMarkup = [
      "<dfn id=\"", entity,"\", class=\"", className,"\" ja=\"", ja,"\">",
      "»", "<\/dfn>",
      ].join("");
    return dfnMarkup;
  }

  function buildMissingMarkup(entity){
    return ["++", entity, "++"].join("");
  }
});
