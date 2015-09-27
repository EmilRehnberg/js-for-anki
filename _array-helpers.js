var helperFunctions = {
  concat: concat,
  findMatches: findMatches,
  insertSeparators: insertSeparators,
  onlyUnique: onlyUnique,
  removeElements: removeElements,
};

define(function(helpers){ return helperFunctions; });

function findMatches(array, matcher){
  var matcherRegexp = new RegExp(matcher);
  return array.filter(function(element){ return element.match(matcherRegexp) });
}

function insertSeparators(elements, sepClosure){
  for(var i = elements.length - 1; i--; ){
    elements.splice(i+1, 0, sepClosure());
  }
  return elements;
}

function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}

function removeElements(array1, array2){
  return array1.filter(function(element){
    return array2.indexOf(element) == -1;
  });
}

function concat(array, additionalElementsArray){
  return array.concat(additionalElementsArray);
}
