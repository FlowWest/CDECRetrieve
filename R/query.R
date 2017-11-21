#' @title Query observation data
#' @description Function queries the CDEC services to obtain desired station data
#' based on station, sensor number, duration code and start/end date.
#' @param stations three letter identification for CDEC location.
#' @param sensor_num sensor number for the measure of interest.
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date a date to end query on, defaults to current date.
#' @return tidy dataframe
#' @examples
#' kwk_hourly_flows <- CDECRetrieve::retrieve_station_data("KWK", "20", "H", "2017-01-01")
#'
#' @export
retrieve_station_data <- function(stations, sensor_num,
                                  dur_code, start_date, end_date="") {

  .Deprecated("cdec_query", package = "CDECRetrieve",
              msg = "function has been deprecated use 'query()'")

  cdec_query(stations, sensor_num,
        dur_code, start_date, end_date="")
}


#' @title Query observation data
#' @description Function queries the CDEC services to obtain desired station data
#' based on station, sensor number, duration code and start/end date.
#' sensor number as well as duration value. Use show_avaialable_data() to view
#' an update list of a stations data.
#' @param stations three letter identification for CDEC location (example "KWK", "SAC", "CCR")
#' @param sensor_num sensor number for the measure of interest. (example "20", "01", "25")
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date a date to end query on, defaults to current date.
#' @return tidy dataframe
#' @examples
#' kwk_hourly_flows <- CDECRetrieve::retrieve_station_data("KWK", "20", "H", "2017-01-01")
#'
#' @export
cdec_query <- function(stations, sensor_num,
                  dur_code, start_date, end_date="") {

  temp_file <- tempfile(pattern = "cdecQuery", tmpdir = tempdir())
  do_query <- function(station) {

    # a real ugly side effect here, download the file to temp location and
    # and read from it. Doing it this way allows us to query large amounts of data
    download_failed <- utils::download.file(make_cdec_url(station, sensor_num,
                                                   dur_code, start_date, end_date),
                                     destfile = temp_file,
                                     quiet = TRUE)

    if(download_failed)
      stop("could not read cdec services, maybe they are down?")

    # catch the case when cdec is down
    if (file.info(temp_file)$size == 0) {
      stop("query did not produce a result, possible cdec is down?")
    }

    on.exit(file.remove(temp_file))
    resp <- suppressWarnings(shef_to_tidy(temp_file))
    resp$agency_cd <- "CDEC"
    resp[,c(5, 1:4)]
  }

  purrr::map_dfr(stations, ~do_query(.))

}


# Helpers

make_cdec_url <- function(station_id, sensor_num,
                          dur_code, start_date, end_date=as.character(Sys.Date())) {
  cdec_urls$download_shef %>%
    stringr::str_replace("STATION", station_id) %>%
    stringr::str_replace("SENSOR", sensor_num) %>%
    stringr::str_replace("DURCODE", dur_code) %>%
    stringr::str_replace("STARTDATE", start_date) %>%
    stringr::str_replace("ENDDATE", end_date)

}

shef_to_tidy <- function(file) {
  raw <- readr::read_delim(file, skip = 9, col_names = FALSE, delim = " ")

  if (ncol(raw) < 5) {
    stop("A faulty query was requested, please check query,
         does this station have this duration and sensor combination?")
  }

  raw <- raw[, c(2, 3, 5, 6, 7)]  # keep relevant cols
  raw <- raw %>% tidyr::unite_(col = "datetime",
                               from = c("X3", "X5"), sep ="", remove = TRUE)
  raw$datetime <- lubridate::ymd_hm(raw$datetime, tz="America/Los_Angeles")

  shef_code <- raw$X6[1]
  cdec_code <- ifelse(is.null(shef_code_lookup[[shef_code]]),
                      NA, shef_code_lookup[[shef_code]])
  raw$X6 <- rep(cdec_code, nrow(raw))
  colnames(raw) <- c("location_id", "datetime", "parameter_cd", "parameter_value")

  # parse to correct type
  raw$parameter_value <- as.numeric(raw$parameter_value)

  return(raw[, c(2, 1, 3, 4)])
}
