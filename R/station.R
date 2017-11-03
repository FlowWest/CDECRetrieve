#' search for stations in the cdec system
#' @description search the stations in thec CDEC system using the CDEC Station Search
#' service \href{https://cdec.water.ca.gov/cgi-progs/staSearch}{here}
#' @param station_id string three letter station code
#' @param nearby_city string search stations near supplied city
#' @param river_basin string search stations in supplied basin
#' @param hydro_area string search stations in supplied hydrological area
#' @param county string search stations in supplied county
#' @export
station_search <- function(station_id, nearby_city, river_basin, hydro_area,
                           county) {

  query <- form_url(station_id, nearby_city, river_basin, hydro_area,
                    county)

  resp <- httr::GET("https://cdec.water.ca.gov/cgi-progs/staSearch",
                   query = query)

  if (!is_ok(resp)) stop(sprintf("request to cdec station search failed with status code: %d"),
                         httr::status_code(resp))

  parsed_resp <- parse_resp(resp)
  return(parsed_resp)
}

# INTERNAL

is_ok <- function(r) {
  identical(httr::status_code(r), 200L)
}

xml_is_missing <- function(r) {
  identical(class(r), "xml_missing")
}

form_url <- function(station_id, nearby_city, river_basin, hydro_area,
                     county) {

  query <- list()


  if (missing(station_id)) {
    query$sta = ""
  } else {
    query$sta = station_id
    query$sta_chk = "on"
  }

  if (missing(nearby_city)) {
    query$nearby = ""
  } else {
    query$nearby = nearby_city
    query$nearby_chk = "on"
  }

  if (missing(river_basin)) {
    query$basin = ""
  } else {
    query$basin = river_basin
    query$basin_chk = "on"
  }

  if (missing(hydro_area)) {
    query$hydro = ""
  } else {
    query$hydro = hydro_area
    query$hydro_chk = "on"
  }

  if (missing(county)) {
    query$county = ""
  } else {
    query$county = county
    query$county_chk = "on"
  }

  return(query)
}

parse_resp <- function(r) {
  html_page <- xml2::read_html(r$url)
  html_table_node <- rvest::html_node(html_page, "table")

  if (xml_is_missing(html_table_node)) {
    stop(sprintf("unable to parse response, cdec response to query was not in the form of a table.
                 check supplied arguments to `station_search()`"),
         call. = FALSE)
  }

  table_resp <- rvest::html_table(html_table_node)
  return(table_resp)
}
