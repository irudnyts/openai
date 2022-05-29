#' @export
create_answer <- function(
        model = c("ada", "babbage", "curie", "davinci"),
        question,
        examples,
        examples_context,
        documents = NULL,
        file = NULL,
        search_model = c("ada", "babbage", "curie", "davinci"),
        max_rerank = 200,
        temperature = 0,
        logprobs = NULL,
        max_tokens = 16,
        stop = NULL,
        n = 1,
        logit_bias = NULL,
        return_metadata = FALSE,
        return_prompt = FALSE,
        expand = NULL,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    model <- match.arg(model)
    search_model <- match.arg(search_model)

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(model),
        assertthat::noNA(model)
    )

    assertthat::assert_that(
        assertthat::is.string(question),
        assertthat::noNA(question)
    )

    assertthat::assert_that(
        is.list(examples)
    )

    assertthat::assert_that(
        assertthat::is.string(examples_context),
        assertthat::noNA(examples_context)
    )

    if (!is.null(documents)) {
        assertthat::assert_that(
            is.character(documents),
            assertthat::noNA(documents)
        )
    }

    if (!is.null(file)) {
        assertthat::assert_that(
            assertthat::is.string(file),
            assertthat::noNA(file)
        )
    }

    if ((is.null(documents) && is.null(file)) ||
        (!is.null(documents) && !is.null(file))) {
        stop("You should specify either documents or a file, but not both.")
    }

    assertthat::assert_that(
        assertthat::is.string(search_model),
        assertthat::noNA(search_model)
    )

    assertthat::assert_that(
        assertthat::is.count(max_rerank)
    )

    assertthat::assert_that(
        assertthat::is.number(temperature),
        assertthat::noNA(temperature),
        value_between(temperature, 0, 2)
    )

    if (!is.null(logprobs)) {
        assertthat::assert_that(
            assertthat::is.count(logprobs - 1),
            value_between(logprobs, 0, 5)

        )
    }

    assertthat::assert_that(
        assertthat::is.count(max_tokens)
    )

    if (!is.null(stop)) {
        assertthat::assert_that(
            is.character(stop),
            assertthat::noNA(stop),
            length_between(stop, 1, 4)
        )
    }

    assertthat::assert_that(
        assertthat::is.count(n)
    )

    # XXX: validate logit_bias

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_prompt),
        assertthat::noNA(return_prompt)
    )

    # XXX: validate expand

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

    task <- "answers"

    base_url <- glue::glue("https://api.openai.com/v1/{task}")

    headers <- c(
        Authorization = paste("Bearer", openai_api_key)
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["model"]] <- model
    body[["question"]] <- question
    body[["examples"]] <- examples
    body[["examples_context"]] <- examples_context
    body[["documents"]] <- documents
    body[["file"]] <- file
    body[["search_model"]] <- search_model
    body[["max_rerank"]] <- max_rerank
    body[["temperature"]] <- temperature
    body[["logprobs"]] <- logprobs
    body[["max_tokens"]] <- max_tokens
    body[["stop"]] <- stop
    body[["n"]] <- n
    body[["logit_bias"]] <- logit_bias
    body[["return_metadata"]] <- return_metadata
    body[["return_prompt"]] <- return_prompt
    body[["expand"]] <- expand
    body[["user"]] <- user

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(.headers = headers),
        body = body,
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

