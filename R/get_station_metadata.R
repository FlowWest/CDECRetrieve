#' Use three letter code to retieve associated attributes
#'
#' @param stations a vector of three letter station codes.
#' @return a list of attributes associated with each station in the \code{stations} vector
#' @export
get_station_metadata <- function(stations) {

  map(stations, function(station) {
    httr::GET(req_urls$station_metadata_url,
              query = list(station_id=station)) %>%
      xml2::read_html() %>%
      rvest::html_node("table") %>%
      rvest::html_table()
  }) %>%
    map(parse_attr_to_df) %>%
    bind_rows()

  # depecrated ------------------------------------------
  # for (station in stations) {
  #   res <- httr::GET(req_urls$station_metadata_url,
  #                    query = list(station_id=station))
  #   station_attributes <-
  #     xml2::read_html(res) %>%
  #     rvest::html_node("table") %>%
  #     rvest::html_table() %>%
  #     parse_attr_to_df()
  #
  #   station_res[[station]] <- station_attributes
  # }
}
