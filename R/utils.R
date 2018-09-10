cdec_status_check <- function() {
  e <- 0
  tryCatch(
    r <- suppressMessages(cdec_query("kwk", "20", "h", Sys.Date())),
    error = (e <- 1)
  )

  if (e) {
    warning("It looks like CDEC is down! We used Keswick, Flow, Hourly to test", call. = FALSE)
    invisible(list(

    ))
  } else {
    message("CDEC looks good")
    invisible(e)
  }
}

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


