is_cdec_data <- function(.) {
  identical(get_cdec_serivce(.), "cdec_data")
}

is_cdec_dataset <- function(.) {
  identical(get_cdec_serivce(.), "cdec_datasets")
}

is_cdec_meta <- function(.) {
  identical(get_cdec_serivce(.), "cdec_meta")
}

is_cdec_station <- function(.) {
  identical(get_cdec_serivce(.), "cdec_stations")
}

get_cdec_serivce <- function(o) {
  return(attr(o, "cdec_service"))
}


# display error that are informative to the user

missing_xml <- function(.) {
  identical(., xml2::xml_missing())
}

locate_and_replace_in_place <- function(string, v) {
  re <- paste(names(v), collapse = "|")
  for (i in seq_along(v)) {
    string <- stringr::str_replace(string, names(v[i]), v[[i]])
  }

  return(string)
}
