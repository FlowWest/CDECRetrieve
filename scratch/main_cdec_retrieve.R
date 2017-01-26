# first test on the kwk station
kwk_01_1_5 <- cdec_big_retrieval("KWK", "01", "E", "2010-01-01", "2010-06-01")
kwk_01_6_12 <- cdec_big_retrieval("KWK", "01", "E", "2010-06-01", "2011-01-01")
kwk_01_1_5_2011 <- cdec_big_retrieval("KWK", "01", "E", "2011-01-01", "2011-06-01")
kwk_01_6_12_2011 <- cdec_big_retrieval("KWK", "01", "E", "2011-06-01", "2012-01-01")
kwk_01_1_5_2012 <- cdec_big_retrieval("KWK", "01", "E", "2012-01-01", "2012-06-01")

dup_rows <- which(!is.na(match(rownames(kwk_01_1_5), rownames(kwk_01_6_12))))

kwk_01_2010_2011 <- cdec_big_retrieval("KWK", "01", "E", "2010-01-01", "2012-01-01")
kwk_01_2012_2013 <- cdec_big_retrieval("KWK", "01", "E", "2012-01-01", "2014-01-01")
kwk_01_2014_2016 <- cdec_big_retrieval("KWK", "01", "E", "2014-01-01", "2016-01-01")
kwk_01_2016_2017 <- cdec_big_retrieval("KWK", "01", "E", "2016-01-01", "2018-01-20")

write.csv(kwk_01_2010_2011, "data/kwk_01_E_2010-01-01_2012-02-01.csv", row.names = FALSE)
write.csv(kwk_01_2012_2013, "data/kwk_01_E_2012-01-01_2014-02-01.csv", row.names = FALSE)
write.csv(kwk_01_2014_2016, "data/kwk_01_E_2014-01-01_2016-02-01.csv", row.names = FALSE)


kwk_01_2010_2016 <- rbind(kwk_01_2010_2011, kwk_01_2012_2013, kwk_01_2014_2016, kwk_01_2016_2017)
write.csv(resp_df, "data/kwk_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)


# KWK -----------------------------------------------------------------------------
# KWK sens 01
date_range <- seq(ymd("2010-01-01"), ymd("2017-01-01"), by = "year")

resp_df <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range)) {
    break
  }
  cat("retrieving range: ", date_range[i], " : ", date_range[i+1], "\n")
  tempdf <- retrieve_historical("KWK", "01", "E", date_range[i], date_range[i+1])
  resp_df <- rbind(resp_df, tempdf)

}
# KWK sens 20
date_range <- seq(ymd("2010-01-01"), ymd("2017-01-01"), by = "year")

kwk_20_2010_2016 <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range)) {
    break
  }
  cat("retrieving range: ", date_range[i], " : ", date_range[i+1], "\n")
  tempdf <- retrieve_historical("KWK", "20", "E", date_range[i], date_range[i+1])
  kwk_20_2010_2016 <- rbind(kwk_20_2010_2016, tempdf)

}
write.csv(kwk_20_2010_2016, "data/kwk_20_E_2010_2016.csv", row.names = FALSE)

# FRE ---------------------------------------------------------------------------
# sens 01
tempdf <- data.frame()
fre_01_2010_2017 <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range)) {
    break
  }
  cat("retrieving range: ", date_range[i], " : ", date_range[i+1], "\n")
  tempdf <- retrieve_historical("FRE", "01", "E", date_range[i], date_range[i+1])
  fre_01_2010_2017 <- rbind(fre_01_2010_2017, tempdf)

}
write.csv(fre_01_2010_2017, "data/fre_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

# sens 20
tempdf <- data.frame()
fre_20_2010_2017 <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range)) {
    break
  }
  cat("retrieving range: ", date_range[i], " : ", date_range[i+1], "\n")
  tempdf <- retrieve_historical("FRE", "20", "E", date_range[i], date_range[i+1])
  fre_20_2010_2017 <- rbind(fre_20_2010_2017, tempdf)

}
write.csv(fre_20_2010_2017, "data/fre_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

# BND ------------------------------------------------------------------------------
# sens 01
tempdf <- data.frame()
bnd_01_2010_2017 <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range)) {
    break
  }
  cat("retrieving range: ", date_range[i], " : ", date_range[i+1], "\n")
  tempdf <- retrieve_historical("BND", "01", "E", date_range[i], date_range[i+1])
  bnd_01_2010_2017 <- rbind(bnd_01_2010_2017, tempdf)

}
write.csv(bnd_01_2010_2017, "data/bnd_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

# sens 20
tempdf <- data.frame()
bnd_20_2010_2017 <- data.frame()
for (i in seq_along(date_range)) {
  if (i == length(date_range)) {
    break
  }
  cat("retrieving range: ", date_range[i], " : ", date_range[i+1], "\n")
  tempdf <- retrieve_historical("BND", "20", "E", date_range[i], date_range[i+1])
  bnd_20_2010_2017 <- rbind(bnd_20_2010_2017, tempdf)

}
write.csv(bnd_20_2010_2017, "data/bnd_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)
