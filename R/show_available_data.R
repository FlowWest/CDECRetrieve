#' A catch all for failed queries, helper function to below
#'
#' @param resp a response from httr
#' @return logical whether or not the response resulted in datasets
failed_query <- function(resp) {
  default_error_msg <- "Sorry, there is either a problem with the Duration Code"
  res_message <- xml2::read_html(resp) %>%
    rvest::html_nodes("div#page_container div.content_left_column") %>%
    rvest::html_text()

  return(grepl(default_error_msg, x = res_message))
}


#' Function returns a dataframe of the available data
#' @param station_id a three letter cdec station if
#' @return dataframe of available data for station
#' @export
show_available_data <- function(station_id) {
  # form the request for the url
  query <- list(station_id=station_id,
                sensor_num=NULL)

  resp <- httr::GET(cdec_urls$show_historical, query=query)

  if(failed_query(resp)) {
    stop("Query did not return any results")
  }

  # get attributes data
  meta_attr <- xml2::read_html(resp) %>%
    rvest::html_nodes("div#main_content table") %>%
    rvest::html_table() %>%
    .[[1]]

  colnames(meta_attr) <- c("sens_no", "sens_name", "measure_type", "date_range")

  meta_attr <- meta_attr %>%
    tidyr::separate(date_range, into = c("from", "start_date", "to", "end_date"), sep = " ") %>%
    dplyr::select(sens_no, sens_name, measure_type, start_date, end_date)


  meta_attr$end_date <- ifelse(meta_attr$end_date == "present.",
                               "present", meta_attr$end_date)

  meta_attr$measure_type <- stringr::str_replace_all(meta_attr$measure_type, "(\\(|\\))+", "")

  return(meta_attr)
}
