# Title: Historical CDEC Retriever
# Author: Emanuel Rodriguez
# Date: Wed Jan 25 14:50:50 2017
# Description: A more robust implementation of cdec retrieve that makes use
#             of the cdec csv downloader. Script also complies to new database design
# ----------------------




#' Function builds CDEC Url to request data
#' @param station_id three letter identification for CDEC location
#' @param sensor_num sensor number for the measure of interest
#' @param dur_code duration code for measure interval, "E", "H", "D"
#' @param start_date date to start the query on
#' @param end_date a non-inclusive date to end the query on
#'
make_cdec_url <- function(station_id, sensor_num,
                     dur_code, start_date, end_date,
                     base_url = "http://cdec.water.ca.gov/cgi-progs/queryCSV?") {
  paste0(
    base_url,
    "station_id=", station_id, "&",
    "sensor_num=", sensor_num, "&",
    "dur_code=", dur_code, "&",
    "start_date=", start_date, "&",
    "end_date=", end_date, "&",
    "data_wish=View+CSV+Data"
  )
}

#' Function to retrieve database complying CDEC data.
#' @param station_id three letter identification for CDEC location
#' @param sensor_num sensor number for the measure of interest
#' @param dur_code duration code for measure interval, "E", "H", "D"
#' @param start_date date to start the query on
#' @param end_date a non-inclusive date to end the query on
#'
retrieve_historical <- function(station_id, sensor_num,
                                dur_code, start_date, end_date) {


  url_req <- make_cdec_url(station_id, sensor_num, dur_code, start_date, end_date)

  raw_data <- xml2::read_html(url_req) %>%
    html_nodes("body") %>%
    html_text() %>%
    strsplit("\\n")

  raw_data <- unlist(raw_data)[-c(1,2,3)]
  raw_data <- stringr::str_replace(raw_data, "\\r", "")

  raw_matrix <- matrix(unlist(strsplit(raw_data, ",")), ncol=3, byrow=TRUE)
  colnames_tobe <- c("date", "time", "value")
  resp_df <- data.frame(raw_matrix)
  colnames(resp_df) <- colnames_tobe
  resp_df <- resp_df[-1,]

  # format types
  resp_df$datetime <- lubridate::ymd_hm(paste0(resp_df$date, resp_df$time))
  resp_df$value <- readr::parse_number(resp_df$value)
  resp_df$param_cd <- sensor_num
  resp_df$location_id <- station_id
  resp_df$agency_cd <- "CDEC"
  resp_df[,c(7,6,4,5,3)]
}

#' @param station_id three letter identification for CDEC location
#' @param sensor_num sensor number for the measure of interest
#' @param dur_code duration code for measure interval, "E", "H", "D"
#' @param date_seq a sequence of dates that appropriately split the large date range
cdec_big_query <- function(station_id, sens_no, dur_code, date_seq) {
  resp_df <- data.frame()
  for (i in seq_along(date_seq)) {
    if (i == length(date_seq)) {
      break
    }
    cat("retrieving range: ", date_seq[i], " : ", date_seq[i+1], " -- ",i/length(date_range) * 100,"%\n")
    temp_df <- retrieve_historical(station_id, sens_no, dur_code,
                                   date_seq[i], date_seq[i+1])
    resp_df <- rbind(resp_df, temp_df)

  }

  return(resp_df)
}
