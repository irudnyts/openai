#' Create search
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#'   **Note:** This endpoint is deprecated and will be removed on December 3,
#'   2022. Please see [Search Transition
#'   Guide](https://help.openai.com/en/articles/6272952-search-transition-guide)
#'   for details.
#'
#'   Computes similarity scores between the query and provided documents. See
#'   [this page](https://beta.openai.com/docs/api-reference/searches/create) for
#'   details.
#'
#' @details For arguments description please refer to the [official
#'   documentation](https://beta.openai.com/docs/api-reference/searches/create).
#'
#' @param engine_id required; defaults to `"ada"`; a length one character
#'   vector, one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`.
#' @param query required; length one character vector.
#' @param documents optional; defaults to `NULL`; an arbitrary length character
#'   vector.
#' @param file optional; defaults to `NULL`; a length one character vector.
#' @param max_rerank required; defaults to `200`; a length one numeric vector
#'   with the integer value greater than `0`.
#' @param return_metadata required; defaults to `FALSE`; a length one logical
#'   vector.
#' @param user optional; defaults to `NULL`; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain score of each document and
#'   supplementary information.
#' @examples \dontrun{
#' create_search(
#'     documents = c("White House", "hospital", "school"),
#'     query = "the president"
#' )
#' }
#' @export
create_search <- function(
        engine_id = c("ada", "babbage", "curie", "davinci"),
        query,
        documents = NULL,
        file = NULL,
        max_rerank = 200,
        return_metadata = FALSE,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    lifecycle::deprecate_warn(
        "0.1.0",
        "create_answer()",
        details = paste(
            "See the official transition guide:",
            "https://help.openai.com/en/articles/6272952-search-transition-guide"
        )
    )

    engine_id <- match.arg(engine_id)

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(engine_id),
        assertthat::noNA(engine_id)
    )

    assertthat::assert_that(
        assertthat::is.string(query),
        assertthat::noNA(query)
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
        assertthat::is.count(max_rerank)
    )

    assertthat::assert_that(
        assertthat::is.flag(return_metadata),
        assertthat::noNA(return_metadata)
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

    task <- "search"

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
    body[["query"]] <- query
    body[["documents"]] <- documents
    body[["file"]] <- file
    body[["max_rerank"]] <- max_rerank
    body[["return_metadata"]] <- return_metadata
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
