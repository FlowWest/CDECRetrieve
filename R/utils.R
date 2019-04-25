#' @title Keyword Search
cdec_search <- function(station_id, keyword) {
  d <- suppressWarnings(cdec_datasets(station_id))
  d %>% filter(str_detect(sensor_name, keyword))
}
