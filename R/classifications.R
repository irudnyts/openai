#' @export
classification <- function(
        model = c("ada", "babbage", "curie", "davinci"),
        query,
        examples = NULL,
        file = NULL,
        labels = NULL,
        search_model = c("ada", "babbage", "curie", "davinci"),
        temperature = 0,
        logprobs = NULL,
        max_examples = 200,
        logit_bias = NULL,
        return_prompt = FALSE,
        return_metadata = FALSE,
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
        assertthat::is.string(query),
        assertthat::noNA(query)
    )

    if (!is.null(examples)) {
        assertthat::assert_that(
            is.list(examples)
        )
    }

    if (!is.null(file)) {
        assertthat::assert_that(
            assertthat::is.string(file),
            assertthat::noNA(file)
        )
    }

    if ((is.null(examples) && is.null(file)) ||
        (!is.null(examples) && !is.null(file))) {
        stop("You should specify either examples or a file, but not both.")
    }

    if (!is.null(labels)) {
        assertthat::assert_that(
            is.character(labels),
            assertthat::noNA(labels)
        )
    }

    assertthat::assert_that(
        assertthat::is.string(search_model),
        assertthat::noNA(search_model)
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
        assertthat::is.count(max_examples)
    )

    # XXX: validate logit_bias

    assertthat::assert_that(
        assertthat::is.flag(return_prompt),
        assertthat::noNA(return_prompt)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
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

    task <- "classifications"

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
    body[["query"]] <- query
    body[["examples"]] <- examples
    body[["file"]] <- file
    body[["labels"]] <- labels
    body[["search_model"]] <- search_model
    body[["temperature"]] <- temperature
    body[["logprobs"]] <- logprobs
    body[["logit_bias"]] <- logit_bias
    body[["return_prompt"]] <- return_prompt
    body[["return_metadata"]] <- return_metadata
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
