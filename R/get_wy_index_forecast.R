con <- url("http://cdec.water.ca.gov/cgi-progs/iodir/wsi")

library(rvest)
library(purrr)

page <- read_html("http://cdec.water.ca.gov/cgi-progs/iodir/wsi")

# Grab raw text from html
get_raw_wy_text <- function() {
  raw_data <- page %>%
    html_node("pre") %>%
    html_text()
}

# Method for extracting is finding the tables that start with
# the word SACRAMENTO, then using todays date (month) extract
# those lines that contain the correct month forecast

get_wy_index_forecast <- function(forecast_month=format(Sys.Date(), format="%b 1, %Y"),
                                  raw_page=get_raw_wy_text()) {

  all_lines <- unlist(strsplit(raw_data, "\n"))

  # get lines corresponding to sacramento forecast data
  # not needed in this first version
  #start_of_tables <- stringr::str_detect(all_lines, "SACRAMENTO (RIVER|VALLEY)")

  col_headers <- all_lines[which(start_of_tables) + 2] # col headers if needed

  # forecast for a given month
  month_forecast <- stringr::str_detect(all_lines, forecast_month)

  if (sum(month_forecast) == 0) {
    stop(paste("No forecast match for:", forecast_month))
  }

  flat_month_forecast <- all_lines[month_forecast][2] %>%
    str_split("  ") %>%
    flatten_chr()
  flat_month_forecast
}

# find where the tables start
# find where the tables end


