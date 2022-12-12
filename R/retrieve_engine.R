#' Retrieve engine
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#'   **Note:** This endpoint is deprecated and soon will be removed. Please use
#'   its replacement,
#'   [Models](https://beta.openai.com/docs/api-reference/models), instead. The
#'   replacement function in this package is `retrieve_model()`.
#'
#'   Provides information about a specified engine. See [this
#'   page](https://beta.openai.com/docs/api-reference/engines/retrieve) for
#'   details.
#'
#' @details For arguments description please refer to the [official
#' documentation](https://beta.openai.com/docs/api-reference/engines/retrieve).
#'
#' @param engine_id required; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain information about the
#'   engine.
#' @examples \dontrun{
#' retrieve_engine("text-davinci-002")
#' # ->
#' retrieve_model("text-davinci-002")
#' }
#' @family engine functions
#' @keywords internal
#' @export
retrieve_engine <- function(
        engine_id,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    lifecycle::deprecate_warn(
        when = "0.3.0",
        what = "retrieve_engine()",
        with = "retrieve_model()",
        details = paste(
            "Please use its replacement instead:",
            "https://beta.openai.com/docs/api-reference/models"
        )
    )

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(engine_id),
        assertthat::noNA(engine_id)
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

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine_id}")

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
