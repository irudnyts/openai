
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openai <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/irudnyts/openai/workflows/R-CMD-check/badge.svg)](https://github.com/irudnyts/openai/actions)
[![Codecov test
coverage](https://codecov.io/gh/irudnyts/openai/branch/main/graph/badge.svg)](https://app.codecov.io/gh/irudnyts/openai?branch=main)
<!-- badges: end -->

## Overview

`{openai}` is an R wrapper of OpenAI API endpoints. This package covers
Engines, Completions, Edits, Files, Fine-tunes, Embeddings and legacy
Searches, Classifications, and Answers endpoints (will be removed on
December 3, 2022).

## Installation

You can install the development version of `{openai}` from
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
#> [1] "cmpl-5GDS6aZAwCPBqUCSpjUWXdFH04FLR"
#> 
#> $object
#> [1] "text_completion"
#> 
#> $created
#> [1] 1654546642
#> 
#> $model
#> [1] "ada"
#> 
#> $choices
#>                                                                  text index
#> 1  from Pluralities.ai\nIn this office we sleep your worries away and     0
#>   logprobs finish_reason
#> 1       NA        length
```
