#' Function takes a station and returns the corresponding hydro area
#' @param station a three letter code for station to find hydro_area for
get_hydro_area <- function(station) {

  cdec_urls$station_hydro_area %>%
    stringr::str_replace("STATION", station) %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    .[[1]] %>%
    .[3, 2]

}

#' function makes call to and returns appropriate table from CDEC service
#' @param station three letter code for station to query for
call_cdec_meta_service <- function(station) {
  cdec_urls$station_metadata %>%
    stringr::str_replace("STATION", station) %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    purrr::flatten()
}

#' function parses the results obtained from a cdec call
#' @param .d a data frame containing calls to cdec metadata as rows
parse_table <- function(.d) {
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


#' Use three letter code to retieve associated attributes
#'
#' @param stations a vector of three letter station codes.
#' @return a list of attributes associated with each station in the \code{stations} vector
#' @export
get_station_metadata <- function(stations) {

  # Function uses `call_cdec` and maps all queried stations onto it
  # the calls parse_table to make appropriate changes before returning
  purrr::map(stations, ~call_cdec_meta_service(.)) %>%
    dplyr::bind_rows() %>%
    parse_table()

}
























































