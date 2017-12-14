#' @title Download b120 Data
#' @description Download Bulletin 120 Data from CDEC. This interface just grabs the latest
#' version, parses it and returns a tibble.
b120 <- function(location=NULL) {
  base_url <- cdec_urls$b120

  html_in_mem <- xml2::read_html(base_url)
  xml_text <- rvest::html_nodes(html_in_mem, "pre")
  raw_text <- rvest::html_text(xml_text)
}


# INTERNAL

b120_parser <- function(raw_text) {
  for (i in seq_len(length(raw_text))) {
    line <- raw_text[i]
    if (is_skippable(line)) next
    if (is_table_name(line)) {
      location_name <-
        unlist(strsplit(line, " "))[nzchar(unlist(strsplit(line, " ")))][1:2]
    } else {
      split_line <- unlist(strsplit(line, " "))[nzchar(unlist(strsplit(line, " ")))]
      args_n <- length(split_line)
    }
  }
}

is_skippable <- function(ch) {
  if (!nzchar(ch))
    return(TRUE)

  skippable_regex <- "--$|^B120|^DEPARTMENT|^WATER SUPPLY|^California Cooperative"
  grepl(skippable_regex, ch)
}

is_table_name <- function(ch) {
  header_regex <- ".+River.+|.+Lake.+"
  grepl(header_regex, ch)
}

is_table_header <- function(ch) {

}

b120_parse_header <- function(ch) {

}



