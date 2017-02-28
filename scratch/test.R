#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library('optparse')
  library('CDECRetrieve')
  library('lubridate')
  library('magrittr')
  library('tidyr')
  library('rvest')
})

option_list <- list(
  make_option(c("-s", "--station"),
              type="character",
              help="three letter cdec station code of interest"),
  make_option(c("-n", "--sensor"),
              type = "character",
              help = "available sensor number for the given station"),
  make_option(c("-d", "--duration"),
              type = "character",
              help = "duration code (measure interval) for observation of interest"),
  make_option(c("-f", "--from"),
              type = "character",
              help = "start date for data retrieval"),
  make_option(c("-t", "--to"),
              type = "character",
              help = "end date for data retrieval"),
  make_option(c("-c", "--csv"),
              type = "character", default = NULL,
              help = "a csv with rows contining the -s -n -d -f -t")
)

parser = OptionParser(option_list = option_list)
opt = parse_args(parser)

location <- opt$station
sens_no <- opt$sensor
dur_code <- opt$duration
start_date <- opt$from
end_date <- opt$to
filename <- opt$csv

if (!is.null(filename)) {
  retrieve_data <- read.csv(filename,
                            stringsAsFactors = FALSE,
                            header = FALSE,
                            col.names = c("location", "sens_no",
                                          "dur_code", "start_date", "end_date"))
  print(head(retrieve_data))
  stop("@emanuel still has to implement this feature of the application")
}

# some parsing
start_date <- ymd(start_date)
end_date <- ymd(end_date)

# case when the user did not supply a csv file to populate from
resp_df <- retrieve_historical(location,
                               sens_no,
                               dur_code,
                               start_date,
                               end_date)


resp_df

