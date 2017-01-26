# Title: CDEC Filename Utilities
# Author: Emanuel Rodriguez
# Date: Tue Jan 24 16:05:46 2017
# Description: a set of R utilities to work with the naming sceme in the data files
# ----------------------

library("stringr")

parse_filename <- function(filename) {
  filename <- str_replace(filename, ".csv", "")
  file_entities <- str_split(filename, "_") %>% unlist()
  
  data.frame("cdec_site"=file_entities[1], 
             "sensor_num"=file_entities[2], 
             "measure_interval"=file_entities[3], 
             "start_date"=file_entities[4], 
             "end_date"=file_entities[5])
}

build_filename <- function(site_code, sensor_num, measure_interval, 
                           start_date, end_date) {
  data.frame("cdec_site"=site_code, 
             "sensor_num"=sensor_num, 
             "measure_interval"=measure_interval, 
             "start_date"=start_date, 
             "end_date"=end_date)
}

# function checks to see if a given combination of location, sensor_no, 
# measure interval, and dates are in the data directory
is_in_directory <- function(site_code, sensor_num, measure_interval, data_dir="data/") {
  list_of_files <- list.files(data_dir, pattern = ".csv")
  
  found_matches 
}

parse_cdec_file <- function(filename) {
  raw_data <- read.csv(filename, 
                       stringsAsFactors = FALSE, skip = 1, 
                       colClasses = c("character", "character", "character"))
  colnames(raw_data) <- c("date", "time", "value")
  raw_data$datetime <- lubridate::ymd_hm(paste0(raw_data$date, raw_data$time))
  raw_data[,c(4, 3)]
}