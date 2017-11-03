# New station search development


station_search <- function(station_id, nearby_city, river_basin, hydro_area,
                           county) {

  query <- list()
  # everytime a user supplies an argument, the corresponding check needs
  # to be added to the GET query

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

  resp <- httr::GET("https://cdec.water.ca.gov/cgi-progs/staSearch",
                   query = query)

  #parsed_resp <- parse_resp(resp)
  return(resp)
}


parse_resp <- function(r) {
  html_page <- xml2::read_html(r$url)
  html_table_node <- rvest::html_node(html_page, "table")
  table_resp <- rvest::html_table(html_table_node)
}
