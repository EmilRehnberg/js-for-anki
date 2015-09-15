#!/usr/bin/env Rscript

library(tools)
library(magrittr)
outFile = "_words-data.js"
dataDir = "data/words"

wordFileNames <- function(){
  list.files(dataDir, pattern="*tsv")
}

wordFilePaths <- function(){
  wordFileNames() %>%
    file.path(dataDir, .)
}

readWordsTsv <- function(path){
  read.csv(path,
           col.names=c("word", "reading", "definition", "translation"),
           header=FALSE,
           na.strings = c("NA", "null"),
           sep="\t",
           stringsAsFactors=FALSE
           )
}

setDataListNames <- function(fileList){
  names(fileList) <- file_path_sans_ext(wordFileNames())
  fileList
}

buildWordsData <- function(){
  wordFilePaths() %>%
    lapply(., readWordsTsv) %>%
    setDataListNames
}

buildWordDataRow <- function(row){
  sprintf('%s: ["%s","%s","%s"],', row[1], row[2], row[3], row[4])
}

buildWordDataRows <- function(wordSetsList){
  lapply(wordSetsList, function(wordSet){
    apply(wordSet, 1, buildWordDataRow)
  }) %>% unlist
}

writeNameDataFile <- function(wordSetsList, outFilePath){
  c("define(function(){ return {",
    buildWordDataRows(wordSetsList),
    "}; });"
    ) %>%
    paste(., collapse="\n") %>%
    write(file=outFilePath)
}

mTimeSecs <- function(path){
  file.info(path)$mtime %>% as.numeric
}

dataIsUpdated <- function(){
  if(!file.exists(outFile)){ return(TRUE) }
  outFileMTime <- mTimeSecs(outFile)
  wordDataMTimes <- lapply(wordFilePaths(), mTimeSecs) %>% unlist
  c(wordDataMTimes) %>% max > outFileMTime
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

