library(rvest)
library(dplyr)

iso_codes <-
    "https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes" |>
    read_html() |>
    html_table() |>
    getElement(2) |>
    select(1:2)

iso_languages <-
    iso_codes$`639-1` |>
    setNames(iso_codes$`ISO language name`)

usethis::use_data(iso_languages, overwrite = TRUE)
