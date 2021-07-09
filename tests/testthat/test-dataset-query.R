context("Dataset Query")
library(CDECRetrieve)

test_that("a response from CDEC happens", {
  d <- cdec_datasets("kwk")
  expect_gt(nrow(d), 0)
})

test_that("errors when incorrect station id is provided", {
  expect_error(cdec_datasets("zzz"), "CDEC datasets service returned no data for 'zzz'")
})

test_that("errors when no query is supplied", {
  expect_error(cdec_datasets())
})

