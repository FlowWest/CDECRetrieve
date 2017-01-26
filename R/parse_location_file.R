# Title: Parse Location ID File
# Author: Emanuel Rodriguez
# Date: Tue Jan 24 15:33:11 2017
# Description: Takes a location file in the data dir of comma seperated locations
#               of interest
# ----------------------


get_locations_list <- function(filename) {
  raw_file <- suppressWarnings(
    readLines(con=file(filename))
  )
  raw_file <- trimws(unlist(strsplit(raw_file, ",")))
  
  closeAllConnections()
  return(raw_file)
}

