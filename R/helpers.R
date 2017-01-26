is_even <- function(n) {
  if (n %% 2 == 0)
    return(TRUE)
  else
    return(FALSE)
}

get_locations_list <- function(filename) {
  raw_file <- suppressWarnings(
    readLines(con=file(filename))
  )
  raw_file <- trimws(unlist(strsplit(raw_file, ",")))

  closeAllConnections()
  return(raw_file)
}


source("parse_location_file.R")

build_stations_metadata <- function(stations) {
  tryCatch(metadata_df <-
             do.call(rbind, CDECarchiveR::get_station_metadata(cdec_stations)),
           error = function(e){
             stop("Error creating metadata data frame")
           })

  return(metadata_df)
}
