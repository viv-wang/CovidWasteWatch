# Purpose: Load and provide overview of input viral signal data
# Author: Vivian Wang
# Date: 2023-11-08
# Version: 0.1.0
# Bugs and Issues: None

# Declare global variables to prevent CMD check note
globalVariables(c("proportion", "cf", "signal", "variant", "parent"))

#' Loads and provides overview of viral signal data
#'
#' A function that extracts relevant data from the file, calculates the number of
#' unique timepoints and average rate of change per day, and plots the viral
#' signal over time.
#'
#' @param fileSignal A name/path of the viral signal data file
#'
#' @return Returns a results list containing the number of timepoints,
#' average rate of change per day, and a plot of the data.
#'
#' @examples
#' filepath <- system.file("extdata", "viral_signal_input_data.csv", package = "CovidWasteWatch")
#' results <- ViralSignal(fileSignal = filepath)
#' results
#'
#' @references
#' Bengtsson, H. (2022). R.utils: Various Programming Utilities.
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
ViralSignal <- function(fileSignal = NA) {
  # Check user input
  if (is.na(fileSignal)) {
    stop("File name not provided.")
  } else if (!file.exists(fileSignal)) {
    stop("File does not exist at the given path.")
  } else {
    ;
  }

  # Save data in a dataframe
  data <- utils::read.csv(file = fileSignal, header = TRUE)

  # Check required columns exist
  if (!("date" %in% colnames(data))) {
    stop("Column 'date' not provided or named correctly.")
  }
  if (!("signal" %in% colnames(data))) {
    stop("Column 'signal' not provided or named correctly.")
  }

  # Keep only required columns
  data <- subset(data, select = c(date, signal))

  # Sort rows from least to most recent date
  data$date <- as.Date(data$date)
  data <- data %>% dplyr::arrange(date)

  # Calculate number of timepoints
  numTP <- length(unique(data$date))

  # Calculate average rate of change per day
  changePerDay <- diff(data$signal, na.rm = TRUE) / as.numeric(diff(data$date))
  avgChangePerDay <- mean(changePerDay, na.rm = TRUE)

  # Plot viral signal over time
  plot <- PlotViralSignal(data)

  results <- list(numTimepoints = numTP, avgRateOfChangePerDay = avgChangePerDay,
                  plotSignal = plot)
  return(results)
}

# [END]
