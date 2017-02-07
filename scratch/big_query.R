library(CDECRetrieve)
library(magrittr)
library(rvest)
library(tidyr)
library(lubridate)

kwk <- CDECRetrieve::retrieve_historical("KWK", "01", "E",
                                         start_date = "2016-01-01", "2017-01-01")

date_range <- seq(ymd("2010-01-01"), ymd("2017-01-01"), by="year")
date_range2 <- seq(ymd("2011-05-01"), ymd("2017-01-01"), by = "year")

big_query <- function(station_id, sensor_no, dur_code="E", date_range) {
  resp_df <- data.frame()


  for (i in seq_along(date_range)) {
    if (i == length(date_range)) break
    temp_df <- CDECRetrieve::retrieve_historical(station_id, sensor_no, dur_code,
                                                 date_range[i], date_range[i+1])

    resp_df <- rbind(resp_df, temp_df)
  }
  return(resp_df)
}

col_nas <- function(df) {
  lapply(df, function(x) {
    sum(is.na(x))
  })
}

write_cdec_file <- function(dataset, filename) {
  write.table(dataset, filename, row.names = FALSE,
              col.names = FALSE, sep=",", quote = FALSE)
}

#kwk_01_E_2010_2017 <- big_query("KWK", "01", "E", date_range)
#fre_01_E_2010_2017 <- big_query("FRE", "01", "E", date_range)
#bnd_01_E_2010_2017 <- big_query("BND", "01", "E", date_range)
#bat_01_E_2010_2017 <- big_query("BAT", "01", "E", date_range)
#cwa_01_E_2010_2017 <- big_query("CWA", "01", "E", date_range)
#mlm_01_E_2010_2017 <- big_query("MLM", "01", "E", date_range)
#mch_01_E_2010_2017 <- big_query("MCH", "01", "E", date_range)
dvd_01_E_2010_2017 <- big_query("DVD", "01", "E", date_range) # <- error running this
#hmc_01_E_2010_2017 <- big_query("HMC", "01", "E", date_range)
#dcv_01_E_2010_2017 <- big_query("DCV", "01", "E", date_range) # <- a lot of na values
#dcv_01_E_2010_2017 <- dcv_01_E_2010_2017[which(!is.na(dcv_01_E_2010_2017$value)), ]
#vno_01_E_2010_2017 <- big_query("VNO", "01", "E", date_range2) # <- cdec error providing data
#ord_01_E_2010_2017 <- big_query("ORD", "01", "E", date_range)
bwc_01_E_2010_2017 <- big_query("BWC", "01", "E", date_range)

# from shasta down ------------------------------------------------------------
#sis_65_M_2010_2017 <- big_query("SIS", "65", "M",
#                                seq(ymd("1990-01-01"), ymd("2017-01-01"), by="year"))
#sis_66_M_2010_2017 <- big_query("SIS", "66", "M",
#                                seq(ymd("1990-01-01"), ymd("2017-01-01"), by="year"))
#kwk_20_E_2010_2017 <- big_query("KWK", "20", "E", date_range)
#sac_14_H_2015_2017 <- big_query("SAC", "14", "H",
#                                seq(ymd("2015-06-10"), ymd("2017-02-01"), by="month"))
#sac_14_H_2015_2017 <- sac_14_H_2015_2017[which(!is.na(sac_14_H_2015_2017$value)), ]
#sac_25_H_2015_2017 <- big_query("SAC", "25", "H",
#                                seq(ymd("2015-06-10"), ymd("2017-02-01"), by="month"))
# ccr_25_2010_2017 <- big_query("CCR", "25", "H",
#                               seq(ymd("2010-01-01"), ymd("2017-02-01"), by="year"))
# ccr_27_2010_2017 <- big_query("CCR", "27", "H",
#                               seq(ymd("2010-01-01"), ymd("2017-02-01"), by="year"))
# and_14_E_2015_2017 <- big_query("AND", "14", "E",
#                                 seq(ymd("2015-01-13"), ymd("2017-02-01"), by="month"))
# and_25_E_2015_2017 <- big_query("AND", "25", "E",
#                                 seq(ymd("2015-01-13"), ymd("2017-02-01"), by="month"))
# and_25_E_2015_2017 <- and_25_E_2015_2017[which(!is.na(and_25_E_2015_2017$value)), ]
# cwa_01_E_2010_2017 <- big_query("CWA", "01", "E", date_range)
# cwa_20_E_2010_2017 <- big_query("CWA", "20", "E", date_range)
#bnd_20_E_2010_2017 <- big_query("BND", "20", "E", date_range)
#jlf_25_H_2010_2017 <- big_query("JLF", "25", "H", date_range)
#jlf_25_H_2010_2017 <- jlf_25_H_2010_2017[!is.na(jlf_25_H_2010_2017$value), ]
#jlf_27_H_2010_2017 <- big_query("JLF", "27", "H", date_range)
#jlf_27_H_2010_2017 <- jlf_27_H_2010_2017[!is.na(jlf_27_H_2010_2017$value), ]
#jlf_61_H_2010_2017 <- big_query("JLF", "61", "H", date_range)
# rdf_01_E_2010_2017 <- big_query("RDF", "01", "E", date_range) # <- no data
# rdf_20_E_2010_2017 <- big_query("RDF", "20", "E", date_range) # <- no data
# rdb_01_H_2010_2017 <- big_query("RDB", "01", "H",
#                                 seq(ymd("2002-01-01"), ymd("2017-01-01"), by="year"))
# rdb_01_H_2010_2017 <- rdb_01_H_2010_2017[!is.na(rdb_01_H_2010_2017$value), ]

rdb_25_H_2010_2017 <- big_query("RDB", "25", "H", date_range)
rdb_27_H_2010_2017 <- big_query("RDB", "27", "H",
                                seq(ymd("2000-01-01"), ymd("2017-01-01"), by="year"))


#write.table(bnd_01_E_2010_2017, "../data/bnd_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(fre_01_E_2010_2017, "../data/fre_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(kwk_01_E_2010_2017, "../data/kwk_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(bat_01_E_2010_2017, "../data/bat_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(cwa_01_E_2010_2017, "../data/cwa_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(mlm_01_E_2010_2017, "../data/mlm_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(mch_01_E_2010_2017, "../data/mch_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(hmc_01_E_2010_2017, "../data/hmc_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(dcv_01_E_2010_2017, "../data/dcv_01_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(ord_01_E_2010_2017, "../data/ord_01_E_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")

# from shasta down --------------------------------------------------------------
#write.table(sis_65_M_2010_2017, "../data/sis_65_M_1990_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(sis_66_M_2010_2017, "../data/sis_66_M_1990_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(kwk_20_E_2010_2017, "../data/kwk_20_E_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(sac_14_H_2015_2017, "../data/sac_14_H_2015_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(sac_25_H_2015_2017, "../data/sac_25_H_2015_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(ccr_25_2010_2017, "../data/ccr_25_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(ccr_27_2010_2017, "../data/ccr_27_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(and_14_E_2015_2017, "../data/and_14_E_2015_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(and_25_E_2015_2017, "../data/and_25_E_2015_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(cwa_01_E_2010_2017, "../data/cwa_01_E_2010_2017", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(cwa_20_E_2010_2017, "../data/cwa_20_E_2010_2017", row.names = FALSE, col.names = FALSE, sep=",")
#write.table(bnd_20_E_2010_2017, "../data/bnd_20_E_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",")
# write.table(jlf_61_H_2010_2017, "../data/jlf_61_2010_2017.csv", row.names = FALSE, col.names = FALSE, sep=",", quote = FALSE)
# write_cdec_file(jlf_25_H_2010_2017, "../data/jlf_25_2010_2017.csv")
# write_cdec_file(jlf_27_H_2010_2017, "../data/jlf_27_2010_2017.csv")
write_cdec_file(rdb_01_H_2010_2017, "../data/rdb_01_H_2002_2017.csv")


















