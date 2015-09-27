#!/usr/bin/env Rscript

library(tools)
library(magrittr)
outFile = "_entity-data.js"
nameDataDir = "data/names"
metaFileName = "names-data-meta.tsv"
metaPath = file.path(nameDataDir, metaFileName)

readMeta <- function() {
  read.csv(metaPath,
           stringsAsFactors=FALSE,
           sep="\t",
           row.names=1
           )
}

listNameDataFiles <- function(){
  list.files(nameDataDir, pattern="*tsv") %>%
    setdiff(metaFileName)
}

getTsvFilePaths <- function(){
  listNameDataFiles() %>%
    file.path(nameDataDir, .)
}

readNameTSV <- function(path){
  read.csv(path,
           col.names=c("name", "reading", "description"),
           header=FALSE,
           sep="\t",
           stringsAsFactors=FALSE
           )
}

setNameFileNames <- function(nameFileList){
  names(nameFileList) <- file_path_sans_ext(listNameDataFiles())
  nameFileList
}

buildNamesData <- function(){
  getTsvFilePaths() %>%
    lapply(., readNameTSV) %>%
    setNameFileNames
}

insertMetaData <- function(dataList, meta){
  for(dataName in names(dataList)){
    for(attrName in colnames(meta)){
      dataList[[dataName]][attrName] <- meta[dataName, attrName]
    }
  }
  dataList
}

buildNameDataRow <- function(row){
  sprintf('%s: ["%s","%s","%s","%s"],', row[1], row[2], row[3], row[4], row[5])
}

buildNameDataRows <- function(nameSetsList){
  lapply(nameSetsList, function(nameSet){
    apply(nameSet, 1, buildNameDataRow)
  }) %>% unlist
}

writeNameDataFile <- function(nameSetsList, outFilePath){
  c("define(function(){ return {",
    buildNameDataRows(nameSetsList),
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
  nameDataMTimes <- lapply(getTsvFilePaths(), mTimeSecs) %>% unlist
  c(outFileMTime, nameDataMTimes) %>% max != outFileMTime
}

run <- function(){
  if(dataIsUpdated()){
    message("  names data is updated, new js-version created")
  }else{
    message("  no name updates; nothing new compiled")
    return()
  }
  meta = readMeta()
  buildNamesData() %>%
    insertMetaData(., meta) %>%
    writeNameDataFile(., outFile)
  message("  compiled new name data")
}
run()

