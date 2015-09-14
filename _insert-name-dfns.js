require(["_dom-readers", "_dom-writers", "_array-helpers"], function(readers, writers, arrays){
  var nameSepRegex = new RegExp(/[«»]/);

  insertNameDfn();

  function insertNameDfn(){
    var main = readers.readMain();
    var entities = [];
    var newInnerHTML = replaceNamesWPlaceHolder(main.innerHTML, entities);
    main.innerHTML = newInnerHTML;
    writers.insertNameDfnToPlaceHolders(entities.filter(arrays.onlyUnique));
  }

  function replaceNamesWPlaceHolder(markup, entities){
    var splits = markup.split(nameSepRegex);
    if (splits.length == 1){ return markup; }
    for(var i = 1; i < splits.length; i+=2){
      var entity = splits[i];
      splits[i] = buildEntityPlaceHolder(entity);
      entities.push(entity);
    };
    return splits.join("");
  }

  function buildEntityPlaceHolder(entity){
    return ["<span class='", entity,"'></span>"].join("");
  }
});
