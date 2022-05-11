#' @export
list_engines <- function(
        openai_api_key = Sys.getenv("OPENAI_API_KEY")
        # openai_organization = NULL
) {

    base_url <- "https://api.openai.com/v1/engines"

    result <- httr::GET(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(
            Authorization = paste("Bearer", openai_api_key, sep = " ")
        ),
        # httr::add_headers(`OpenAI-Organization` = openai_organization),
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    result %>%
        httr::content(as = "text") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::pluck("data")

}
