raw_lines <- readLines("data-raw/water-year-index-2018.txt")

list_lines <- strsplit(raw_lines[6:length(raw_lines)], " ")



# sac valley
sac_valley_wy_types <- purrr::map_df(list_lines, function(line) {
  chars_in_line <- line[line != ""]
  chars_in_line[1:6]

  tibble::tibble(
    year = as.integer(chars_in_line[1]),
    oct_mar = as.numeric(chars_in_line[2]),
    apr_jul = as.numeric(chars_in_line[3]),
    wy_sum = as.numeric(chars_in_line[4]),
    wy_index = as.numeric(chars_in_line[5]),
    yr_type = chars_in_line[6]
  )
})

# san joaquin valley
san_joaquin_wy_types <- purrr::map_df(list_lines, function(line) {
  chars_in_line <- line[line != ""]
  chars_in_line[c(1, 7:11)]

  tibble::tibble(
    year = as.integer(chars_in_line[1]),
    oct_mar = as.numeric(chars_in_line[2]),
    apr_jul = as.numeric(chars_in_line[3]),
    wy_sum = as.numeric(chars_in_line[4]),
    wy_index = as.numeric(chars_in_line[5]),
    yr_type = chars_in_line[6]
  )
})




devtools::use_data(sac_valley_wy_types, overwrite = TRUE)
devtools::use_data(san_joaquin_wy_types, overwrite = TRUE)
