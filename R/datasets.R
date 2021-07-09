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
  query <- list(station_id=station,
                sensor_num=NULL)

  resp <- tryCatch(
    httr::GET("https://cdec.water.ca.gov/cgi-progs/querySHEF", query=query),
    error = function(e) {
      stop("Could not reach CDEC services",
           call. = FALSE)
    }
  )

  resp_html <- xml2::read_html(resp)
  resp_at_node <- rvest::html_nodes(resp_html, "div#main_content table")

  # cdec does not return any error code when a faulty query is submitted
  # here I check when the returned response is of length zero instead
  if (length(resp_at_node) == 0) {
    stop(paste0("CDEC datasets service returned no data for '", station, "'. (cdec_datasets_service)"),
         call. = FALSE)
  }

  raw_data <- rvest::html_table(resp_at_node)[[1]]

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
  sensor_number <- df$X1
  sensor_desciption_raw <- tolower(df$X2)

  sensor_name <- trimws(stringr::str_replace_all(stringr::str_extract(
    sensor_desciption_raw, ".*\\("
  ), "\\(|,", ""))

  sensor_units <- trimws(stringr::str_replace_all(
    stringr::str_extract(sensor_desciption_raw, "\\(.*\\)"),
    "\\(|\\)", ""))

  duration <- stringr::str_replace_all(df$X3, "\\(|\\)", "")

  daterange_raw <- df$X4

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



