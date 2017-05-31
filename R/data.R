#' The set of CDEC Codes as reported by CDEC
#'
#' A dataset containing all of the cdec codes, along with
#' other useful iformation including the units of measure for each
#'
#' @name sensors
#' @docType data
#' @source \url{http://cdec.com}
#' @format A data frame cotnaining description to sensors used in CDEC
#' \describe{
#'     \item{sensor_no}{sensor number used in CDEC gage data}
#'     \item{sensor_name}{sensor name corresponding to sensor number}
#'     \item{description}{short description of the sensor}
#'     \item{unit}{the unit of measurement used for the sensor}
#' }
#' @keywords data
NULL

#' Function does a simple search for terms in description
#' @param term a search term to query for
#' @examples
#' temperature_sensors <- search_sensors("temperature")
#'
#' @return data frame with filtered search results
#' @export
search_sensors <- function(term) {
    sensors[stringr::str_detect(sensors$description, term), ]
}
