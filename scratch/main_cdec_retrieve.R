# enough of this lets write a damn function!!!!!!!!!!!
# function will take a date range sequence borken up by years
cdec_big_query <- function(station_id, sens_no, dur_code, date_seq) {
  resp_df <- data.frame()
  for (i in seq_along(date_seq)) {
    if (i == length(date_seq)) {
      break
    }
    cat("retrieving range: ", date_seq[i], " : ", date_seq[i+1], " -- ",i/length(date_range) * 100,"%\n")
    temp_df <- retrieve_historical(station_id, sens_no, dur_code,
                                   date_seq[i], date_seq[i+1])
    resp_df <- rbind(resp_df, temp_df)

  }

  return(resp_df)
}


# KWK -----------------------------------------------------------------------------
kwk_01_2010_2016 <- cdec_big_query("KWK", "01", "E", date_range)
kwk_20_2010_2016 <- cdec_big_query("KWK", "20", "E", date_range)

write.csv(kwk_01_2010_2016, "data/kwk_01_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(kwk_20_2010_2016, "data/kwk_20_2010-01-01_2017-01-01.csv", row.names = FALSE)

# FRE ---------------------------------------------------------------------------
fre_01_2010_2016 <- cdec_big_query("FRE", "01", "E", date_range)
fre_20_2010_2016 <- cdec_big_query("FRE", "20", "E", date_range)

write.csv(fre_01_2010_2016, "data/fre_01_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(fre_20_2010_2016, "data/fre_20_2010-01-01_2017-01-01.csv", row.names = FALSE)

# BND ------------------------------------------------------------------------------
bnd_01_2010_2016 <- cdec_big_query("BND", "01", "E", date_range)
bnd_20_2010_2016 <- cdec_big_query("BND", "20", "E", date_range)

write.csv(bnd_01_2010_2016, "data/bnd_01_2010-01-01_2017-01-01.csv")
write.csv(bnd_20_2010_2016, "data/bnd_20_2010-01-01_2017-01-01.csv")

# MLM --------------------------------------------------------------------------

mlm_01_2010_2016 <- cdec_big_query("MLM", "01", "E", date_range)
mlm_20_2010_2016 <- cdec_big_query("MLM", "20", "E", date_range)

write.csv(mlm_01_2010_2016, "data/mlm_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(mlm_20_2010_2016, "data/mlm_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)


# MCM --------------------------------------------------------------------------

mch_01_2010_2016 <- cdec_big_query("MCH", "01", "E", date_range)
mch_20_2010_2016 <- cdec_big_query("MCH", "20", "E", date_range)

write.csv(mch_01_2010_2016, "data/mch_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(mch_20_2010_2016, "data/mch_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

# DCV -------------------------------------------------------------------------

dcv_01_2010_2016 <- cdec_big_query("DCV", "01", "E", date_range)
dcv_20_2010_2016 <- cdec_big_query("DCV", "20", "E", date_range)

write.csv(dcv_01_2010_2016, "data/dcv_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(dcv_20_2010_2016, "data/dcv_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

# DVD ---------------------------------------------------------------------------

dvd_01_2010_2016 <- cdec_big_query("DVD", "01", "E", date_range)
dvd_20_2010_2016 <- cdec_big_query("DVD", "20", "E", date_range)

# VNO --------------------------------------------------------------------------

vno_01_2010_2016 <- cdec_big_query("VNO", "01", "E", date_range)
vno_20_2010_2016 <- cdec_big_query("VNO", "20", "E", date_range)

# HMC --------------------------------------------------------------------------

hmc_01_2010_2016 <- cdec_big_query("HMC", "01", "E", date_range)
hmc_20_2010_2016 <- cdec_big_query("HMC", "20", "E", date_range)

write.csv(hmc_01_2010_2016, "data/hmc_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(hmc_20_2010_2016, "data/hmc_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

# ORD --------------------------------------------------------------------------

##############################################################################
# obj <- ls()
# obj[grepl("2010_(2017|2016)", obj)]
# e.t <- do.call(rbind,)
#
# df_list <- lapply(obj[grepl("2010_(2017|2016)", obj)], get)
#
# fullest_of_the_fulles <- do.call(rbind, df_list)
###############################################################################

kwk<- retrieve_historical("KWK", "01", "E", "2010-01-01", "2010-01-02")






ord_01_2010_2016 <- cdec_big_query("ORD", "01", "E", date_range)
ord_20_2010_2016 <- cdec_big_query("ORD", "20", "E", date_range)

write.csv(ord_01_2010_2016, "ord_01_E_2010-01-01_2017-01-01.csv", row.names = FALSE)
write.csv(ord_20_2010_2016, "ord_20_E_2010-01-01_2017-01-01.csv", row.names = FALSE)

















