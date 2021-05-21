context("Station Search")
library(CDECRetrieve)

test_that("cdec_stations returns an error when you enter an invalid station_id", {
  expect_error(cdec_stations("XXX"), "request returned no data, please check input values")
})

test_that("cdec stations returns a dataframe when you enter a valid station id", {
  expect_is(cdec_stations(station_id = "EMM"), c("tbl_df", "tbl", "data.frame"))
})

test_that("cdec station errors when nearby_city invalid", {
  expect_error(cdec_stations(nearby_city = "XXXX"))
})
