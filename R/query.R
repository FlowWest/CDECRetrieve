#' @title Query observation data
#' @description Function queries the CDEC site to obtain desired station data
#' based on station, sensor number, duration code and start/end date.
#' Use cdec_datasets() to view an updated list of all available data at a station.
#' @param station three letter identification for CDEC location (example "KWK", "SAC", "CCR")
#' @param sensor_num sensor number for the measure of interest. (example "20", "01", "25")
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date an optional date to end query on, defaults to current date.
#' @param tzone a time zone used. By default this is America/Los_Angeles, this accounts
#' for daylight saving.
#' @return dataframe
#' @examples
#' \dontrun{
#' kwk_hourly_flows <- CDECRetrieve::cdec_query("KWK", "20", "H", "2017-01-01")
#' ccr_hourly_temps <- CDECRetrieve::cdec_query("CCR", "25", "H", Sys.Date())
#' }
#' @export
cdec_query <- function(station, sensor_num, dur_code,
                       start_date=NULL, end_date=NULL,
                       tzone='America/Los_Angeles') {

  if (!any(tolower(dur_code) == c("h", "d", "m", "e"))) {
    stop("'dur_code' can only be one of 'h', 'd', 'm', 'e'",
         call. = FALSE)
  }


  # determine default choices
  if (is.null(start_date)) {
    start_date <- switch (tolower(dur_code),
      "e" = Sys.Date() - 2, # 2 days of data
      "h" = Sys.Date() - 2, # 2 days of data
      "m" = Sys.Date() - 90, # around 3 months
      "d" = Sys.Date() - 30 # month of data
    )}

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

  if(utils::download.file(query_url, destfile = temp_file, quiet = TRUE)) {
    stop("call to cdec failed for uknown reason, check http://cdec.water.ca.gov for status",
         call. = FALSE)
  }

  # check if the file size downloaded has a size
  if (file.info(temp_file)$size == 0) {
    stop("call to cdec failed, please visit https://cdec.water.ca.gov/ for status on their services", call. = FALSE)
  }

  shef_to_tidy <- function(file, tzone) {

    #keep these columns which are: location_id, date, time, sensor_code, value

    raw <- suppressMessages(readr::read_delim(file, skip = 8, col_names = FALSE, delim = " "))

    # exit out when the dataframe is not the right width
    if (ncol(raw) < 5) {
      return(NULL)
    }

    raw <- raw[, c(2, 3, 5, 6, 7)]

    # parse required cols
    datetime_col <- lubridate::ymd_hm(paste0(raw$X3, raw$X5), tz=tzone)
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


  d <- suppressWarnings(shef_to_tidy(temp_file, tzone))

  if (is.null(d)) {
    stop(paste(station,
               "prasing failed, but a file was returned from CDEC, please check the query, use 'cdec_datasets()' to confirm the dataset exists"), call. = FALSE)
  }

  return(d)
}
