#' @export
runapp <- function() {
  appDir <- system.file("shiny", package = "CDECRetrieve")
  shiny::runApp(appDir, display.mode = "normal")
}
