library(testthat)

test_that("cdec_rt() errors when a station does not have a rating table", {
  expect_error(cdec_rt("XXX"), "Could not reach CDEC services")
})

test_that("cdec_rt() returns a df when a station has a rating table", {
  expect_is(cdec_rt("ABJ"), c("tbl_df", "tbl", "data.frame"))
})

test_that("cdec_rt() returns the expected columns", {
  expect_equal(colnames(cdec_rt("ABJ")), c("revised_on", "rating_stage", "flow"))
  expect_equal(class(cdec_rt("ABJ")$revised_on), "Date")
  expect_equal(class(cdec_rt("ABJ")$rating_stage), "numeric")
  expect_equal(class(cdec_rt("ABJ")$flow), "numeric")

})

test_that("cdec_rt() returns a dataframe of stations", {
  expect_is(cdec_rt_list(), c("tbl_df", "tbl", "data.frame"))
  expect_equal(colnames(cdec_rt_list()), c("station_name", "station_id", "last_revised", "table_type"))
})
