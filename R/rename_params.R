#' Function takes in a dataframe retrieved from CDECRetrieve::retrieve_station_data and renames columns to be more readable
#' @param .d dataframe obtained from calling CDECRetrieve::retrieve_station_data
#' @return a new data frame with renamed human readable columns
#' @examples
#' rename_params(retrieve_station_data("kwk", "20", "H", "2017-01-01"))
#'
#' @export
rename_params <- function(.d) {
  lookup_val <- .d$parameter_cd[1]
  param_meta <- dplyr::filter(param_to_name_lookup, param_code == lookup_val)

  param_name <- rep(param_meta$param_name[1], nrow(.d))
  param_units <- rep(param_meta$param_units[1], nrow(.d))

  return(data.frame(.d, param_name=param_name, param_units=param_units))
}

param_to_name_lookup <- tibble::tribble(
  ~param_code, ~param_name, ~param_units,
  "20H", "flow", "cfs",
  "25H", "temperature", "deg_f"
)
