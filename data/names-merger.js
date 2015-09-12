define(function(){
  var mapArray = [
    appendMeta(akutou, "悪党・重犯罪捜査班", "character"),
    appendMeta(mgs, "メタルギアソリッド", "character"),
    appendMeta(actors, "俳優", "person"),
    appendMeta(budo, "武道家", "person"),
    appendMeta(minamoto, "歴史の人", "person"),
    appendMeta(rekishi, "歴史の人", "person"),
    appendMeta(tennou, "歴史の人", "person"),
  ];
  return mergeMaps(mapArray);
});

function appendMeta(map, tag, className){
  for(var attrname in map){
    map[attrname].push(tag, className);
  }
  return map;
};

function mergeMaps(mapArray){
  var fullMap = {};
  for(var mapNum in mapArray){
    var map = mapArray[mapNum];
    for(var attrname in map){
      fullMap[attrname] = map[attrname];
    }
  }
  return fullMap;
}
