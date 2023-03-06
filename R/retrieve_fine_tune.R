#' Retrieve fine-tune
#'
#' Returns information about the specified fine-tune job. See [this
#' page](https://platform.openai.com/docs/api-reference/fine-tunes/retrieve) for
#' details.
#'
#' For arguments description please refer to the [official
#' documentation](https://platform.openai.com/docs/api-reference/fine-tunes/retrieve).
#'
#' @param fine_tune_id required; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contains information about the
#'   fine-tune.
#' @examples \dontrun{
#' training_file <- system.file(
#'     "extdata", "sport_prepared_train.jsonl", package = "openai"
#' )
#' validation_file <- system.file(
#'     "extdata", "sport_prepared_train.jsonl", package = "openai"
#' )
#'
#' training_info <- upload_file(training_file, "fine-tune")
#' validation_info <- upload_file(validation_file, "fine-tune")
#'
#' info <- create_fine_tune(
#'     training_file = training_info$id,
#'     validation_file = validation_info$id,
#'     model = "ada",
#'     compute_classification_metrics = TRUE,
#'     classification_positive_class = " baseball" # Mind space in front
#' )
#'
#' id <- ifelse(
#'     length(info$data$id) > 1,
#'     info$data$id[length(info$data$id)],
#'     info$data$id
#' )
#'
#' retrieve_fine_tune(fine_tune_id = id)
#' }
#' @family fine-tune functions
#' @export
retrieve_fine_tune <- function(
        fine_tune_id,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(fine_tune_id),
        assertthat::noNA(fine_tune_id)
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

    base_url <- glue::glue(
        "https://api.openai.com/v1/fine-tunes/{fine_tune_id}"
    )

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
