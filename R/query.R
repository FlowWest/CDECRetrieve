#' Query observation data
#'
#' Function queries the CDEC site to obtain desired station data
#' based on station, sensor number, duration code and start/end date.
#' Use `cdec_datasets()` to view an updated list of all available data at a station.
#'
#' @param station three letter identification for CDEC location (example "KWK", "SAC", "CCR")
#' @param sensor_num sensor number for the measure of interest. (example "20", "01", "25")
#' @param dur_code duration code for measure interval, "E", "H", "D", which correspong to Event, Hourly and Daily.
#' @param start_date date to start the query on.
#' @param end_date an optional date to end query on, defaults to current date.
#' @param tzone a time zone used. By default this is America/Los_Angeles, this accounts
#' for daylight saving.
#' @return data frame containing queried data from CDEC for a specific station, sensor, and date range
#' @examples
#' \dontrun{
#' kwk_hourly_flows <- CDECRetrieve::cdec_query("KWK", "20", "H", "2017-01-01")
#' ccr_hourly_temps <- CDECRetrieve::cdec_query("CCR", "25", "H", Sys.Date())
#' }
#' @export
cdec_query <- function(station, sensor_num, dur_code,
                       start_date=NULL, end_date=NULL,
                       tzone='America/Los_Angeles') {

  if (!any(tolower(dur_code) == c("h", "d", "m", "e",
                                  "hourly", "daily", "monthly", "event"))) {
    stop("'dur_code' can only be one of 'h/hourly', 'd/daily', 'm/monthly', 'e/event'",
         call. = FALSE)
  }

  if (dur_code %in% c("hourly", "daily", "monthly", "event")) {
    dur_code <-
      as.character(c("hourly"="h",
                     "daily"="d",
                     "monhtly"="m",
                     "event"="e")[dur_code])
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

  query_url <- sprintf("https://cdec.water.ca.gov/dynamicapp/req/CSVDataServlet?Stations=%s&SensorNums=%s&dur_code=%s&Start=%sT00:00&End=%s",
                       toupper(station),
                       as.character(sensor_num),
                       as.character(dur_code),
                       as.character(start_date),
                       as.character(end_date))

  temp_file <- tempfile(tmpdir = tempdir())

  tryCatch(
    utils::download.file(query_url, destfile = temp_file, quiet = TRUE),
    warning = function(w) stop("call to cdec failed for uknown reason, check http://cdec.water.ca.gov for status",
                               call. = FALSE),
    error = function(e) stop("call to cdec failed for uknown reason, check http://cdec.water.ca.gov for status",
                             call. = FALSE)
  )

  # check if the file size downloaded has a size
  if (file.info(temp_file)$size == 0) {
    stop("call to cdec failed, please visit https://cdec.water.ca.gov/ for status on their services", call. = FALSE)
  }

  parse_csv <- function(file, tzone) {

    #keep these columns which are: location_id, date, time, sensor_code, value

    raw <- suppressMessages(
      readr::read_csv(
        file,
        col_types = readr::cols(.default = readr::col_character())))

    # exit out when the dataframe is not the right width
    if (nrow(raw) == 0 || ncol(raw) < 7) {
      return(NULL)
    }

    raw <- raw[, c(2, 3, 5, 6, 7)]

    # DATE TIME column is formatted as "20200616 0500"
   clean <- raw %>%
     mutate(date_time = lubridate::parse_date_time(`DATE TIME`,
                                                   orders = "Ymd HM",
                                                   tz = tzone),
            agency_cd = "CDEC",
            location_id = as.character(`STATION_ID`),
            parameter_cd = as.character(`PARAMETER_ID`),
            parameter_value = readr::parse_number(`VALUE`,
              na = c("", "NA", "---", "m", "ART")
            ))
    return(clean)
  }


  d <- suppressWarnings(parse_csv(temp_file, tzone))

  if (is.null(d)) {
    stop(paste(station,
               "parsing failed, but a file was returned from CDEC, please check the query, use 'cdec_datasets()' to confirm the dataset exists"), call. = FALSE)
  }

  return(d)
}
