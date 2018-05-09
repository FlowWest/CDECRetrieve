#' @title Show available data
#' @description display a data frame of available data for a station.
#' @param station cdec station code
#' @return data frame with available data as rows.
#' @examples
#' # get a list of dataframes available for CCR
#' cdec_datasets("ccr")
#' @export
cdec_datasets <- function(station) {

  query <- list(station_id=station,
                sensor_num=NULL)

  resp <- httr::GET(cdec_urls$datasets, query=query)
  resp_html <- xml2::read_html(resp)
  resp_at_node <- rvest::html_nodes(resp_html, "div#main_content table")

  if (length(resp_at_node) == 0) {
    stop(paste0("CDEC datasets service returned no data for '", station, "'. (cdec_datasets_service)"),
         call. = FALSE)
  }

  raw_data <- rvest::html_table(resp_at_node)[[1]]

  # minor cleaning of the data
  d <- clean_datasets_resp(raw_data)
  class(d) <- append(class(d), "cdec_datasets")
  return(d)
}



# Function parses a response from CDEC available data service
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

  # eh, not functional but its ok
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










