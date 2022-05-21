#' @export
edit <- function(
        engine = "ada",
        input = '"',
        instruction,
        temperature = 1,
        top_p = 1,
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
        assertthat::is.string(input),
        assertthat::noNA(input)
    )

    assertthat::assert_that(
        assertthat::is.string(instruction),
        assertthat::noNA(instruction)
    )

    assertthat::assert_that(
        assertthat::is.number(temperature),
        assertthat::noNA(temperature),
        value_between(temperature, 0, 2)
    )

    assertthat::assert_that(
        assertthat::is.number(top_p),
        assertthat::noNA(top_p),
        value_between(top_p, 0, 1)
    )

    if (both_specified(temperature, top_p)) {
        warning(
            "It is recommended NOT to specify temperature and top_p at a time."
        )
    }

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
    # Build path parameters

    task <- "edits"

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}/{task}")

    headers <- c(
        Authorization = paste("Bearer", openai_api_key)
    )

    if (!is.null(openai_organization)) {
        headers[`OpenAI-Organization`] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["input"]] <- input
    body[["instruction"]] <- instruction
    body[["temperature"]] <- temperature
    body[["top_p"]] <- top_p

    #---------------------------------------------------------------------------
    # Make a request and verify its result

    result <- httr::POST(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(.headers = headers),
        body = body,
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    #---------------------------------------------------------------------------
    # Parse the result of the request

    result %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

}
