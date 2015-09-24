define(["_words-data", "_array-helpers"], function(words, arrays){
  return {
    readMatcingWords: readMatcingWords,
  };

  function readMatcingWords(kanji){
    return arrays.findMatches(allWords(), kanji);
  }

  function allWords(){
    return Object.keys(words);
  }
});
