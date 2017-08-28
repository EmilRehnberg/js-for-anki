#!/usr/bin/env Rscript

library(tools, warn.conflicts = FALSE, quietly = TRUE)
library(dplyr, warn.conflicts = FALSE, quietly = TRUE)
library(DBI, warn.conflicts = FALSE, quietly = TRUE)
outFile = "_entity-data.js"
builtNamesExtractionQuery <- dbplyr::build_sql("
SELECT name, reading, description, tag, class
  FROM names_metadata
  JOIN names
      ON names.origin = names_metadata.table_name")

buildNamesData <- function(){
  src_postgres("日本語") %>%
    tbl(builtNamesExtractionQuery) %>%
    collect %>%
    as.data.frame
}

dataIsUpdated <- function(){TRUE}

buildNameDataRow <- function(row){
  sprintf('%s: ["%s", "%s","%s", "%s"],', row[1], row[2], row[3], row[4], row[5])
}

buildNameDataRows <- function(namesDb){
  apply(namesDb, 1, buildNameDataRow)
}

writeNameDataFile <- function(namesDb, outFilePath){
  c("define(function(){ return {",
    buildNameDataRows(namesDb),
    "}; });"
    ) %>%
    paste(., collapse="\n") %>%
    write(file=outFilePath)
}

run <- function(){
  if(dataIsUpdated()){
    message("  names data is updated, new js-version created")
  }else{
    message("  no names updates; nothing new compiled")
    return()
  }
  buildNamesData() %>%
    writeNameDataFile(., outFile)
  message("  compiled new names data")
}
run()
