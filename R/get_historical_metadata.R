#' @include global_funcs.R
#' @import rvest
#' @import magrittr
#' @import xml2
#' @import tidyr

#' A catch all for failed queries
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

# (TODO @emanuel) --------------------------------------------------
# @
#' Get all sensor data for a given station.
#'
#' @param station_id the three letter/number station id
#' @return a data.frame with rows representing all the sensors with available data
#' @export

cdec_historical_data_meta <- function(station_id) {
  # form the request for the url


  map(station_id, function(s) {
    query <- list(station_id=s,
                  sensor_num=NULL)
    resp <- httr::GET(req_urls$avail_data_url, query=query)

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
      separate(date_range, into = c("from", "start_date", "to", "end_date"), sep = " ") %>%
      dplyr::select(sens_no, sens_name, measure_type, start_date, end_date)

    # (TODO @emanuel) --------------------------------------------------
    # @refactor this was a useful column when the project first started, no longer
    # needed maybe remove and refactor the rest of the code
    href_list <- xml2::read_html(resp) %>%
      rvest::html_nodes("div#main_content table a") %>%
      rvest::html_attr("href")

    meta_attr$href <- href_list
    meta_attr
  }) %>%
    bind_rows()
}


