define(["_string-helpers"], function(strings){
  return function(spec){

    var text = spec.text;
    var that = { text: text };
    var initialNum = strings.readInitialNum(text);
    var length
    if(initialNum > 0){
      length = initialNum;
      that.text = strings.removeInitialNum(text);
    }else{
      length = strings.removeNumbers(text).length;
    }

    that.dottify = function(){
      return strings.nDots(length);
    };

    return that;
  };
});
