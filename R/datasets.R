#' Function returns a dataframe of the available data
#' @param station a three letter cdec station if
#' @return dataframe of available data for station
#' @export
cdec_available <- function(station) {

  .Deprecated("cdec_datasets", package = "CDECRetrieve",
              msg = "function has been deprecated use `cdec_datasets()` instead")

  cdec_datasets(station)
}

#' @title Show available data
#' @description display a data frame of available data for a station.
#' @param station cdec station code
#' @return data frame with available data as rows.
#' @examples
#' # get a list of dataframes available for CCR
#' cdec_datasets("ccr")
#' @export
cdec_datasets <- function(station) {
  resp <- cdec_datasets_service(station)

  # minor cleaning of the data
  datasets <- parse_dataset_resp(resp)
  attr(datasets, "cdec_service") <- "datasets"
  return(datasets)
}



# INTERNAL


#' Function forms url and fetches the raw table from cdec datasets "service"
#' @param station station to retrieve available data for
#' @return a raw table turned to dataframe from cdec service
cdec_datasets_service <- function(station) {
  # form the request for the url
  query <- list(station_id=station,
                sensor_num=NULL)

  resp <- httr::GET(cdec_urls$datasets, query=query)
  resp_html <- xml2::read_html(resp)
  resp_at_node <- rvest::html_nodes(resp_html, "div#main_content table")
  resp_at_table <- rvest::html_table(resp_at_node)[[1]]

  return(resp_at_table)

}

#' Function parses a response from CDEC avaialable data service
#' @param df a response table from cdec via the function call_cdec_avail_service
#' @return parsed version of table returned from cdec
parse_dataset_resp <- function(df) {


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

  # eh, not functional but its aite
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










