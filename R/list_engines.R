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

    # XXX: check the mime-type is what you expect, and then parse yourself
    # XXX: See ?content
    # result %>%
    #     httr::content() %>%
    #     purrr::pluck("data") %>%
    #     tibble::tibble(data = .) %>%
    #     tidyr::unnest_wider(data)

    result %>%
        httr::content(as = "text") %>%
        jsonlite::fromJSON() %>%
        purrr::pluck("data")
}
