define(function(){
  return {
    forEach: forEach,
  };

  function forEach(object, callback){
    Object.keys(object).forEach(function(key){
      callback(object[key]);
    });
  }
});
