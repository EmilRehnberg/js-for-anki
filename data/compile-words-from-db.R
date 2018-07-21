#!/usr/bin/env Rscript

source("data/compiler-setup.R")
builtWordsExtractionQuery <- dbplyr::build_sql("
SELECT CONCAT(word, CASE WHEN rn <> 1 THEN rn ELSE NULL END),
       reading, dfn_ja, dfn_en
 FROM (
    SELECT row_number() OVER (PARTITION BY word) rn,
           *
      FROM (
        SELECT * FROM (
          SELECT 単語 AS word,
                 発音 AS reading,
                 mix_definitions_and_tags(ROW(和, tags)) AS dfn_ja,
                 mix_definitions_and_tags(ROW(英, tags)) AS dfn_en
            FROM goi
           WHERE 単語 <> 発音

           UNION ALL
          SELECT 発音 AS word,
                 単語 AS reading,
                 mix_definitions_and_tags(ROW(和, tags)) AS dfn_ja,
                 mix_definitions_and_tags(ROW(英, tags)) AS dfn_en
            FROM goi
           WHERE 単語 <> 発音

           UNION ALL
          SELECT 発音 AS word,
                 '' AS reading,
                 mix_definitions_and_tags(ROW(和, tags)) AS dfn_ja,
                 mix_definitions_and_tags(ROW(英, tags)) AS dfn_en
            FROM goi
           WHERE 単語 = 発音

           UNION ALL
          SELECT UNNEST(alternate_writing) AS word,
                 発音 AS reading,
                 mix_definitions_and_tags(ROW(和, tags)) AS dfn_ja,
                 mix_definitions_and_tags(ROW(英, tags)) AS dfn_en
            FROM goi
           WHERE alternate_writing IS NOT NULL

           UNION ALL
          SELECT 単語 AS word,
                 UNNEST(alternate_reading) AS reading,
                 mix_definitions_and_tags(ROW(和, tags)) AS dfn_ja,
                 mix_definitions_and_tags(ROW(英, tags)) AS dfn_en
            FROM goi
           WHERE alternate_reading IS NOT NULL

           UNION ALL
          SELECT UNNEST(alternate_reading) AS word,
                 単語 AS reading,
                 mix_definitions_and_tags(ROW(和, tags)) AS dfn_ja,
                 mix_definitions_and_tags(ROW(英, tags)) AS dfn_en
            FROM goi
           WHERE alternate_reading IS NOT NULL
      ) dfn_stack
  ORDER BY word, reading, dfn_ja, dfn_en
    ) sorted_dfn_stack
  ) dfn_stack_w_rn")

buildWordsData <- function()
  src_postgres("日本語") %>%
    tbl(builtWordsExtractionQuery) %>%
    collect %>%
    as.data.frame

dataIsUpdated <- function() TRUE

buildWordDataRow <- function(row)
  sprintf('%s: ["%s","%s","%s"],', row[1], row[2], row[3], row[4])

buildWordDataRows <- function(wordsDb) apply(wordsDb, 1, buildWordDataRow)

writeNameDataFile <- function(wordsDb, outFilePath)
  c("define(function(){ return {",
    buildWordDataRows(wordsDb),
    "}; });"
    ) %>%
    paste(., collapse="\n") %>%
    write(file=outFilePath)

run <- function(outFile = "_words-data.js"){
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
