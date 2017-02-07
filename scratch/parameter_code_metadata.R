library(stringr)
library(lubridate)
library(dplyr)

parse_codes <- function(line) {
  rownames(line) <- NULL
  line$sens_no <- as.character(line$sens_no)
  line$unit <- str_extract_all(line$sens_name, "\\(.+\\)") %>%
    str_replace_all("\\(|\\)", "") %>% trimws() %>%
    as_vector()
  line$sens_name <- str_replace_all(tolower(line$sens_name), ",|\\(.+\\)", "") %>%
    trimws()
  line$measure_type <- str_replace_all(line$measure_type, "\\(|\\)", "") %>%
    trimws()

  return(line[,c(1:2, 7)])
}

build_parm_codes_table <- function(location) {


  all_codes <- map(location, cdec_historical_data_meta) %>% bind_rows()

  # basic parsing of the response
  all_codes <- distinct(parse_codes(all_codes))

  return(all_codes)
}

save_parm_codes_table <- function(location="../../data/cdec_parm_codes.csv") {
  write.table(cdec_parm_codes, file = location,
              quote = FALSE, sep = ",", col.names = FALSE, row.names = FALSE)
}








