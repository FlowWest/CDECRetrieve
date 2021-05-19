library(testthat)

test_that("cdec_rt() errors when a station does not have a rating table", {
  expect_error(cdec_rt("EMM"), "rating table not found for: EMM")
})

test_that("cdec_rt() returns a df when a station has a rating table", {
  expect_is(cdec_rt("ABJ"), c("tbl_df", "tbl", "data.frame"))
})


