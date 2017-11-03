# station search tools

#' search stations in the cdec system
#' @description function will use the CDEC station search service to return
#' a dataframe listing stations matching the arguments
#' @param station_id
#' @param nearby_city
#' @param river_basin
#' @param hydro_area
#' @param county
#' @return dataframe
#' @export
station_search <- function(station_id = "", nearby_city = "", river_basin = "",
                           hydro_area = "", county = "") {

  query <- list(sta=station_id,
                nearby=nearby_city,
                basin=river_basin,
                hydro=hydro_area,
                county=county)

  return(query)

}


form_url <- (q) {
  list(...)
  list(sta=)
}

parse_resp <- () {}


