context("Station Search")
library(CDECRetrieve)

test_that("cdec_stations returns an error when you enter an invalid station_id", {
  expect_error(cdec_stations("XXX"), "request returned no data, please check input values")
})

test_that("cdec station errors when nearby_city invalid", {
  expect_error(cdec_stations(nearby_city = "XXXX"))
})

test_that("cdec stations returns a dataframe when you enter a valid station id", {
  expect_is(cdec_stations(station_id = "EMM"), c("tbl_df", "tbl", "data.frame"))
})

test_that("cdec stations returns a dataframe with at least one row", {
  expect_gt(nrow(cdec_stations(nearby_city = "Sacramento")), 0)
})

test_that("the colnames are correct", {
  d <- cdec_stations(station_id = "EMM")
  expect_equal(colnames(d), c("station_id", "name", "river_basin", "county", "longitude",
                              "latitude", "elevation", "operator", "state"))
})

