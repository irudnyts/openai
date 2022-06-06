#' Upload file
#'
#' Uploads a file that will be used for various purposes. The size of the
#' storage is limited to 1 Gb. See [this
#' page](https://beta.openai.com/docs/api-reference/files/upload) for details.
#'
#' For arguments description please refer to the [official
#' documentation](https://beta.openai.com/docs/api-reference/files/upload).
#'
#' @param file required; a length one character vector.
#' @param purpose required; defaults to `"search"`; a length one character
#'   vector, one among `"search"`, `"answers"`, `"classifications"`, and
#'   `"fine-tune"`.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contains ID of the uploaded file
#'   and other supplementary information.
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
