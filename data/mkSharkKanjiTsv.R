#!/usr/bin/env Rscript

require(magrittr)

originalTsvPath = "./nhg-shark-kanji.txt"
outKanjiTsvPath = "./kanji/baseData.tsv"
outWordsTsvPath = "./wordsFromSharkKanji.tsv"

columnNames <-
  c("heisigNr", "V2", "V3",
    "heisigMeaning", "kanji", "V4",
    "hint", "meaning", "strokeCount",
    "V5", "V6", "V7", "V8", "V9", "V10",
    "jouYou", "jlpt", "on", "kun",
    "words", "yomiExample", "Tags"
    )
kanjiDataVariables <-
  c("kanji", "heisigMeaning", "heisigNr",
    "meaning", "on", "kun", "yomiExample")
wordsPartitionRegex <- "[()]|(^:\ )"
wordColumns <- c("word","reading","ja","en")
parseWordString <- function(wordString) {
  leftPareRegex <- "[(]"
  rightPareRegex <- "(\\):\ )"

  wordString %>%
    regmatches(., regexpr(leftPareRegex, .), invert=TRUE) %>%
    unlist %>%
    regmatches(., regexpr(rightPareRegex, .), invert=TRUE) %>%
    unlist
}

fullData <-
  read.csv(originalTsvPath,
           col.names=columnNames,
           header=FALSE,
           sep="\t",
           stringsAsFactors=FALSE)

fullData %>%
  subset(select = kanjiDataVariables) %>%
  write.table(file=outKanjiTsvPath,
              sep = "\t",
              quote=FALSE,
              row.names=FALSE,
              col.names=FALSE,
              fileEncoding="UTF-8")

wordDt <- fullData %>%
  subset(select=c("words")) %>%
  apply(., 1, strsplit, "<br>") %>%
  unlist %>%
  data.frame(words=., row.names=NULL) %>%
  apply(., 1,
        function(wordString) {
          wordString %>%
            parseWordString
        }
  ) %>%
  t %>%
  data.frame(stringsAsFactors=FALSE) %>%
  unique

names(wordDt) <- c("word", "reading", "en")
repWords <- wordDt$word %>%
  table %>%
  is_greater_than(1) %>%
  which %>%
  names

for(word in repWords){
  wordIndexes <- which(wordDt$word == word)
  wordDt$word[wordIndexes] = paste0(word, 1:length(wordIndexes))
}

wordDt$ja = ""
wordDt <- wordDt %>%
  extract(wordDt %>% extract("reading") %>% order,)

write.table(wordDt[, wordColumns],
            file=outWordsTsvPath,
            sep="\t",
            quote=FALSE,
            row.names=FALSE,
            col.names=FALSE,
            fileEncoding="UTF-8")

