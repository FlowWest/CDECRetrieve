# # Year Type Classification:     Index based on flow in million acre-feet:
# #   Wet                      Equal to or greater than 9.2
# # Above Normal             Greater than 7.8, and less than 9.2
# # Below Normal             Greater than 6.5, and equal to or less than 7.8
# # Dry                      Greater than 5.4, and equal to or less than 6.5
# # Critical                 Equal to or less than 5.4
#
# cdec_sac_wy_table <- function() {
#       wy_index_url <- cdec_urls$wy_index
#
#       html_page <- xml2::read_html(wy_index_url)
#       html_pre_section <- rvest::html_text(rvest::html_nodes(html_page, css = "pre"))
#
#       raw <- unlist(strsplit(html_pre_section, "\n"))
#
#       start_of_index_table <-
#         which(stringr::str_detect(raw, "SACRAMENTO VALLEY WATER YEAR TYPE INDEX  40-30-30   \\(SVI\\)"))
#
#       raw_table <- raw[start_of_index_table:(start_of_index_table + 8)]
#
#
#       this_sep <- "       "
#
#       cdec_table <- strsplit(raw_table[5:9], split = this_sep) %>%
#         purrr::map_df(function(line) {
#           line <- trimws(line)
#           tibble::tibble(
#             date_string = line[1],
#             `99` = line[2],
#             `90` = line[3],
#             `75` = line[4],
#             `50` = line[5],
#             `25` = line[6],
#             `10` = line[7]
#           )
#         }) %>%
#         tidyr::gather(probability, index, `99`:`10`) %>%
#         transmute(
#           date = lubridate::mdy(date_string),
#           probability = as.numeric(probability),
#           index = as.numeric(index))
#
#       cdec_table %>%
#         mutate(classification = case_when(
#           index >= 9.2 ~ "wet",
#           index > 7.8 ~ "above normal",
#           index > 6.5 ~ "below normal",
#           index > 5.4 ~ "dry",
#           index <= 5.4 ~ "critical",
#           TRUE ~ as.character(NA)
#         ))
#
#
# }
#
#
# current_wy_index <- cdec_sac_wy_table()
#
# readr::write_rds(current_wy_index, "~/Projects/sho-wr/misc/data/2018-04-17-water-year-index.rds")
# readr::write_rds(CDECRetrieve::sac_valley_wy_types, "~/Projects/sho-wr/misc/data/historical-water-year-index.rds")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
