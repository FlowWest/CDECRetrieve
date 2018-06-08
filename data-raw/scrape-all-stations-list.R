library(xml2)
library(rvest)
library(magrittr)
library(stringr)
library(purrr)

stations <- "http://cdec.water.ca.gov/dynamicapp/staMeta?station_id=" %>%
  read_html() %>%
  html_nodes("pre") %>%
  html_text() %>%
  str_split("\n") %>%
  .[[1]] %>%
  map_df(function(x) {
    if (x == "" || x == "    ") {
      return()
    }
    s <- str_match(trimws(x), "([0-9a-zA-Z]{3}) (.+)")

    tibble::tibble(
      code = s[, 2],
      name = s[, 3]
    )

  })


devtools::use_data(stations, overwrite = TRUE)
