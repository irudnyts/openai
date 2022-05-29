#' @export
list_engines <- function(
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

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

    #---------------------------------------------------------------------------
    # Build parameters of the request

    base_url <- "https://api.openai.com/v1/engines"

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::GET(
        url = base_url,
        httr::add_headers(.headers = headers),
        encode = "json"
    )

    verify_mime_type(response)

    parsed <- response %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

    #---------------------------------------------------------------------------
    # Check whether request failed and return parsed

    if (httr::http_error(response)) {
        paste0(
            "OpenAI API request failed [",
            httr::status_code(response),
            "]:\n\n",
            parsed$error$message
        ) %>%
            stop(call. = FALSE)
    }

    parsed

}

#' @export
retrieve_engine <- function(
        engine,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

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

    #---------------------------------------------------------------------------
    # Build parameters of the request

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}")

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::GET(
        url = base_url,
        httr::add_headers(.headers = headers),
        encode = "json"
    )

    verify_mime_type(response)

    parsed <- response %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

    #---------------------------------------------------------------------------
    # Check whether request failed and return parsed

    if (httr::http_error(response)) {
        paste0(
            "OpenAI API request failed [",
            httr::status_code(response),
            "]:\n\n",
            parsed$error$message
        ) %>%
            stop(call. = FALSE)
    }

    parsed

}
