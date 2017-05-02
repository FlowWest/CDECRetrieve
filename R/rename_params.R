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
  lookup_val <- .d$parameter_cd[1]
  param_meta <- dplyr::filter(param_to_name_lookup, param_code == lookup_val)

  param_name <- rep(param_meta$param_name[1], nrow(.d))
  param_units <- rep(param_meta$param_units[1], nrow(.d))

  return(data.frame(.d, param_name=param_name, param_units=param_units))
}

#@TODO:implement --- finish creating the rest of DF or find a better way to use this
param_to_name_lookup <- tibble::tribble(
  ~param_code, ~param_name, ~param_units,
  "20H", "flow", "cfs",
  "25H", "temperature", "deg_f"
)
