#!/usr/bin/env Rscript

library(tools)
library(dplyr)
library(DBI) # needed when run in Rscript environment
outFile = "_words-data.js"
builtWordsExtractionQuery <- build_sql("
SELECT CONCAT(word, CASE WHEN rn <> 1 THEN rn ELSE NULL END),
       reading, dfn_ja, dfn_en
 FROM (
    SELECT row_number() OVER (PARTITION BY word) rn,
           *
      FROM (
        SELECT 単語 AS word,
               発音 AS reading,
               CASE WHEN 和 <> \'{}\' THEN UNNEST(和) ELSE \'\' END AS dfn_ja,
               CASE WHEN 英 <> \'{}\' THEN UNNEST(英) ELSE \'\' END AS dfn_en
          FROM goi
          ) dfn_stack
      ) dfn_stack_w_rn")

buildWordsData <- function(){
  src_postgres("日本語") %>%
    tbl(builtWordsExtractionQuery) %>%
    collect %>%
    as.data.frame
}

dataIsUpdated <- function(){TRUE}

buildWordDataRow <- function(row){
  sprintf('%s: ["%s","%s","%s"],', row[1], row[2], row[3], row[4])
}

buildWordDataRows <- function(wordsDb){
  apply(wordsDb, 1, buildWordDataRow)
}

writeNameDataFile <- function(wordsDb, outFilePath){
  c("define(function(){ return {",
    buildWordDataRows(wordsDb),
    "}; });"
    ) %>%
    paste(., collapse="\n") %>%
    write(file=outFilePath)
}

run <- function(){
  if(dataIsUpdated()){
    message("  words data is updated, new js-version created")
  }else{
    message("  no words updates; nothing new compiled")
    return()
  }
  buildWordsData() %>%
    writeNameDataFile(., outFile)
  message("  compiled new words data")
}
run()
