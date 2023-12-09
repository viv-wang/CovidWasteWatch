# Purpose: Plot viral variant breakdown data
# Author: Vivian Wang
# Date: 2023-11-08
# Version: 0.1.0
# Bugs and Issues: None

#' Plots variant frequency data as a stacked bar plot that shows the variant
#' breakdown for each timepoint
#'
#' A function that plots variant frequency data from a pre-processed dataframe and
#' titles the plot with the time frame of the data points.
#'
#' @param varData A dataframe containing variant frequency data with the
#'            columns 'date', 'variant', 'proportion', and optionally 'parent'
#'
#' @return Returns a plot of the variant breakdown over time.
#'
#' @examples
#' plot <- PlotVarBreakdown(VariantDF)
#' plot
#'
#' @references
#' Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis.
#' Springer-Verlag New York. ISBN 978-3-319-24277-4. https://ggplot2.tidyverse.org
#'
#' @export
#' @import ggplot2
PlotVarBreakdown <- function(varData = NA) {
  # Get earliest and latest date
  varData$date <- as.Date(varData$date) # Confirm format
  earliestDate <- min(varData$date)
  latestDate <- max(varData$date)

  if (("parent" %in% colnames(varData))) {
    # Make combined factors for parent-variant pairs
    varData$cf <- factor(paste(varData$parent, varData$variant, sep = " - "),
                         levels = unique(paste(varData$parent,
                                               varData$variant, sep = " - ")))

    # Create a ggplot object for a stacked bar graph
    plot <- ggplot(varData, aes(x = date, y = proportion, fill = cf)) +
      geom_bar(stat = "identity") +
      labs(title = paste("Viral variant breakdown from", earliestDate,
                         "to", latestDate),
           x = "Date",
           y = "Percentage of samples",
           fill = "Variant") +
      theme(legend.position = "top")  # Move legend to the top
  } else {
    # Create a ggplot object for a stacked bar graph
    plot <- ggplot(varData, aes(x = date, y = proportion, fill = variant)) +
      geom_bar(stat = "identity") +
      labs(title = paste("Viral variant breakdown from", earliestDate,
                         "to", latestDate),
           x = "Date",
           y = "Percentage of samples",
           fill = "Variant") +
      theme(legend.position = "top")  # Move legend to the top
  }
  return(plot)
}

# [END]
