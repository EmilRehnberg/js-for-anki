define(["_words-data", "_entity-data", "_array-helpers"], function(words, names, arrays){
  return {
    readMatcingWords: readMatcingWords,
    readMatcingNames: readMatcingNames,
  };

  function readMatcingWords(kanji){
    return matchEntitiesFromData(words, kanji);
  }

  function readMatcingNames(kanji){
    return matchEntitiesFromData(names, kanji);
  }

  function matchEntitiesFromData(data, kanji){
    return arrays.findMatches(readEntities(data), kanji);
  }

  function readEntities(data){
    return Object.keys(data);
  }
});
