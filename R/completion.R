#' @export
completion <- function(
        engine = "ada",
        prompt = "<|endoftext|>",
        suffix = NULL,
        max_tokens = 16,
        temperature = 1,
        top_p = 1,
        n = 1,
        stream = FALSE,
        logprobs = NULL,
        echo = FALSE,
        stop = NULL,
        presence_penalty = 0,
        frequency_penalty = 0,
        best_of = 1,
        logit_bias = NULL,
        user = NULL,
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
        value_between(temperature, 0, 2)
    )

    assertthat::assert_that(
        assertthat::is.number(top_p),
        assertthat::noNA(top_p),
        value_between(top_p, 0, 2)
    )

    if (both_specified(temperature, top_p)) {
        warning(
            "It is recommended NOT to specify temperature and top_p at a time."
        )
    }

    assertthat::assert_that(
        assertthat::is.count(n)
    )

    assertthat::assert_that(
        assertthat::is.flag(stream),
        assertthat::noNA(stream),
        is_false(stream)
    )

    if (!is.null(suffix)) {
        assertthat::assert_that(
            assertthat::is.count(logprobs - 1),
            value_between(logprobs, 0, 5)

        )
    }

    assertthat::assert_that(
        assertthat::is.flag(echo),
        assertthat::noNA(echo)
    )

    if (!is.null(stop)) {
        assertthat::assert_that(
            is.character(stop),
            assertthat::noNA(stop),
            length_between(stop, 1, 4)
        )
    }

    assertthat::assert_that(
        assertthat::is.number(presence_penalty),
        assertthat::noNA(presence_penalty),
        value_between(presence_penalty, -2, 2)
    )

    assertthat::assert_that(
        assertthat::is.number(frequency_penalty),
        assertthat::noNA(frequency_penalty),
        value_between(frequency_penalty, -2, 2)
    )

    assertthat::assert_that(
        assertthat::is.count(best_of)
    )

    assertthat::assert_that(
        best_of >= n
    )

    if (!is.null(user)) {
        assertthat::assert_that(
            assertthat::is.string(user),
            assertthat::noNA(user)
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
    body[["n"]] <- n
    body[["stream"]] <- stream
    body[["logprobs"]] <- logprobs
    body[["echo"]] <- echo
    body[["stop"]] <- stop
    body[["presence_penalty"]] <- presence_penalty
    body[["frequency_penalty"]] <- frequency_penalty
    body[["best_of"]] <- best_of
    body[["logit_bias"]] <- logit_bias
    body[["user"]] <- user

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
