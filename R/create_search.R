#' Create search
#'
#' Computes similarity scores between provided query and documents. See
#' \href{https://beta.openai.com/docs/api-reference/searches/create}{this page}
#' for details.
#'
#' Given a query and a set of documents or labels, the model ranks each document
#' based on its semantic similarity to the provided query. The search endpoint
#' computes similarity scores between provided query and documents. Documents
#' can be passed directly to the API if there are no more than 200 of them. To
#' go beyond the 200 document limit, documents can be processed offline and then
#' used for efficient retrieval at query time. When \code{file} is set, the
#' search endpoint searches over all the documents in the given file and returns
#' up to the \code{max_rerank} number of documents. These documents will be
#' returned along with their search scores. The similarity score is a positive
#' score that usually ranges from 0 to 300 (but can sometimes go higher), where
#' a score above 200 usually means the document is semantically similar to the
#' query. Related guide:
#' \href{https://beta.openai.com/docs/guides/search}{Search}.
#'
#' @param engine_id required; defaults to \code{"ada"}; a length one character
#' vector, one among \code{"ada"}, \code{"babbage"}, \code{"curie"}, and
#' \code{"davinci"}. The ID of the engine to use for this request.
#' @param query required; length one character vector. Query to search against
#' the documents.
#' @param documents optional; defaults to \code{NULL}; an arbitrary length
#' character vector. Up to 200 documents to search over. The maximum document
#' length (in tokens) is 2034 minus the number of tokens in the query. You
#' should specify either \code{documents} or a \code{file}, but not both.
#' @param file optional; defaults to \code{NULL}; length one character vector.
#' The ID of an uploaded file that contains documents to search over. You should
#' specify either \code{documents} or a \code{file}, but not both.
#' @param max_rerank required; defaults to \code{200}; a length one numeric vector
#' with the integer value greater than \code{0}. The maximum number of documents
#' to be re-ranked and returned by search. This flag only takes effect when
#' \code{file} is set.
#' @param return_metadata required; defaults to \code{FALSE}; a length one
#' logical vector. A special boolean flag for showing metadata. If set to
#' \code{TRUE}, each document entry in the returned JSON will contain a
#' "metadata" field. This flag only takes effect when \code{file} is set.
#' @param user optional; defaults to \code{NULL}; a length one character vector.
#' A unique identifier representing your end-user, which will help OpenAI to
#' monitor and detect abuse.
#' @param openai_api_key required; defaults to
#' \code{Sys.getenv("OPENAI_API_KEY")} (i.e., the value is retrieved from the
#' \code{.Renviron} file); a length one character vector. Specifies OpenAI API
#' key.
#' @param openai_organization optional; defaults to \code{NULL}; a length one
#' character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain score of each document and
#' supplementary information.
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
