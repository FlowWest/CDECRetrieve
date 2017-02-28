#' Function extends retrieve_station_data and automatically places file in a
#' desired location
#' @param station_id three letter CDEC station code
#' @param sensor_num sensor number for desired data
#' @param start_date date for start of query
#' @param end_date last date to query data for
#' @param base_url url to retrieve data from, default is "shef" (most robust)
#' @param filename the destination for the archived file
#' @param comply_to defined a set of rules the csv must comply to, default is PostgreSQL
#' @return NULL, function used for side-effects
cdec_archive <- function(station_id, sensor_num,
                         dur_code, start_date, end_date,
                         base_url = "shef", filename, comply_to="psql") {
  temp_df <- retrieve_station_data(station_id, sensor_num,
                                   dur_code, start_date, end_date,
                                   base_url = "shef")

  on.exit(rm(temp_df))
  write.table(temp_df, filename, quote=FALSE,
              na = "NULL", col.names = FALSE, row.names = FALSE, sep = ",")
}
