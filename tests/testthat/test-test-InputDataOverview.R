library(CovidWasteWatch)
# Tests for all four functions in InputDataOverview.R

test_that("ViralSignal() returns correct output", {
    filepath <- system.file("extdata", "viral_signal_input_data.csv", package = "CovidWasteWatch")
    results <- ViralSignal(fileSignal = filepath)
    expect_type(results, "list")
    expect_equal(results$numTimepoints, 368)
    expect_equal(as.numeric(results$avgRateOfChangePerDay), 0.0001362398, tolerance = 1e-06)
})

test_that("VarBreakdown() returns correct output", {
  filepath <- system.file("extdata", "variant_input_data.csv", package = "CovidWasteWatch")
  results <- VarBreakdown(fileVariant = filepath)
  expect_type(results, "list")
  expect_equal(results$numVariants, 26)
  expect_length(results$variantsByParents, 2)
})

test_that("PlotViralSignal() does not mutate data", {
  data("ViralSignalDF")
  plot <- PlotViralSignal(signalData = ViralSignalDF)
  expect_identical(plot$data, ViralSignalDF)
})

test_that("PlotVarBreakdown() does not mutate original data", {
  data("VariantDF")
  plot <- PlotVarBreakdown(varData = VariantDF)
  expect_identical(plot$data$date, VariantDF$date)
  expect_identical(plot$data$variant, VariantDF$variant)
  expect_identical(plot$data$parent, VariantDF$parent)
})

# [END]
