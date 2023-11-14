# Purpose: Load data and provide statistical and graphical overview
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
#' Bengtsson, H (2022). R.utils: Various Programming Utilities.
#'https://henrikbengtsson.github.io/R.utils/.
#'
#' Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis.
#' Springer-Verlag New York. ISBN 978-3-319-24277-4. https://ggplot2.tidyverse.org
#'
#' Wickham H, François R, Henry L, Müller K, Vaughan D. (2023).
#' dplyr: A Grammar of Data Manipulation. https://dplyr.tidyverse.org.
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
#' https://henrikbengtsson.github.io/R.utils/.
#'
#' Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis.
#' Springer-Verlag New York. ISBN 978-3-319-24277-4. https://ggplot2.tidyverse.org
#'
#' Wickham H, François R, Henry L, Müller K, Vaughan D. (2023).
#' dplyr: A Grammar of Data Manipulation. https://dplyr.tidyverse.org.
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
