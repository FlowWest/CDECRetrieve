# need to gather the rating cols, and then sep on "_" then use the decimal part
# to add to the stage, and then this should just give the result that we want.


#' Get a rating table
#' Use  station id to find the rating table for the station
#' @param station_id three letter CDEC station id
#' @return dataframe of rating table
#' @example
#' cdec_rt("abj")
#' @export
cdec_rt <- function(station_id) {
  if (!rating_is_available(station_id)) {
    stop(paste0("rating table not found for: ", station_id), call. = FALSE)
  }

  rating_table_url <- paste0(cdec_urls$rating_tables, toupper(station_id), ".html")

  rating_table_page <- xml2::read_html(rating_table_url)
  raw_rating_table <- rvest::html_table(rvest::html_node(rating_table_page, "table"),
                                    fill = TRUE, header = FALSE)

  colnames_to_be <- paste0("rating_", as.character(raw_rating_table[2, ]))
  rating_table <- raw_rating_table[-c(1, 2), ]
  # process all columns as numerics
  rt <- suppressWarnings(dplyr::bind_cols(lapply(rating_table, as.numeric)))
  colnames(rt) <- colnames_to_be
  rt <- rt[!is.na(rt$`rating_Stage (feet)` ), ] #ugh ill make pretty later
  rt_gathered <- tidyr::gather(rt, dummy, value, -`rating_Stage (feet)`)
  rt_sep <- tidyr::separate(rt_gathered, dummy, into=c("dummier", "precision"), sep="_")
  rt_mutate <- dplyr::mutate(rt_sep, rating_stage = `rating_Stage (feet)` + as.numeric(precision))


  return(dplyr::select(rt_mutate, rating_stage, flow=value))
}

#' @title List Rating Tables
#' @description Get a list of all rating tables available through CDEC
#' @param station_id station for the location to get rt for
#' @examples
#' # list all rating tables in CDEC, you can use filter to search
#' cdec_rt_list()
#' @export
cdec_rt_list <- function(station_id = NULL) {
  url <- cdec_urls$rating_tables
  html_page <- xml2::read_html(url)
  list_of_tables <- rvest::html_table(rvest::html_node(html_page, "table"))



  rts <- tibble::tibble(
    station_name = tolower(list_of_tables$Station),
    station_id = tolower(list_of_tables$ID),
    last_revised = lubridate::mdy(list_of_tables$`Last Revised`),
    table_type = tolower(list_of_tables$`Table Type`)
  )

  if (is.null(station_id)) return(rts)
  else return(dplyr::filter(rts, station_id == station_id))

}


# Internal
rating_is_available <- function(station) {
  rts <- cdec_rt_list()
  tolower(station) %in% rts$station_id
}
