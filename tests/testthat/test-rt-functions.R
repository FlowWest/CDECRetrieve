# EXAMPLE VCR USAGE: RUN AND DELETE ME

foo <- function() crul::ok('https://httpbin.org/get')

test_that("cdec_rt() errors when a station does not have a rating table", {
  expect_error(cdec_rt("EMM"), "rating table not found for: EMM")
})
