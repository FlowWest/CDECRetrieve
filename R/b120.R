#' @title Download b120 Data
#' @description Download Bulletin 120 Data from CDEC. This interface just grabs the latest
#' version, parses it and returns a tibble.
b120 <- function(location) {
  base_url <- cdec_urls$b120

  html_in_mem <- xml2::read_html(base_url)
  xml_text <- rvest::html_nodes(html_in_mem, "pre")
  raw_text <- rvest::html_text(xml_text)
  text_by_line <- unlist(strsplit(raw_text, "\n"))

  b120_header <- parse_b120_header(text_by_line[9])

  start_end <- table_start_end(text_by_line, location)

  location_raw <- text_by_line[start_end[1]:start_end[2]]

  location_raw
}


# INTERNAL

table_start_end <- function(raw_txt, location) {
  start <- which(grepl(location, raw_txt))
  end <- start + 3

  return(c(start, end))
}


strsplit(loc_text, "  ")

parse_b120_header <- function(line) {
  line_content <- line[grepl("[A-Za-z]{3}|[0-9]+", line)]
  line_dates <- line_content[!grepl("Avg", line_content)]
  line_m <- as.data.frame(matrix(line_dates, byrow = TRUE, ncol = 2))

  purrr::map_chr(seq_len(nrow(line_m)), function(i) {
    paste(line_m[i, ]$V1, line_m[i, ]$V2)
  })

}




x[!stringr::str_detect(x, "Avg")]
