define(function(){
  return {
    nDots: nDots,
    readInitialNum: readInitialNum,
    removeInitialNum: removeInitialNum,
    removeNumbers: removeNumbers,
  };

  function removeNumbers(expression){
    return expression.replace(/[\d]/g, "");
  }

  function removeInitialNum(text){
    return text.replace(/\d+/, "");
  }

  function readInitialNum(expression){
    return parseInt(expression);
  }

  function nDots(n){
    return "・".repeat(n);
  }
});
