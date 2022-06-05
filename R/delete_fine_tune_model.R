#' Delete fine_tune model
#'
#' Delete a fine-tuned model. You must have the Owner role in your organization.
#' See [this
#' page](https://beta.openai.com/docs/api-reference/fine-tunes/delete-model) for
#' details.
#'
#' Manage fine-tuning jobs to tailor a model to your specific training data.
#' Related guide: [Fine-tune
#' models](https://beta.openai.com/docs/guides/fine-tuning).
#'
#' @param model required; a length one character vector. The model to delete.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contains information about the
#'   deleted model.
#' @examples \dontrun{
#' fine_tunes <- list_fine_tunes()
#'
#' fine_tunes <- fine_tunes$data
#'
#' id <- fine_tunes[!is.na(fine_tunes[, "fine_tuned_model"]), "fine_tuned_model"]
#'
#' delete_fine_tune_model(model = id[1])
#' }
#' @family fine-tune functions
#' @export
delete_fine_tune_model <- function(
        model,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(model),
        assertthat::noNA(model)
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

    base_url <- glue::glue("https://api.openai.com/v1/models/{model}")

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::DELETE(
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
