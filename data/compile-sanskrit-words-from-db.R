#!/usr/bin/env Rscript

source("data/compiler-setup.R")
builtNamesExtractionQuery <- dbplyr::build_sql("SELECT REPLACE(devanagari, ' ', '_') AS devanagari, iast, definition, etymology, ARRAY_TO_STRING(tags, ',') AS tags FROM words")

buildNamesData <- function()
  src_postgres("sanskrit") %>%
    tbl(builtNamesExtractionQuery) %>%
    collect %>%
    as.data.frame

dataIsUpdated <- function() TRUE

buildNameDataRow <- function(row)
  sprintf('%s: ["%s", "%s", "%s", "%s"],', row[1], row[2], row[3], row[4], row[5])

buildNameDataRows <- function(namesDb) apply(namesDb, 1, buildNameDataRow)

writeNameDataFile <- function(namesDb, outFilePath)
  c("define(function(){ return {",
    buildNameDataRows(namesDb),
    "}; });"
    ) %>%
    paste(., collapse="\n") %>%
    write(file=outFilePath)

run <- function(outFile = "_sanskrit-words-data.js"){
  if(dataIsUpdated()){
    message("  sanskrit words data is updated, new js-version created")
  }else{
    message("  no sanskrit words updates; nothing new compiled")
    return()
  }
  buildNamesData() %>%
    writeNameDataFile(., outFile)
  message("  compiled new sanskrit words data")
}
run()
