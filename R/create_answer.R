#' Create answer
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#'   **Note:** This endpoint is deprecated and will be removed on December 3,
#'   2022. Please see [Answers Transition
#'   Guide](https://help.openai.com/en/articles/6233728-answers-transition-guide)
#'    for details.
#'
#'   Answers the specified question based on the documents and examples. See
#'   [this page](https://beta.openai.com/docs/api-reference/answers/create) for
#'   details.
#'
#' @details For arguments description please refer to the [official
#'   documentation](https://beta.openai.com/docs/api-reference/answers/create).
#'
#' @param model required; defaults to `"ada"`; a length one character vector,
#'   one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`.
#' @param question required; a length one character vector.
#' @param examples required; a list.
#' @param examples_context required; a length one character vector.
#' @param documents optional; defaults to `NULL`; an arbitrary length character
#'   vector.
#' @param file optional; defaults to `NULL`; a length one character vector.
#' @param search_model required; defaults to `ada`; a length one character
#'   vector, one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`.
#' @param max_rerank required; defaults to `200`; a length one numeric vector
#'   with the integer value greater than `0`.
#' @param temperature required; defaults to `0`; a length one numeric vector
#'   with the value between `0` and `2`.
#' @param logprobs optional; defaults to `NULL`; a length one numeric vector
#'   with the integer value between `0` and `5`.
#' @param max_tokens required; defaults to `16`; a length one numeric vector
#'   with the integer value greater than `0`.
#' @param stop optional; defaults to `NULL`; a character vector of length
#'   between one and four.
#' @param n required; defaults to `1`; a length one numeric vector with the
#'   integer value greater than `0`.
#' @param logit_bias optional; defaults to `NULL`; a named list.
#' @param return_metadata required; defaults to `FALSE`; a length one logical
#'   vector.
#' @param return_prompt required; defaults to `FALSE`; a length one logical
#'   vector.
#' @param expand optional; defaults to `NULL`; a list elements of which are
#'   among `completion` and `file`.
#' @param user optional; defaults to `NULL`; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain an answer and other
#'   supplementary information.
#' @examples \dontrun{
#' create_answer(
#'     search_model = "ada",
#'     model = "curie",
#'     question = "How many red apples do I have?",
#'     documents = c("I have five green apples.", "I love oranges."),
#'     examples_context = "Jack has three brothers and one sister. His sister is sad",
#'     examples = list(
#'         c("How many siblings has Jack?", "Three"),
#'         c("Who is sad?", "Jack's sister is.")
#'     ),
#'     max_tokens = 5,
#'     stop = c("\n", "<|endoftext|>"),
#' )
#' }
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

    lifecycle::deprecate_warn(
        "0.1.0",
        "create_answer()",
        details = paste(
            "See the official transition guide:",
            "https://help.openai.com/en/articles/6233728-answers-transition-guide"
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
            assertthat::is.count(logprobs + 1),
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

    if (!is.null(logit_bias)) {
        assertthat::assert_that(
            is.list(logit_bias)
        )
    }

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_prompt),
        assertthat::noNA(return_prompt)
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

    task <- "answers"

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

