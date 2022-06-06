#' Create classification
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#'   **Note:** This endpoint is deprecated and will be removed on December 3,
#'   2022. Please see [Classifications Transition
#'   Guide](https://help.openai.com/en/articles/6272941-classifications-transition-guide)
#'    for details.
#'
#'   Classifies the query based on the provided examples. See [this
#'   page](https://beta.openai.com/docs/api-reference/classifications/create)
#'   for details.
#'
#' @details For arguments description please refer to the [official
#'   documentation](https://beta.openai.com/docs/api-reference/classifications/create).
#'
#' @param model required; defaults to `"ada"`; a length one character vector,
#'   one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`.
#' @param query required; a length one character vector.
#' @param examples optional; defaults to `NULL`; a list. A list of examples with
#'   labels, in the following format: `list(c("The movie is so interesting.",
#'   "Positive"), c("It is quite boring.", "Negative"), ...)`.
#' @param file optional; defaults to `NULL`; a length one character vector.
#' @param labels optional; defaults to `NULL`; an arbitrary length character
#'   vector.
#' @param search_model required; defaults to `ada`; a length one character
#'   vector, one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`.
#' @param temperature required; defaults to `0`; a length one numeric vector
#'   with the value between `0` and `2`.
#' @param logprobs optional; defaults to `NULL`; a length one numeric vector
#'   with the integer value between `0` and `5`.
#' @param max_examples required; defaults to `200`; a length one numeric vector
#'   with the integer value greater than `0`.
#' @param logit_bias optional; defaults to `NULL`; a named list.
#' @param return_prompt required; defaults to `FALSE`; a length one logical
#'   vector.
#' @param return_metadata required; defaults to `FALSE`; a length one logical
#'   vector.
#' @param expand optional; defaults to `NULL`; a list elements of which are
#'   among `completion` and `file`.
#' @param user optional; defaults to `NULL`; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain label and other
#'   supplementary information.
#' @examples \dontrun{
#' create_classification(
#'     search_model = "ada",
#'     model = "curie",
#'     examples = list(
#'         c("A happy moment", "Positive"),
#'         c("I am sad.", "Negative"),
#'         c("I am feeling awesome", "Positive")
#'     ),
#'     query = "I'm ok",
#'     labels = c("Positive", "Negative", "Neutral")
#' )
#' }
#' @export
create_classification <- function(
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

    lifecycle::deprecate_warn(
        "0.1.0",
        "create_answer()",
        details = paste(
            "See the official transition guide:",
            "https://help.openai.com/en/articles/6272941-classifications-transition-guide"
        )
    )

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
            assertthat::is.count(logprobs + 1),
            value_between(logprobs, 0, 5)

        )
    }

    assertthat::assert_that(
        assertthat::is.count(max_examples)
    )

    if (!is.null(logit_bias)) {
        assertthat::assert_that(
            is.list(logit_bias)
        )
    }

    assertthat::assert_that(
        assertthat::is.flag(return_prompt),
        assertthat::noNA(return_prompt)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
    )

    if (!is.null(expand)) {
        assertthat::assert_that(
            is.list(expand)
        )
    }

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
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"
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
