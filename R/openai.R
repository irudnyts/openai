#' @importFrom lifecycle deprecated
NULL

#' @export
OpenAI <- function(
        api_key = NULL,
        organization = NULL,
        base_url = NULL,
        # timeout = NULL,
        max_retries = NULL #,
        # default_headers = NULL,
        # default_query = NULL,
        # http_client = NULL,
        # .strict_response_validation = NULL
) {
    openai$new(
        api_key = api_key,
        organization = organization,
        base_url = base_url,
        max_retries = max_retries
    )
}
