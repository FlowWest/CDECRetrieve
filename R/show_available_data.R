#' A catch all for failed queries, helper function to below
#' @param resp a response from httr
#' @return logical whether or not the response resulted in datasets
failed_query <- function(resp) {
  default_error_msg <- "Sorry, there is either a problem with the Duration Code"
  res_message <- xml2::read_html(resp) %>%
    rvest::html_nodes("div#page_container div.content_left_column") %>%
    rvest::html_text()

  return(grepl(default_error_msg, x = res_message))
}

call_cdec_avail_service <- function(station) {
  # form the request for the url
  query <- list(station_id=station,
                sensor_num=NULL)

  httr::GET(cdec_urls$show_historical, query=query) %>%
    xml2::read_html() %>%
    rvest::html_nodes("div#main_content table") %>%
    rvest::html_table() %>%
    .[[1]]

}

#' Function parses a response from CDEC avaialable data service
#' @param .d a response table from cdec via the function call_cdec_avail_service
#' @return parsed version of table returned from cdec
parse_avail_resp <- function(.d_raw) {

  colnames(.d_raw) <- c("sens_no", "sens_name",
                             "measure_type", "date_range")

  .d <- .d_raw %>%
    tidyr::separate_("date_range",
                     into = c("from", "start_date", "to", "end_date"), sep = " ") %>%
    dplyr::select_("sens_no", "sens_name",
                   "measure_type", "start_date", "end_date")

  .d$end_date <- ifelse(.d$end_date == "present.",
                        "present", .d$end_date)

  .d$measure_type <- stringr::str_replace_all(.d$measure_type, "(\\(|\\))+", "")

  # (todo: seperate sens_name into a name and the units used to measure)
  # (todo: make columns all of the correct class)
  # (todo: make the end date be an actual date when 'present' and convert to class date)
  # (feature: allow user to take any one of these rows and pipe into retrieve_station_data)

  .d <- .d %>%
    map_df(function(x) {
      if (is.character(x)) tolower(x)
      else x
    })

  return(.d)

}

#' Function returns a dataframe of the available data
#' @param station a three letter cdec station if
#' @return dataframe of available data for station
#' @export
show_available_data <- function(station) {

  resp <- call_cdec_avail_service(station)

  # minor cleaning of the data
  meta_attr <- parse_avail_resp(resp)
  return(meta_attr)
}
