#' @importFrom lifecycle deprecated
NULL

#' @export
OpenAI <- function(
        api_key = NULL,
        organization = NULL,
        base_url = NULL,
        max_retries = NULL
) {
    openai$new(api_key, organization)
}
