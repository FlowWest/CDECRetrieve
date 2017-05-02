# Title: Rename Parameters
# Author: Emanuel Rodriguez
# Date: Tue May  2 09:59:47 2017
# Description: A utility function to rename parameters codes to a readable format
# ----------------------

#' Function takes in a dataframe retrieved from CDECRetrieve::retrieve_station_data
#' and renames columns to be more readable
#' @param .d dataframe obtained from calling CDECRetrieve::retrieve_station_data
#' @export
rename_params <- function(.d) {
  param_code <- .d$parameter_cd[1]
  param_meta <- filter(param_to_name_lookup, param_code == param_code)
  return(param_meta)
}


param_to_name_lookup <- tibble::tribble(
  ~param_code, ~param_name, ~param_units,
  "20H", "flow", "cfs",
  "25H", "temperature", "deg_f"
)
