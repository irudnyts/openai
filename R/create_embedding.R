#' Create embeddings
#'
#' Creates an embedding vector representing the input text. See
#' \href{https://beta.openai.com/docs/api-reference/embeddings/create}{this page}
#' for details.
#'
#' Get a vector representation of a given input that can be easily consumed by
#' machine learning models and algorithms. Related guide:
#' \href{https://beta.openai.com/docs/guides/embeddings}{Embeddings}.
#'
#' @param engine_id required; a length one character vector. The ID of the
#' engine to use for this request.
#' @param input required; an arbitrary length character vector. Input text to
#' get embeddings for, encoded as a string or array of tokens. To get embeddings
#' for multiple inputs in a single request, pass an array of strings or array of
#' token arrays. Each input must not exceed 2048 tokens in length. Unless your
#' are embedding code, we suggest replacing newlines (\code{\\n}) in your input
#' with a single space, as we have observed inferior results when newlines are
#' present.
#' @param user optional; defaults to \code{NULL}; a length one character vector.
#' A unique identifier representing your end-user, which will help OpenAI to
#' monitor and detect abuse.
#' @param openai_api_key required; defaults to
#' \code{Sys.getenv("OPENAI_API_KEY")} (i.e., the value is retrieved from the
#' \code{.Renviron} file); a length one character vector. Specifies OpenAI API
#' key.
#' @param openai_organization optional; defaults to \code{NULL}; a length one
#' character vector. Specifies OpenAI organization.
#' @return Returns a list, an element of which contains embedding vector(s) for
#' a given input.
#' @examples \dontrun{
#' create_embedding(
#'     engine_id = "text-similarity-babbage-001",
#'     input = c(
#'         "Ah, it is so boring to write documentation",
#'         "But examples are really crucial"
#'     )
#' )
#' }
#' @export
create_embedding <- function(
        engine_id,
        input,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(engine_id),
        assertthat::noNA(engine_id)
    )

    assertthat::assert_that(
        is.character(input),
        assertthat::noNA(input)
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

    task <- "embeddings"

    base_url <- glue::glue(
        "https://api.openai.com/v1/engines/{engine_id}/{task}"
    )

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
    body[["input"]] <- input
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