
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openai <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/irudnyts/openai/workflows/R-CMD-check/badge.svg)](https://github.com/irudnyts/openai/actions)
[![Codecov test
coverage](https://codecov.io/gh/irudnyts/openai/branch/main/graph/badge.svg)](https://app.codecov.io/gh/irudnyts/openai?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/openai)](https://CRAN.R-project.org/package=openai)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/openai?color=brightgreen)](https://cranlogs.r-pkg.org/badges/grand-total/openai?color=brightgreen)
<!-- badges: end -->

## Overview

`{openai}` is an R wrapper of OpenAI API endpoints. This package covers
Engines, Completions, Edits, Files, Fine-tunes, Embeddings and legacy
Searches, Classifications, and Answers endpoints (will be removed on
December 3, 2022).

## Installation

The easiest way to install `{openai}` from CRAN is to use the “official”
`install.packages()` function:

``` r
install.packages("openai")
```

You can also install the development version of `{openai}` from
[GitHub](https://github.com/) with:

``` r
if (!require(remotes))
    install.packages("remotes")
remotes::install_github("irudnyts/openai")
```

## Authentication

To use the OpenAI API, you need to provide an API key. First, sign up
for OpenAI API on [this page](https://openai.com/api/). Once you signed
up and logged in, you need to open [this page](https://beta.openai.com),
click on **Personal**, and select **View API keys** in drop-down menu.
You can then copy the key by clicking on the green text **Copy**.

By default, functions of `{openai}` will look for `SPOTIFY_CLIENT_ID`
environment variable. If you want to set a global environment variable,
you can use the following command (where
`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` should be replaced
with your actual key):

``` r
Sys.setenv(
    SPOTIFY_CLIENT_ID = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
)
```

Otherwise, you can add the key to the `.Renviron` file of the project.
The following commands will open `.Renviron` for editing:

``` r
if (!require(usethis))
    install.packages("usethis")

usethis::edit_r_environ(scope = "project")
```

You can add the following line to the file (again, replace
`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` with your actual
key):

``` r
OPENAI_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Note:** If you are using GitHub/Gitlab, do not forget to add
`.Renviron` to `.gitignore`!

Finally, you can always provide the key manually to the functions of the
package.

## Example

Functions of `{openai}` have self-explanatory names. For example, to
create a completion, one can use `create_completion()` function:

``` r
library(openai)

create_completion(
    engine_id = "ada",
    prompt = "Generate a question and an answer"
)
#> $id
#> [1] "cmpl-6JlmRJ6SD4vVTrIy5CTWIkQy4cUWm"
#> 
#> $object
#> [1] "text_completion"
#> 
#> $created
#> [1] 1670169919
#> 
#> $model
#> [1] "ada"
#> 
#> $choices
#>                                                text index logprobs
#> 1  dialog\n\nStatus\n\n$filters = filter('thrid = #     0       NA
#>   finish_reason
#> 1        length
#> 
#> $usage
#> $usage$prompt_tokens
#> [1] 7
#> 
#> $usage$completion_tokens
#> [1] 16
#> 
#> $usage$total_tokens
#> [1] 23
```

Further, one can generate an image using DALL·E text-to-image model with
`create_image()`:

``` r
create_image("An astronaut riding a horse in a photorealistic style")
```

<img src="http://tiny.cc/22n1vz" width="100%" />
