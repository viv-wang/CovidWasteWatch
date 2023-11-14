#' COVID-19 Wastewater Viral Signal Dataframe
#'
#' A dataframe of viral signal data from COVID-19 wastewater surveillance in Ontario.
#' This is the expected resulting dataframe when "inst/extdata/viral_signal_input_data.csv"
#' is used as the input file for function ViralSignal.
#'
#' @source The dataset was downloaded from Public Health Ontario's website
#' https://www.publichealthontario.ca/en/Data-and-Analysis/Infectious-Disease/COVID-19-Data-Surveillance/Wastewater
#' which is updated weekly. The data included in this package contains data from
#' 2022-10-26 to 2023-10-28.
#'
#' @format A dataframe with two columns:
#' \describe{
#'  \item{date}{The date of samples in YYYY-MM-DD format.}
#'  \item{signal}{The signal level detected from samples.}
#' }
#' @examples
#' \dontrun{
#'  ViralSignalDF
#' }
"ViralSignalDF"

#' COVID-19 Viral Variant Breakdown Dataframe
#'
#' A dataframe of weekly variant proportion data in Canada.
#' This is the expected resulting dataframe when "inst/extdata/variant_input_data.csv"
#' is used as the input file for function VarBreakdown.
#'
#' @source The dataset was downloaded from Health Canada's website
#' https://health-infobase.canada.ca/covid-19/testing-variants.html
#' which is updated weekly. The dataset included in this package contains data
#' from 2023-08-27 to 2023-10-29.
#'
#' @format A dataframe with three columns:
#' \describe{
#'  \item{date}{The date of samples in YYYY-MM-DD format.}
#'  \item{variant}{The name of the variant detected.}
#'  \item{parent}{The name of the parent variant of the detected variant.}
#'  \item{proportion}{The proportion of the variant in the weekly samples, out of 1.}
#' }
#' @examples
#' \dontrun{
#'  VariantDF
#'  }
"VariantDF"


