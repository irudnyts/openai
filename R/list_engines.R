#' List engines
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#'   **Note:** This endpoint is deprecated and soon will be removed. Please use
#'   its replacement,
#'   [Models](https://beta.openai.com/docs/api-reference/models), instead. The
#'   replacement function in this package is `list_models()`.
#'
#'   Lists available engines and provides basic information about such engines.
#'   See [this page](https://beta.openai.com/docs/api-reference/engines/list)
#'   for details.
#'
#' @details For arguments description please refer to the [official
#' documentation](https://beta.openai.com/docs/api-reference/engines/list).
#'
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, an element of which is a data frame containing
#'   information about engines.
#' @examples \dontrun{
#' list_engines()
#' # ->
#' list_models()
#' }
#' @family engine functions
#' @keywords internal
#' @export
list_engines <- function(
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    lifecycle::deprecate_warn(
        when = "0.3.0",
        what = "list_engines()",
        with = "list_models()",
        details = paste(
            "Please use its replacement instead:",
            "https://beta.openai.com/docs/api-reference/models"
        )
    )

    #---------------------------------------------------------------------------
    # Validate arguments

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

    base_url <- "https://api.openai.com/v1/engines"

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
