#' @title Query observation data
#' @description Function queries the CDEC site to obtain desired station data
#' based on station, sensor number, duration code and start/end date.
#' Use cdec_datasets() to view an updated list of all available data at a station.
#' @param station three letter identification for CDEC location (example "KWK", "SAC", "CCR")
#' @param sensor_num sensor number for the measure of interest. (example "20", "01", "25")
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date a date to end query on, defaults to current date.
#' @return dataframe
#' @examples
#' kwk_hourly_flows <- CDECRetrieve::cdec_query("KWK", "20", "H", "2017-01-01")
#' ccr_hourly_temps <- CDECRetrieve::cdec_query("CCR", "25", "H", Sys.Date())
#' @export
cdec_query <- function(station, sensor_num, dur_code,
                       start_date=NULL, end_date=NULL) {

  if (is.null(start_date)) {start_date <- Sys.Date() - 2} # an arbitrary choice
  if (is.null(end_date)) {end_date <- Sys.Date() + 1}

  # decision was made here not to use httr::GET, since downloading a file
  # is much more reliable and faster from CDEC, it for some reason does not
  # handle large queries very well unless they are downloads.
  # I am still working on hopefully switching over to a combination
  # of httr and purrr but for now this works well.
  #                               -ergz

  query_url <- glue::glue(cdec_urls$download_shef,
                          STATION=station,
                          SENSOR = as.character(sensor_num),
                          DURCODE = as.character(dur_code),
                          STARTDATE = as.character(start_date),
                          ENDDATE = as.character(end_date))

  temp_file <- tempfile(tmpdir = tempdir())


  download_status <- utils::download.file(query_url, destfile = temp_file, quiet = TRUE)

  if(download_status == 0) {
    # check if the file size downloaded has a size
    if (file.info(temp_file)$size == 0) {
      stop("call to cdec failed...", call. = FALSE)
    }

    d <- suppressWarnings(shef_to_tidy(temp_file)) # return

    if (is.null(d)) {
      stop(paste("station:", station, "failed"), call. = FALSE)
    }
  } else {
    stop("call to cdec failed for uknown reason, check http://cdec.water.ca.gov for status",
         call. = FALSE)
  }

  attr(d, "cdec_service") <- "cdec_data"
  return(d)
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

  tibble::tibble(
    "agency_cd" = "CDEC",
    "location_id" = as.character(raw$X2),
    "datetime" = datetime_col,
    "parameter_cd" = as.character(cdec_code_col),
    "parameter_value" = parameter_value_col
  )
}


locate_and_replace <- function(string, v) {
  for (i in seq_along(v)) {
    string <- stringr::str_replace(string, names(v[i]), v[[i]])
  }

  return(string)
}
