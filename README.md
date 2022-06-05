
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openai

<!-- badges: start -->

[![R-CMD-check](https://github.com/irudnyts/openai/workflows/R-CMD-check/badge.svg)](https://github.com/irudnyts/openai/actions)
<!-- badges: end -->

The goal of openai is to …

## Installation

You can install the development version of openai from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("irudnyts/openai")
```

## Authentication

``` r
Sys.setenv(
    SPOTIFY_CLIENT_ID = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
)
```

``` r
usethis::edit_r_environ(scope = "project")
```

**Note:** If you are using GitHub/Gitlab, do not forget to add
`.Renviron` file to `.gitignore`!

## Example
