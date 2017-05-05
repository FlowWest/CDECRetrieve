#source("R/consts.R")

#cdec_urls

#' Function builds CDEC Url to request data
#' @param station_id three letter identification for CDEC location
#' @param sensor_num sensor number for the measure of interest
#' @param dur_code duration code for measure interval, "E", "H", "D"
#' @param start_date date to start the query on
#' @param end_date a non-inclusive date to end the query on
#' @return string url
make_cdec_url <- function(station_id, sensor_num,
                     dur_code, start_date, end_date=as.character(Sys.Date()),
                     base_url = "shef") {
  cdec_urls$download_shef %>%
    stringr::str_replace("STATION", station_id) %>%
    stringr::str_replace("SENSOR", sensor_num) %>%
    stringr::str_replace("DURCODE", dur_code) %>%
    stringr::str_replace("STARTDATE", start_date) %>%
    stringr::str_replace("ENDDATE", end_date)

}

#@TODO:refactor --- refactor to make more functional
shef_to_tidy <- function(file) {
  raw <- readr::read_delim(file, skip = 9, col_names = FALSE, delim = " ")
  # d <- raw %>%
  #   dplyr::select_(2, 3, 5, 6, 7) %>%
  #   tidyr::unite_(col = "datetime", from = c("X3", "X5"), sep = "")

  raw <- raw[, c(2, 3, 5, 6, 7)]  # keep relevant cols
  raw <- raw %>% tidyr::unite(datetime, X3, X5, sep ="")
  raw$datetime <- lubridate::ymd_hm(raw$datetime)

  shef_code <- raw$X6[1]
  raw$X6 <- rep(shef_code_lookup[[shef_code]], nrow(raw))
  colnames(raw) <- c("location_id", "datetime", "parameter_cd", "parameter_value")

  return(raw[, c(2, 1, 3, 4)])
}

#' Function queries the CDEC services to obtain desired station data
#' @param station_id three letter identification for CDEC location.
#' @param sensor_num sensor number for the measure of interest.
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date a date to end query on, defaults to current date.
#' @return tidy dataframe
#' @examples
#' kwk_hourly_temp <- retrieve_station_data("KWK", "20", "H", "2017-01-01")
#'
#' @export
retrieve_station_data <- function(station_id, sensor_num,
                                dur_code, start_date, end_date="",
                                base_url = "shef") {

  # a real ugly side effect here, but its reliability is great
  raw_file <- download.file(make_cdec_url(station_id, sensor_num,
                                          dur_code, start_date, end_date,
                                          base_url = "shef"), destfile = "tempdl.txt",
                            quiet = TRUE)

  # catch the case when cdec is down
  if (file.info("tempdl.txt")$size == 0) {
    stop("query did not produce a result, possible cdec is down?")
  }
  on.exit(file.remove("tempdl.txt"))
  resp <- shef_to_tidy("tempdl.txt")
  resp$agency_cd <- "CDEC"
  resp[,c(5, 1:4)]
}
