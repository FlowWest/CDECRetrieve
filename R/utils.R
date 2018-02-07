is_cdec_data <- function(.) {
  identical(get_cdec_serivce(.), "cdec_data")
}

is_cdec_dataset <- function(.) {
  identical(get_cdec_serivce(.), "cdec_datasets")
}

is_cdec_meta <- function(.) {
  identical(get_cdec_serivce(.), "cdec_meta")
}


get_cdec_serivce <- function(o) {
  return(attr(o, "cdec_service"))
}

