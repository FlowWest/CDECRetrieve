#' Search CDEC Stations
#'
#' Search the stations in the CDEC system using the CDEC Station Search
#' service \href{https://cdec.water.ca.gov/dynamicapp/staSearch}{here}. Combinations
#' of these parameters can be supplied to refine or be left out to generalize, at least
#' one must be supplied.
#'
#' @param station_id string three letter station code
#' @param nearby_city string search stations near supplied city
#' @param river_basin string search stations in supplied basin
#' @param hydro_area string search stations in supplied hydrological area
#' @param county string search stations in supplied county
#' @return data frame with queried stations as rows and
#' columns describing the \code{station_id}, \code{name}, \code{river_basin}, \code{county}, \code{longitude},
#' \code{latitude}, \code{elevation}, \code{operator}, and \code{state}
#' @examples
#' # cdec_stations() can be used to find locations within an area of interest
#' \dontrun{
#' cdec_stations(county = "alameda")
#' }
#' # or it can be used to get metadata attributes for a location
#' \dontrun{
#' cdec_stations(station_id = "ccr")
#' }
#' @export
cdec_stations <- function(station_id=NULL, nearby_city=NULL, river_basin=NULL,
                          hydro_area=NULL, county=NULL) {

  if (is.null(c(station_id,
                       nearby_city,
                       river_basin,
                       hydro_area,
                       county))) stop("at least one search parameter must be supplied",
                                          call. = FALSE)

  query <- create_station_query(station_id=station_id, nearby_city=nearby_city,
                                river_basin=river_basin, hydro_area=hydro_area,
                                county=county)

  resp <- tryCatch(
    httr::GET("https://cdec.water.ca.gov/dynamicapp/staSearch", query = query),
    error = function(e) {
      stop("Could not reach CDEC services", call. = FALSE)
    }
  )

  if (resp$status_code == 404) {
    stop("Could not reach CDEC services", call. = FALSE)
  }

  html_page <- xml2::read_html(resp$url)
  html_table_node <- rvest::html_node(html_page, "table")

  if (missing_xml(html_table_node)) {
    stop("request returned no data, please check input values", call. = FALSE)
  }

  raw_station_data <- rvest::html_table(html_table_node)


  cdec_station_parse(raw_station_data)
}

#' Map Station Search
#'
#' Populate a leaflet map with the results of cdec_stations() call. The function
#' makes use of leaflet, and so will work only if this is installed on the system.
#' This function is bundled simply for exploration purposes, it is highly suggested
#' to make use of leaflet for production maps.
#'
#' @param .data result of a cdec_stations() call
#' @param ... named arguments passed into leaflet::addCircleMarkers
#' @return a leaflet map widget with circle markers at the locations of CDEC stations
#' @examples
#' \dontrun{
#' if (interactive()) {
#'     cdec_stations(county = "alameda") %>% map_stations(label=~name, popup=~station_id)
#' }
#' }
#' @export
map_stations <- function(.data, ...) {
  if (!inherits(.data, "tbl_df")) {
    stop(".data does not appear to be a call from cdec_stations()", call. = FALSE)
  }
  if (nrow(.data) == 0) {
    stop(".data appears to be an empty table, check cdec_station() call")
  }
  if (!requireNamespace("leaflet", quietly = TRUE)) {
    stop("map_stations() requires leaflet to be installed (map_stations)")
  }

  m <- leaflet::leaflet(dplyr::filter(.data))
  m <- leaflet::addTiles(m)
  leaflet::addCircleMarkers(m, fillColor = "#666666",
                            fillOpacity = 1, color="black", ...)
}


# INTERNAL

missing_xml <- function(.) {
  identical(., xml2::xml_missing())
}


create_station_query <- function(station_id=NULL, nearby_city=NULL, river_basin=NULL,
                                 hydro_area=NULL, county=NULL) {
  query <- list()

  # certain defaults need to be present for queries to work
  if (is.null(station_id)) {
    query$sta = ""
  }
  else {
    query$sta = toupper(station_id)
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

