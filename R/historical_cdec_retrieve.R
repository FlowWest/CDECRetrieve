# Title: Historical CDEC Retriever
# Author: Emanuel Rodriguez
# Date: Wed Jan 25 14:50:50 2017
# Description: A more robust implementation of cdec retrieve that makes use
#             of the cdec SHEF downloader. Script also complies to new database design
#             Note the use of the fehs package that converts SHEF to tidy
# ----------------------




#' Function builds CDEC Url to request data
#' @param station_id three letter identification for CDEC location
#' @param sensor_num sensor number for the measure of interest
#' @param dur_code duration code for measure interval, "E", "H", "D"
#' @param start_date date to start the query on
#' @param end_date a non-inclusive date to end the query on
#' @return string url
make_cdec_url <- function(station_id, sensor_num,
                     dur_code, start_date, end_date=Sys.date(),
                     base_url = "shef") {
  cdec_urls$download_shef %>%
    stringr::str_replace("STATION", station_id) %>%
    stringr::str_replace("SENSOR", sensor_num) %>%
    stringr::str_replace("DURCODE", dur_code) %>%
    stringr::str_replace("STARTDATE", start_date) %>%
    stringr::str_replace("ENDDATE", end_date)

}

#' Function queries the CDEC services to obtain desired station data
#' @param station_id three letter identification for CDEC location
#' @param sensor_num sensor number for the measure of interest
#' @param dur_code duration code for measure interval, "E", "H", "D"
#' @param start_date date to start the query on
#' @param end_date a non-inclusive date to end the query on
#' @return tidy dataframe
retrieve_station_data <- function(station_id, sensor_num,
                                dur_code, start_date, end_date=Sys.Date(),
                                base_url = "shef") {
  message("Retrieving file...")
  raw_file <- download.file(make_cdec_url(station_id, sensor_num,
                                          dur_code, start_date, end_date,
                                          base_url = "shef"), destfile = "tempdl.txt")
  on.exit(file.remove("tempdl.txt"))
  resp <- fehs::fehs("tempdl.txt")
  resp$agency_cd <- "CDEC"
  resp[,c(5, 2, 1, 3, 4)]
}

# @TODO:emanuel needs implementation
query_station_data <- function(stations, sensor_num,
                               dur_code, start_date, end_date,
                               base_url = "shef") {

}

