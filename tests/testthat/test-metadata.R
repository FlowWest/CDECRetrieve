context("Station Metadata")

test_that("get_station_metadata returns", {
  expect_true(nrow(get_station_metadata("CCR")) > 0 )
  expect_error(get_station_metadata("123"))
})
