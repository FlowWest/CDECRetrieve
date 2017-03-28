get_locations_list <- function(filename) {
  raw_file <- suppressWarnings(
    readLines(con=file(filename))
  )
  raw_file <- trimws(unlist(strsplit(raw_file, ",")))

  closeAllConnections()
  return(raw_file)
}

