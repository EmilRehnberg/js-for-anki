define(function(){
  return {
    dottifyTxt: dottifyTxt,
    removeNumbers: removeNumbers,
  };

  function removeNumbers(expression){
    return expression.replace(/[\d]/g, "");
  }

  function dottifyTxt(expression){
    return expression.replace(/./g, "・");
  }
});
