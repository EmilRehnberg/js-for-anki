var helperFunctions = {
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
  array2.forEach(function(element){
    array1.splice(array1.indexOf(element), 1)
  });
}
