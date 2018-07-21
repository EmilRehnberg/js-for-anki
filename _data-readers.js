define(["_words-data", "_entity-data", "_sanskrit-words-data", "_array-helpers"], function(japWords, japNames, sanskritWords, arrays){
  return {
    readMatcingWords: readMatcingWords,
    readMatcingNames: readMatcingNames,
    readMatcingSanskritWords: readMatcingSanskritWords,
  };

  function readMatcingWords(kanji){
    return matchEntitiesFromData(japWords, kanji);
  }

  function readMatcingNames(kanji){
    return matchEntitiesFromData(japNames, kanji);
  }

  function readMatcingSanskritWords(devanagari){
    return matchEntitiesFromData(sanskritWords, devanagari);
  }

  function matchEntitiesFromData(data, kanji){
    return arrays.findMatches(readEntities(data), kanji);
  }

  function readEntities(data){
    return Object.keys(data);
  }
});
