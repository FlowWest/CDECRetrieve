#' Use three letter code to retieve associated attributes
#'
#' @param stations a vector of three letter station codes.
#' @return a list of attributes associated with each station in the \code{stations} vector
#' @export
get_station_metadata <- function(stations) {

  # create data structure to hold station attributes
  station_res <- list()

  for (station in stations) {
    res <- httr::GET(search_stations_base_url,
                     query = list(station_id=station))
    station_attributes <-
      xml2::read_html(res) %>%
      rvest::html_node("table") %>%
      rvest::html_table() %>%
      parse_attr_to_df()

    station_res[[station]] <- station_attributes
  }

  station_res
}
