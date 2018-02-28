#' search for stations in the cdec system
#' @description search the stations in thec CDEC system using the CDEC Station Search
#' service \href{https://cdec.water.ca.gov/cgi-progs/staSearch}{here}
#' @param station_id string three letter station code
#' @param nearby_city string search stations near supplied city
#' @param river_basin string search stations in supplied basin
#' @param hydro_area string search stations in supplied hydrological area
#' @param county string search stations in supplied county
#' @examples
#' # cdec_stations() can be used to find locations within an area of interest
#' cdec_stations(county = "alameda")
#' # or it can be used to get metadata attributes for a location
#' cdec_stations(station_id = "ccr")
#' @export
cdec_stations <- function(station_id=NULL, nearby_city=NULL, river_basin=NULL,
                          hydro_area=NULL, county=NULL) {

  query <- create_station_query(station_id=station_id, nearby_city=nearby_city,
                                river_basin=river_basin, hydro_area=hydro_area,
                                county=county)

  resp <- httr::GET("https://cdec.water.ca.gov/cgi-progs/staSearch",
                   query = query)

  html_page <- xml2::read_html(resp$url)
  html_table_node <- rvest::html_node(html_page, "table")

  if (missing_xml(html_table_node)) {
    stop("request returned no data, please check input values", call. = FALSE)
  }

  raw_station_data <- rvest::html_table(html_table_node)


  stations_data <- cdec_station_parse(raw_station_data)
  attr(stations_data, "cdec_service") <- "cdec_stations"
  return(stations_data)
}

#' @title Map Station Search
#' @description Populate a leaflet map with the results of cdec_stations() call
#' @param .data result of a cdec_stations() call
#' @param ... named arguments passed into leaflet::addCircleMarkers
#' @examples
#' if (interactive()) {
#'     cdec_stations(county = "alameda") %>% map_stations(label=~name, popup=~station_id)
#' }
#' @export
map_stations <- function(.data, ...) {
  if(!is_cdec_station(.data)) {
    stop(".data appears to not be a result of calling cdec_stations() (map_stations)",
         call. = FALSE)
  }

  if (!requireNamespace("leaflet", quietly = TRUE)) {
    stop("map_stations() requires leaflet to be installed (map_stations)")
  }

  m <- leaflet::leaflet(.data)
  m <- leaflet::addTiles(m)
  leaflet::addCircleMarkers(m, ...)
}

# INTERNAL

create_station_query <- function(station_id=NULL, nearby_city=NULL, river_basin=NULL,
                                 hydro_area=NULL, county=NULL) {
  query <- list()

  # certain defaults need to be present for queries to work
  if (is.null(station_id)) {
    query$sta = ""
  }
  else {
    query$sta = station_id
    query$sta_chk = "on"
  }

  if (is.null(nearby_city)) {
    query$nearby = ""
  } else {
    query$nearby = nearby_city
    query$nearby_chk = "on"
  }

  if (is.null(river_basin)) {
    query$basin = ""
  } else {
    query$basin = river_basin
    query$basin_chk = "on"
  }

  if (is.null(hydro_area)) {
    query$hydro = ""
  } else {
    query$hydro = hydro_area
    query$hydro_chk = "on"
  }

  if (is.null(county)) {
    query$county = ""
  } else {
    query$county = county
    query$county_chk = "on"
  }

  return(query)
}

# r is a response from the cdec service
cdec_station_parse <- function(data) {
  tibble::tibble(
    station_id = tolower(data$ID),
    name = tolower(data$`Station Name`),
    river_basin = tolower(data$`River Basin`),
    county = tolower(data$County),
    longitude = data$Longitude,
    latitude = data$Latitude,
    elevation = data[, 7],
    operator = data$Operator,
    state = "ca"
  )
}





