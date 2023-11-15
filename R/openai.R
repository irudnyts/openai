#' @importFrom lifecycle deprecated
NULL

#' @export
OpenAI <- function(api_key) {
    openai$new(api_key)
}
