# Purpose: Plot viral signal data
# Author: Vivian Wang
# Date: 2023-11-08
# Version: 0.1.0
# Bugs and Issues: None

#' Plots viral signal data as a line plot with dots marking each signal entry
#'
#' A function that plots viral signal data from a pre-processed dataframe and
#' titles the plot with the time frame of the data points.
#'
#' @param signalData A dataframe containing viral signal data with columns
#'                   'date' and 'signal'
#'
#' @return Returns a plot of the viral signal data over time.
#'
#' @examples
#' plot <- PlotViralSignal(ViralSignalDF)
#' plot
#'
#' @references
#' Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis.
#' Springer-Verlag New York. ISBN 978-3-319-24277-4. https://ggplot2.tidyverse.org
#'
#' @export
#' @import ggplot2
PlotViralSignal <- function(signalData = NA) {
  # Get earliest and latest date
  earliestDate <- min(signalData$date)
  latestDate <- max(signalData$date)

  # Plot viral signal data with time frame in title
  plot <- ggplot2::ggplot(signalData, aes(x = date, y = signal)) +
    geom_line() +  # Line plot
    geom_point() + # Add points
    labs(title = paste("Viral signal from", earliestDate, "to", latestDate),
         x = "Date",
         y = "Viral signal")

  return(plot)
}

# [END]
