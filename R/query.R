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


# TODO(emanuel) check whether start/end dates are inclusive or exclusive when calling cdec
#' @title Query observation data
#' @description Function queries the CDEC site to obtain desired station data
#' based on station, sensor number, duration code and start/end date.
#' Use show_avaialable_data() to view an updated list of all available data at a station.
#' @param stations three letter identification for CDEC location (example "KWK", "SAC", "CCR")
#' @param sensor_num sensor number for the measure of interest. (example "20", "01", "25")
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date a date to end query on, defaults to current date.
#' @return tidy dataframe
#' @examples
#' kwk_hourly_flows <- CDECRetrieve::retrieve_station_data("KWK", "20", "H", "2017-01-01")
#' @export
cdec_query <- function(stations, sensor_num, dur_code, start_date, end_date="") {

  temp_file <- tempfile(tmpdir = tempdir())
  on.exit(file.remove(temp_file)) # dont wait for os to remove the file

  do_query <- function(station) {

    # a real ugly side effect here, download the file to temp location and
    # and read from it. Doing it this way allows us to query large amounts of data
    download_status <- utils::download.file(make_cdec_url(station, sensor_num,
                                                          dur_code, start_date, end_date),
                                            destfile = temp_file,
                                            quiet = TRUE)

    if(download_status == 0) {
      if (file.info(temp_file)$size == 0) {
        stop("call to cdec failed...", call. = FALSE)
      }
      parsed_df <- suppressWarnings(shef_to_tidy(temp_file)) # return
      if (is.null(parsed_df)) {
        warning(paste("station:", station, "failed"), call. = FALSE)
        return()
      } else {
        return(parsed_df)
      }
    } else {
      stop("call to cdec failed...(emanuel will improve this piece soon)",
           call. = FALSE)
    }
  }

  d <- purrr::map_dfr(stations, ~do_query(.))
  attr(d, "cdec_service") <- "cdec_data"
  return(d)
}


# INTERNAL

make_cdec_url <- function(station_id, sensor_num,
                          dur_code, start_date,
                          end_date=Sys.Date()) {
  cdec_urls$download_shef %>%
    stringr::str_replace("STATION", station_id) %>%
    stringr::str_replace("SENSOR", sensor_num) %>%
    stringr::str_replace("DURCODE", dur_code) %>%
    stringr::str_replace("STARTDATE", as.character(start_date)) %>%
    stringr::str_replace("ENDDATE", as.character(end_date))

}


# function uses a file on disk to process from shef to a tidy format
shef_to_tidy <- function(file) {

  #keep these columns which are: location_id, date, time, sensor_code, value
  cols_to_keep <- c(2, 3, 5, 6, 7)

  raw <- readr::read_delim(file, skip = 8, col_names = FALSE, delim = " ")

  # exit out when the dataframe is not the right width
  if (ncol(raw) < 5) {
    return(NULL)
  }

  raw <- raw[, cols_to_keep]

  # parse required cols
  datetime_col <- lubridate::ymd_hm(paste0(raw$X3, raw$X5))
  shef_code <- raw$X6[1]
  cdec_code <- ifelse(is.null(shef_code_lookup[[shef_code]]),
                      NA, shef_code_lookup[[shef_code]])
  cdec_code_col <- rep(cdec_code, nrow(raw))
  parameter_value_col <- as.numeric(raw$X7)

  data.frame(
    "agency_cd" = "CDEC",
    "location_id" = raw$X2,
    "datetime" = datetime_col,
    "parameter_cd" = cdec_code_col,
    "parameter_value" = parameter_value_col
  )
}
