
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

> :warning: **Note:** :warning: OpenAI introduced major changes in
> package’s version 1.0.0. Since the idea of this package is to mimic
> OpenAI’s official Python package, from now on, everything will be
> re-written in object-oriented way. Current implementation will be
> gradually and gently depricated. One can install the development
> verion using:
>
>     remotes::install_github("TroyHernandez/openai", ref = "r6")
>
> Then, the code will look like:
>
>     library(openai)
>     client <- OpenAI()
>     completion <- client$chat$completions$create(
>         model = "gpt-3.5-turbo",
>         messages = list(list("role" = "user", "content" = "What's up?"))
>     )

## Overview

`{openai}` is an R wrapper of OpenAI API endpoints. This package covers
Models, Completions, Chat, Edits, Images, Embeddings, Audio, Files,
Fine-tunes, Moderations, and legacy Engines endpoints. The latter
endpoints, namely Engines, are left for backward compatibility and will
be removed soon.

## Installation

The easiest way to install `{openai}` from CRAN is to use the “official”
`install.packages()` function:

``` r
install.packages("openai")
```

You can also install the development version of `{openai}` from
[GitHub](https://github.com/), which uses the latest version of official
OpenAI’s Python package:

``` r
if (!require(remotes))
    install.packages("remotes")
remotes::install_github("irudnyts/openai", ref = "r6")
```

## Authentication

To use the OpenAI API, you need to provide an API key. First, sign up
for OpenAI API on [this page](https://openai.com/api/). Once you signed
up and logged in, you need to open [this
page](https://platform.openai.com), click on **Personal**, and select
**View API keys** in drop-down menu. You can then copy the key by
clicking on the green text **Copy**.

By default, functions of `{openai}` will look for `OPENAI_API_KEY`
environment variable. If you want to set a global environment variable,
you can use the following command (where
`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` should be replaced
with your actual key):

``` r
Sys.setenv(
    OPENAI_API_KEY = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
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
    model = "ada",
    prompt = "Generate a question and an answer"
)
#> $id
#> [1] "cmpl-6MiImjcaCSuQYY6u8UA2Mm0rCdbEo"
#> 
#> $object
#> [1] "text_completion"
#> 
#> $created
#> [1] 1670871532
#> 
#> $model
#> [1] "ada"
#> 
#> $choices
#>                                                                             text
#> 1  within 5 minutes, up to an hour depending on how your users are different and
#>   index logprobs finish_reason
#> 1     0       NA        length
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

<img src="man/figures/astronaut.png" width="256px" style="display: block; margin: auto;" />

It is also possible to use ChatGPT’s `gpt-3.5-turbo` model via
`create_chat_completion()`:

``` r
create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
        list(
            "role" = "system",
            "content" = "You are a helpful assistant."
        ),
        list(
            "role" = "user",
            "content" = "Who won the world series in 2020?"
        ),
        list(
            "role" = "assistant",
            "content" = "The Los Angeles Dodgers won the World Series in 2020."
        ),
        list(
            "role" = "user",
            "content" = "Where was it played?"
        )
    )
)
#> $id
#> [1] "chatcmpl-6r7N6YXcMhg8xmVM4ohOcAmzPOy3f"
#> 
#> $object
#> [1] "chat.completion"
#> 
#> $created
#> [1] 1678117740
#> 
#> $model
#> [1] "gpt-3.5-turbo-0301"
#> 
#> $usage
#> $usage$prompt_tokens
#> [1] 56
#> 
#> $usage$completion_tokens
#> [1] 19
#> 
#> $usage$total_tokens
#> [1] 75
#> 
#> 
#> $choices
#> finish_reason index message.role
#> 1          stop     0    assistant
#> message.content
#> 1 The 2020 World Series was played at Globe Life Field in Arlington, Texas.
```

Finally, the speech-to-text
[Whisper](https://openai.com/research/whisper) is available via
`create_transcription()` and `create_translation()`:

``` r
voice_sample_ua <- system.file("extdata", "sample-ua.m4a", package = "openai")
create_translation(file = voice_sample_ua, model = "whisper-1")
#> $text
#> [1] "I want to check how this model works"
```
