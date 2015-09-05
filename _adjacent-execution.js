require(["_dom-readers", "_dom-writers", "_tag-builders"], function(readers, writers, builders){
  var execScripts = readers.readWords(["execute-scripts"]);
  for (scriptNum in execScripts){
    var scriptTag = buildScript(execScripts[scriptNum]);
    writers.appendToBody(scriptTag);
  }

  function buildScript(scriptName){
    var prependPath = readPrependedPath();
    var code = ['require(["', prependPath, '_', scriptName, '.js"]);'].join("");
    return builders.buildScript(code);
  }

  // only used in examples
  function readPrependedPath(){
    var prependId = "prepend-path";
    var pathElement = document.getElementById(prependId);
    if(pathElement == undefined){ return ""; };
    return pathElement.innerHTML;
  }
});
