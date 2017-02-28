# Title: Build stations metadata table
# Author: Emanuel Rodriguez
# Date: Tue Jan 24 15:39:34 2017
# Description: create a table with metadata for the stations of interest
# ----------------------

#' @param stations a vector of stations codes to build metadata table for
#' @return a data.frame with rows of stations and columns of meta attributes
#' @export
#'
# (TODO @emanuel) some metadata has commas as entries, psql hates this, fix it!
build_stations_metadata <- function(stations) {
  tryCatch(metadata_df <-
             do.call(rbind, CDECarchiveR::get_station_metadata(cdec_stations)),
           error = function(e){
             stop("Error creating metadata data frame")
           })

  return(metadata_df)
}
