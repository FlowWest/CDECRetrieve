#' Get a rating table
#'
#' Use  station id to find the rating table for stage to flow used by CDEC.
#'
#' @param station_id three letter CDEC station id
#' @return dataframe of rating table, with stage (feet) and flow (cfs) as columns
#' @examples
#' \dontrun{
#' cdec_rt("abj") # get the stage to rating curve for ABJ
#' }
#' @export
cdec_rt <- function(station_id) {

  rating_table_url <- url(sprintf("http://cdec.water.ca.gov/rtables/%s.html",
                                  toupper(station_id)))

  rating_table_page <- tryCatch(xml2::read_html(rating_table_url),
                                error = function(e){
                                  if (e$message == "HTTP error 404.") {
                                    close(rating_table_url)
                                    stop("Could not reach CDEC services, check station.", call. = FALSE)
                                  } else {
                                    close(rating_table_url)
                                    stop("Could not reach CDEC services", call. = FALSE)}
                                })
  raw_rating_table <- rvest::html_table(rvest::html_node(rating_table_page, "table"),
                                        fill = TRUE, header = FALSE)


  rating_table_revised_on <-
    rating_table_page %>%
    rvest::html_nodes("h3") %>%
    rvest::html_text() %>%
    magrittr::extract(2) %>%
    stringr::str_extract("[0-9]+/[0-9]+/[0-9]+") %>%
    as.Date("%m/%d/%Y")


  colnames_to_be <- paste0("rating_", as.character(raw_rating_table[2, ]))
  rating_table <- raw_rating_table[-c(1, 2), ]
  # process all columns as numeric
  rt <- suppressWarnings(dplyr::bind_cols(lapply(rating_table, as.numeric)))
  colnames(rt) <- colnames_to_be
  rt <- rt[!is.na(rt$`rating_Stage (feet)` ), ] #ugh ill make pretty later
  rt_gathered <- tidyr::gather(rt, "dummy", "value", -"rating_Stage (feet)")
  rt_sep <- tidyr::separate(rt_gathered, "dummy", into=c("dummier", "precision"), sep="_")

  rt_mutate <- rt_sep # copy, to not overwrite
  rt_mutate$rating_stage <- rt_sep$`rating_Stage (feet)` + as.numeric(rt_sep$precision)

  return(dplyr::transmute(rt_mutate, revised_on = rating_table_revised_on, rating_stage, flow = value))
}

#' @title List Rating Tables
#' @description Get a list of all rating tables available through CDEC
#' @param station_id station for the location to get rating description for.
#' @examples
#' # list all rating tables in CDEC, you can use filter to search
#' \dontrun{
#' cdec_rt_list()
#' }
#' @export
cdec_rt_list <- function(station_id = NULL) {
  url <- url("http://cdec.water.ca.gov/rtables/")
  html_page <- tryCatch(xml2::read_html(url),
                        error = function(e){
                          close(url)
                          stop("Could not reach CDEC services" , call. = FALSE)
                        })
  list_of_tables <- rvest::html_table(rvest::html_node(html_page, "table"))

  rts <- tibble::tibble(
    station_name = tolower(list_of_tables$Station),
    station_id = tolower(list_of_tables$ID),
    last_revised = lubridate::mdy(list_of_tables$`Last Revised`),
    table_type = tolower(list_of_tables$`Table Type`)
  )

  return(rts)

}
