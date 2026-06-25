#' Show available data
#'
#' display a data frame of available data for a station.
#'
#' @param station cdec station code
#' @param keyword return sensors containing this keyword. NULL by default returns
#' all available sensors.
#' @return data frame with available data as rows.
#' @examples
#' # get a list of dataframes available for CCR
#' \dontrun{
#' cdec_datasets("ccr")
#' }
#' @export
cdec_datasets <- function(station, keyword=NULL) {

  query_url <- paste0("https://cdec.water.ca.gov/dynamicapp/staMeta?station_id=", toupper(station))

  resp <- tryCatch(
    httr::GET(query_url),
    error = function(e) {
      stop("Could not reach CDEC services",
           call. = FALSE)
    }
  )

  resp_html <- xml2::read_html(resp)
  resp_at_node <- rvest::html_elements(resp_html, "table")

  # cdec does not return any error code when a faulty query is submitted
  # here I check when the returned response is of length zero instead
  if (length(resp_at_node) == 0) {
    stop(paste0("CDEC datasets service returned no data for '", station, "'. (cdec_datasets_service)"),
         call. = FALSE)
  }
  # The sensor table has 6 columns; other tables on the page are narrower or empty
  parsed_tables <- lapply(resp_at_node, rvest::html_table)

  # The sensor is in table #3
  raw_data <- parsed_tables[[3]]

  sensor_name <- NULL # global variable workaround
  d <- suppressWarnings(clean_datasets_resp(raw_data))

  if (is.null(keyword)) {
    return(d)
  } else {
    dd <- dplyr::filter(d, grepl(sensor_name, keyword))
    if (nrow(dd) == 0) {
      message("no sensors matching the keyword were found, returning full list")
      return(d)
    } else {
      return(dd)
    }
  }
}

# INTERNAL -----

clean_datasets_resp <- function(df) {
  # columns: X1=Sensor Description, X2=Sensor Number, X3=Duration,
  #          X4=Plot, X5=Data Collection, X6=Data Available
  sensor_number <- df$X2
  sensor_name <- tolower(df$X1)

  sensor_units <- trimws(stringr::str_extract(sensor_desciption_raw, "[^,]+$"))

  duration <- stringr::str_replace_all(df$X3, "\\(|\\)", "")

  daterange_raw <- df$X6

  start_range <- lubridate::mdy(stringr::str_replace_all(
    stringr::str_extract(daterange_raw, "(.*)to"), "From | to", ""))

  end_range <- stringr::str_replace_all(
    stringr::str_extract(daterange_raw, "to(.*)"), "to |\\.", "")

  end <- lubridate::as_date(
    ifelse(end_range == "present", lubridate::today(), lubridate::mdy(end_range)))

  tibble::tibble(
    sensor_number,
    sensor_name,
    sensor_units,
    duration,
    start = start_range,
    end = end
  )
}



