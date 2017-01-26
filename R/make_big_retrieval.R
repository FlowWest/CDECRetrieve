
cdec_big_retrieval <- function(station_id, sensor_num,
                                  dur_code, start_date, end_date, interval="month") {

  date_range <- seq(ymd(start_date), ymd(end_date), by=interval)
  # not ideal to grow objects but we can fix this later on
  resp_df <- data.frame()

  i <- 1

  if (is_even(length(date_range))) {
    while (i <= length(date_range)) {
      tryCatch({
        tmpdf <- retrieve_historical(station_id, sensor_num, dur_code,
                                     date_range[i], date_range[i+1])
        resp_df <- rbind(resp_df, tmpdf)
      },
      error = function(e) {
        return(resp_df)
      })

      i <- i + 2
    }

    return(resp_df)
  }
  add_date <- date_range[length(date_range)]
  month(add_date) <- month(add_date) + 1
  date_range <- append(date_range, add_date)
  cat(ymd(date_range))
  while (i <= length(date_range)) {
    tryCatch({
      tmpdf <- retrieve_historical(station_id, sensor_num, dur_code,
                                   date_range[i], date_range[i+1])
      resp_df <- rbind(resp_df, tmpdf)
    },
    error = function(e) {
      return(resp_df)
    })

    i <- i + 2
  }
  return(resp_df)
}

