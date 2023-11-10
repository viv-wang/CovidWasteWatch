
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CovidWasteWatch

<!-- badges: start -->
<!-- badges: end -->

## Description

`CovidWasteWatch` is an R package for analysis and visualization of
COVID-19 wastewater viral signal and variant frequency data. Using
user-provided, pre-processed data, this package aims to provide users
with various statistical backgrounds a simple and efficient way to
observe trends in COVID-19 viral signal levels and variant frequencies
over time, along with options to visualize supplementary data such as
reported cases and mortality from public sources. `CovidWasteWatch` was
developed using `R version 4.3.1`,
`Platform:`x86_64-w64-mingw32/x64on`, and`Running under: Windows 11
x64\`.

## Installation

To install the latest version of the package:

``` r
require("devtools")
devtools::install github("viv-wang/CovidWasteWatch", build vignettes = TRUE)
library("CovidWasteWatch")
```

To run the shinyApp: Under construction

## Overview

Provide the following commands, customized to your R package. Then
provide an overview to briefly describe the main components of the
package. Include one image illustrating the overview of the package,
that shows the inputs and outputs. Ensure the image is deposited in the
correct location, as discussed in class. Point the user to vignettes for
a tutorial of your package.

``` r
ls("package:CovidWasteWatch")
data(package = "CovidWasteWatch") # optional
browseVignettes("CovidWasteWatch") 
```

`CovidWasteWatch` provides \_\_ functions:

- 
- 
- 

For tutorials demonstrating these functions, please see the vignettes.

## Contributions

This package was developed by Vivian Wang, who formed the concept and
wrote the code.

Provide a note clearly indicating contributions from you and
contributions from other packages/sources for each function. Remember
your individual contributions to the package are important.

## References

Provide full references for all sources used, including for the packages
mentioned under ‘Contributions’, in one specific format.

## Acknowledgements

This package was developed as part of an assessment for 2023 BCB410H:
Applied Bioinformatics course at the University of Toronto, Toronto,
CANADA. CovidWasteWatch welcomes issues, enhancement requests, and other
contributions. To submit an issue, use the GitHub issues.
