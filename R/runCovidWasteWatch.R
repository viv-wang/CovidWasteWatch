# Purpose: Launch Shiny App for CovidWasteWatch
# Author: Vivian Wang
# Date: 2023-12-08
# Version: 0.1.0
# Bugs and Issues: None

#' Launch Shiny App for CovidWasteWatch
#'
#' A function that launches the Shiny app for CovidWasteWatch.
#' The code has been placed in \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'   CovidWasteWatch::CovidWasteWatch()
#' }
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials. \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp

runCovidWasteWatch <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "CovidWasteWatch")
  actionShiny <- shiny::runApp(appDir, display.mode = "normal")
  return(actionShiny)
}

# [END]
