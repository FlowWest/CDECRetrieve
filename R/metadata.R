#' Use three letter code to retieve associated attributes. NOTE: function
#' deprecated use 'query_metadata()'.
#'
#' @param stations a vector of three letter station codes.
#' @return a list of attributes associated with each station in the \code{stations} vector
#' @export
get_station_metadata <- function(stations) {

  .Deprecated("cdec_metadata", package = "CDECRetrieve",
              msg = "function deprecated, use 'cdec_metadata()'")

  cdec_metadata(stations)

}

#' Use three letter code to retieve associated attributes
#'
#' @param stations a vector of three letter station codes.
#' @return a dataframe with rows as stations submitted to the query
#' @export
cdec_metadata <- function(stations) {

  call_cdec_meta_service <- function(station) {
    cdec_urls$station_metadata %>%
      stringr::str_replace("STATION", station) %>%
      xml2::read_html() %>%
      rvest::html_table() %>%
      purrr::flatten()
  }

  resp <- purrr::map_dfr(stations, ~call_cdec_meta_service(.))
  parse_meta_response(resp)
}

# Helpers

parse_meta_response <- function(.d) {
  .d %>%
    dplyr::mutate_(
      agency = lazyeval::interp(~x, x="cdec"),
      state = lazyeval::interp(~x, x="ca"),
      location_id = ~tolower(ID),
      location_name = ~tolower(`Station Name`),
      county = ~tolower(County)
    ) %>%
    dplyr::select_(
      "agency", "location_id", "location_name",
      "county", lat = "Latitude",
      long = "Longitude", "state"
    )
}
