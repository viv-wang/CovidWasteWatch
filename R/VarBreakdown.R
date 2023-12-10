# Purpose: Load and provide overview of input variant frequency data
# Author: Vivian Wang
# Date: 2023-11-08
# Version: 0.1.0
# Bugs and Issues: None

#' Loads and provides overview of variant frequency data
#'
#' A function that extracts relevant data from the file, calculates the number of
#' unique variants and groups variants by parents, and plots the variant
#' breakdown over time.
#'
#' @param fileVariant A name/path of the variant data file
#' @param parentVariants A Boolean indicating whether the data contains a
#'     parent variants column.
#'
#' @return Returns a results list containing the number of unique variants
#' and, if parent column exists, the list of variants grouped by parents.
#'
#' @examples
#' filepath <- system.file("extdata", "variant_input_data.csv", package = "CovidWasteWatch")
#' results <- VarBreakdown(fileVariant = filepath)
#' results
#'
#' @references
#' Bengtsson, H (2022). R.utils: Various Programming Utilities.
#' https://henrikbengtsson.github.io/R.utils/
#'
#' Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis.
#' Springer-Verlag New York. ISBN 978-3-319-24277-4. https://ggplot2.tidyverse.org
#'
#' Wickham, H., François, R., Henry, L., Müller, K., Vaughan, D. (2023).
#' dplyr: A Grammar of Data Manipulation. https://dplyr.tidyverse.org
#'
#' @export
#' @import utils
#' @import dplyr
#' @import ggplot2
VarBreakdown <- function(fileVariant = NA, parentVariants = TRUE) {
  # Check user input
  if (is.na(fileVariant)) {
    stop("File path not provided.")
  } else if (!file.exists(fileVariant)) {
    stop("File does not exist at the given path.")
  } else {
    ;
  }

  # Save data in a dataframe
  data <- utils::read.csv(file = fileVariant, header = TRUE)

  # Check required columns exist
  if (!("date" %in% colnames(data))) {
    stop("Column 'date' not provided or named correctly.")
  }
  if (!("variant" %in% colnames(data))) {
    stop("Column 'variant' not provided or named correctly.")
  }
  if (parentVariants == TRUE && (!("parent" %in% colnames(data)))) {
    stop("Column 'parent' not provided or named correctly.")
  }

  # Keep only required columns
  if (parentVariants == TRUE) {
    data <- subset(data, select = c(date, variant, parent, proportion))
  } else {
    data <- subset(data, select = c(date, variant, proportion))
  }

  # Sort rows from least to most recent date
  data$date <- as.Date(data$date)
  data <- data %>% dplyr::arrange(date)

  # Calculate number of unique variants
  numVar <- length(unique(data$variant))

  # If parent column exists, group unique variants by parents, then save in
  # a dataframe
  if (parentVariants == TRUE) {
    varParents <- as.data.frame(data %>% dplyr::group_by(parent) %>%
                                  dplyr::summarize(variants = list(unique(variant))))
  } else {
    varParents <- "Parent variants not provided."
  }

  # Plot variant breakdown
  plot <- PlotVarBreakdown(data)

  results <- list(numVariants = numVar, variantsByParents = varParents,
                  plotVariant = plot)
  return(results)
}

# [END]
