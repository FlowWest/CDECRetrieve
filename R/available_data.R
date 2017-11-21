#' Function returns a dataframe of the available data
#' @param station a three letter cdec station if
#' @return dataframe of available data for station
#' @export
show_available_data <- function(station) {

  .Deprecated("cdec_available", package = "CDECRetrieve",
              msg = "function has been deprecated use `cdec_available()`")

  cdec_available(station)
}

#' Function returns a dataframe of the available data
#' @param station a three letter cdec station if
#' @return dataframe of available data for station
#' @export
cdec_available <- function(station) {

  resp <- call_cdec_avail_service(station)

  # minor cleaning of the data
  meta_attr <- parse_avail_resp(resp)
  return(meta_attr)
}



# INTERNAL


#' Function forms url and fetches the raw table from cdec avail service
#' @param station station to retrieve available data for
#' @return a raw table turned to dataframe from cdec service
call_cdec_avail_service <- function(station) {
  # form the request for the url
  query <- list(station_id=station,
                sensor_num=NULL)

  resp <- httr::GET(cdec_urls$show_historical, query=query)
  resp_html <- xml2::read_html(resp)
  resp_at_node <- rvest::html_nodes(resp_html, "div#main_content table")
  resp_at_table <- rvest::html_table(resp_at_node)[[1]]

  return(resp_at_table)

}

#' Function parses a response from CDEC avaialable data service
#' @param df a response table from cdec via the function call_cdec_avail_service
#' @return parsed version of table returned from cdec
parse_avail_resp <- function(df) {

  colnames(df) <- c("sens_no", "sens_name",
                             "measure_type", "date_range")

  df_seperate_daterange <- tidyr::separate_(df, "date_range",
                                            into = c("from", "start_date", "to", "end_date"),
                                            sep = " ")

  df_out <- dplyr::select_(df_seperate_daterange,
                           "sens_no", "sens_name",
                           "measure_type", "start_date", "end_date")



  df_out$end_date <- ifelse(df_out$end_date == "present.",
                        "present", df_out$end_date)

  df_out$measure_type <- stringr::str_replace_all(df_out$measure_type, "(\\(|\\))+", "")

  # (todo: seperate sens_name into a name and the units used to measure)
  # (todo: make columns all of the correct class)
  # (todo: make the end date be an actual date when 'present' and convert to class date)
  # (feature: allow user to take any one of these rows and pipe into retrieve_station_data)

  return(df_out)
}
