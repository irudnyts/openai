#' Upload file
#'
#' Upload a file that contains document(s) to be used across various
#' endpoints/features. Currently, the size of all the files uploaded by one
#' organization can be up to 1 GB. Please contact us if you need to increase the
#' storage limit.
#'
#' Files are used to upload documents that can be used across features like
#' \href{https://beta.openai.com/docs/api-reference/answers}{Answers},
#' \href{https://beta.openai.com/docs/api-reference/searches}{Search},
#' and \href{https://beta.openai.com/docs/api-reference/classifications}{Classifications}.
#'
#' @param file required; a length one character vector. Name of the JSON Lines
#' file to be uploaded. If the \code{purpose} is set to "search" or "answers",
#' each line is a JSON record with a "text" field and an optional "metadata"
#' field. Only "text" field will be used for search. Specially, when the
#' \code{purpose} is "answers", "\\n" is used as a delimiter to chunk contents
#' in the "text" field into multiple documents for finer-grained matching. If
#' the \code{purpose} is set to "classifications", each line is a JSON record
#' representing a single training example with "text" and "label" fields along
#' with an optional "metadata" field. If the \code{purpose} is set to
#' "fine-tune", each line is a JSON record with "prompt" and "completion" fields
#' representing your
#' \href{https://beta.openai.com/docs/guides/fine-tuning/prepare-training-data}{training examples}.
#' @param purpose required; defaults to \code{"search"}; a length one character
#' vector, one among \code{"search"}, \code{"answers"}, \code{"classifications"},
#' and \code{"fine-tune"}. The intended purpose of the uploaded documents. This
#' allows us to validate the format of the uploaded file.
#' @param openai_api_key required; defaults to
#' \code{Sys.getenv("OPENAI_API_KEY")} (i.e., the value is retrieved from the
#' \code{.Renviron} file); a length one character vector. Specifies OpenAI API
#' key.
#' @param openai_organization optional; defaults to \code{NULL}; a length one
#' character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contains ID of an uploaded file and
#' other supplementary information.
#' @examples \dontrun{
#' file <- system.file("extdata", "classification-file.jsonl", package = "openai")
#' upload_file(file = file, purpose = "classification")
#' }
#' @family file functions
#' @export
upload_file <- function(
        file,
        purpose = c("search", "answers", "classifications", "fine-tune"),
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    purpose <- match.arg(purpose)

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(file),
        assertthat::noNA(file),
        file.exists(file),
        assertthat::is.readable(file)
    )

    assertthat::assert_that(
        assertthat::is.string(purpose),
        assertthat::noNA(purpose)
    )

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

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
    # Build parameters of the request

    base_url <- "https://api.openai.com/v1/files"

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "multipart/form-data"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["file"]] <- httr::upload_file(file)
    body[["purpose"]] <- purpose

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::add_headers(.headers = headers),
        body = body,
        encode = "multipart"
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
