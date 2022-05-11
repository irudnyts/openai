#' @export
list_engines <- function(
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

    if (!is.null(openai_organization)) {
        assertthat::assert_that(
            assertthat::is.string(openai_organization),
            assertthat::noNA(openai_organization)
        )
    }

    base_url <- "https://api.openai.com/v1/engines"

    headers <- c(
        Authorization = paste("Bearer", openai_api_key)
    )

    if (!is.null(openai_organization)) {
        headers[`OpenAI-Organization`] <- openai_organization
    }

    result <- httr::GET(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(.headers = headers),
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    result %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
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
        assertthat::is.string(engine),
        assertthat::noNA(engine)
    )

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

    if (!is.null(openai_organization)) {
        assertthat::assert_that(
            assertthat::is.string(openai_organization),
            assertthat::noNA(openai_organization)
        )
    }

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}")

    headers <- c(
        Authorization = paste("Bearer", openai_api_key)
    )

    if (!is.null(openai_organization)) {
        headers[`OpenAI-Organization`] <- openai_organization
    }

    result <- httr::GET(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(.headers = headers),
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    result %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

}
