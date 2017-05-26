
#' Get Hydro Area from CDEC Station
#' @export
get_hydro_area <- function(station) {

  cdec_urls$station_hydro_area %>%
    stringr::str_replace("STATION", station) %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    .[[1]] %>%
    .[3, 2]

}

get_station_table <- function(station) {
  cdec_urls$station_metadata %>%
    stringr::str_replace("STATION", station) %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    purrr::flatten()
}

#' Use three letter code to retieve associated attributes
#'
#' @param stations a vector of three letter station codes.
#' @return a list of attributes associated with each station in the \code{stations} vector
#' @export
get_station_metadata <- function(stations) {

  call_cdec <- function(station) {
    cdec_urls$station_metadata %>%
      stringr::str_replace("STATION", station) %>%
      xml2::read_html() %>%
      rvest::html_table() %>%
      purrr::flatten()
  }


  purrr::map(stations, ~call_cdec(.)) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(agency = "cdec", state = 'ca',
                  hydro_area = tolower(get_hydro_area(ID)),
                  location_id = tolower(ID),
                  location_name = tolower(`Station Name`),
                  county = tolower(County)) %>%
    dplyr::select(agency, location_id, location_name,
                  county, hydro_area, lat = Latitude,
                  long = Longitude, state)


}
























































