library(lubridate)
library(rvest)
library(httr)

date_range <- seq(ymd("2001-01-01"), ymd("2017-01-01"), by="year")

resp_df <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range))
    break
  Sys.sleep(3)
  temp_df <- CDECRetrieve::retrieve_historical("KWK", "01",
                                               "E", date_range[i], date_range[i+1])

  print(paste("Completed:", i/length(date_range) * 100, "%"))
  resp_df <- rbind(resp_df, temp_df)
}



resp_df$value <- readr::parse_number(resp_df$value)
resp_df <- resp_df %>%
  dplyr::filter(!is.na(value), !is.na(datetime))
write.csv(resp_df, "~/shares/githubChinook/kwk_01_E_20010101_20170101.csv",
          row.names = FALSE, na = 'NULL', col.names = FALSE)


date_range <- seq(ymd("1996-01-01"), ymd("2017-01-01"), by="year")

fre <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range))
    break
  Sys.sleep(3)
  temp_df <- CDECRetrieve::retrieve_historical("FRE", "01",
                                               "E", date_range[i], date_range[i+1])

  print(paste("Completed:", i/length(date_range) * 100, "%"))
  fre <- rbind(fre, temp_df)
}

big_query <- function(station, sensor, dur_code="E", date_range, pause_dur=3) {
  resp <- data.frame()
  for (i in seq_along(date_range)) {
    if (i == length(date_range))
      break
    Sys.sleep(pause_dur)
    temp_df <- CDECRetrieve::retrieve_historical(station, sensor,
                                                 dur_code, date_range[i], date_range[i+1])

    print(paste("Completed:", i/length(date_range) * 100, "%"))
    resp <- rbind(resp, temp_df)
  }
}

fre <- big_query("FRE", "01", date_range = date_range[1:8])



















