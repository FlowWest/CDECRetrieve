context("CDEC Query")
library(CDECRetrieve)

test_that("a response from CDEC happens", {
  d <- cdec_query("kwk", "20", "h", "2018-03-01")
  expect_gt(nrow(d), 0)
})

test_that("the colnames are correct", {
  d <- cdec_query("kwk", "20", "h", "2018-03-01")
  expect_equal(colnames(d), c("agency_cd", "location_id", "datetime", "parameter_cd", "parameter_value"))
})

test_that("errors on bad query", {
  expect_error(cdec_query("kwkl", "20", "h", "2018-03-01"))
})
