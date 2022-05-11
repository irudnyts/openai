#' @export
list_engines <- function(
        openai_api_key = Sys.getenv("OPENAI_API_KEY")
        # openai_organization = NULL
) {

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

    base_url <- "https://api.openai.com/v1/engines"

    result <- httr::GET(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(
            Authorization = paste("Bearer", openai_api_key, sep = " ")
        ),
        # httr::add_headers(`OpenAI-Organization` = openai_organization),
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    result %>%
        httr::content(as = "text") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::pluck("data")

}

#' @export
retrieve_engine <- function(
        engine,
        openai_api_key = Sys.getenv("OPENAI_API_KEY")
        # openai_organization = NULL
) {

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

    assertthat::assert_that(
        assertthat::is.string(engine),
        assertthat::noNA(engine)
    )

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}")

    result <- httr::GET(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(
            Authorization = paste("Bearer", openai_api_key, sep = " ")
        ),
        # httr::add_headers(`OpenAI-Organization` = openai_organization),
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    result %>%
        httr::content(as = "text") %>%
        jsonlite::fromJSON(flatten = TRUE)

}
