#' @export
completion <- function(
        engine = "ada",
        prompt = "<|endoftext|>",
        suffix = NULL,
        max_tokens = 16,
        temperature = 1,
        top_p = 1,
        # n = 1,
        # stream = FALSE,
        # logprobs = NULL,
        # echo = FALSE,
        # stop = NULL,
        # presence_penalty = 0,
        # frequency_penalty = 0,
        # best_of = 1,
        # logit_bias = NULL,
        # user = NULL,
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
        is.character(prompt),
        assertthat::noNA(prompt)
    )

    if (!is.null(suffix)) {
        assertthat::assert_that(
            assertthat::is.string(suffix),
            assertthat::noNA(suffix)
        )
    }

    assertthat::assert_that(
        assertthat::is.count(max_tokens)
    )

    assertthat::assert_that(
        assertthat::is.number(temperature),
        assertthat::noNA(temperature),
        between_zero_and_two(temperature)
    )

    assertthat::assert_that(
        assertthat::is.number(top_p),
        assertthat::noNA(top_p),
        between_zero_and_two(top_p)
    )


    ### XXX check if not specified

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

    task <- "completions"

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
    body[["prompt"]] <- prompt
    body[["suffix"]] <- suffix
    body[["max_tokens"]] <- max_tokens
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
