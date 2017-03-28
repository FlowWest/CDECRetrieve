source("R/consts.R")

#' Function helper to get_station_metadata below
parse_attr_to_df <- function(resp) {
  parsed_resp <- data.frame(station_id=resp[1,2],
                            elevation=readr::parse_number(resp[1,4]),
                            river_basin=tolower(resp[2,2]),
                            county=resp[2,4],
                            hydrologic_area=tolower(resp[3,2]),
                            nearby_city=tolower(resp[3,4]),
                            latitude=readr::parse_number(resp[4,2]),
                            longitude=readr::parse_number(resp[4,4]),
                            operator=tolower(resp[5,2]),
                            data_collection=tolower(resp[5,4]),
                            stringsAsFactors = FALSE)

  return(parsed_resp)
}

#' Use three letter code to retieve associated attributes
#'
#' @param stations a vector of three letter station codes.
#' @return a list of attributes associated with each station in the \code{stations} vector
#' @export
get_station_metadata <- function(stations) {

  resp <- map(stations, function(station) {
    httr::GET(cdec_urls$station_metadata,
              query = list(station_id=station)) %>%
      xml2::read_html() %>%
      rvest::html_node("table") %>%
      rvest::html_table()
  }) %>%
    map(parse_attr_to_df) %>%
    dplyr::bind_rows()

  return(resp)
}
