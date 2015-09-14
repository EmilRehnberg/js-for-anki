var helperFunctions = {
  insertSeparators: insertSeparators,
  onlyUnique: onlyUnique,
};

define(function(helpers){ return helperFunctions; });

function insertSeparators(elements, sepClosure){
  for(var i = elements.length - 1; i--; ){
    elements.splice(i+1, 0, sepClosure());
  }
  return elements;
}

function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}
