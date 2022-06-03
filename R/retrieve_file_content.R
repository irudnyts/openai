#' Retrieve file content
#'
#' Returns the contents of the specified file. See
#' \href{https://beta.openai.com/docs/api-reference/files/retrieve-content}{this page}
#' for details. Please note that only output files are allowed to be downloaded,
#' not the input ones.
#'
#' Files are used to upload documents that can be used across features like
#' \href{https://beta.openai.com/docs/api-reference/answers}{Answers},
#' \href{https://beta.openai.com/docs/api-reference/searches}{Search},
#' and \href{https://beta.openai.com/docs/api-reference/classifications}{Classifications}.
#'
#' @param file_id required; a length one character vector. The ID of the file to
#' use for this request.
#' @param openai_api_key required; defaults to
#' \code{Sys.getenv("OPENAI_API_KEY")} (i.e., the value is retrieved from the
#' \code{.Renviron} file); a length one character vector. Specifies OpenAI API
#' key.
#' @param openai_organization optional; defaults to \code{NULL}; a length one
#' character vector. Specifies OpenAI organization.
#' @return Returns a list, an element of which contains the content of the file.
#' @family file functions
#' @export
retrieve_file_content <- function(
        file_id,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(file_id),
        assertthat::noNA(file_id)
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

    base_url <- glue::glue("https://api.openai.com/v1/files/{file_id}/content")

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::GET(
        url = base_url,
        httr::add_headers(.headers = headers),
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
