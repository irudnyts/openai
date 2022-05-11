#' @export
completion <- function(
        engine = "ada",
        prompt = "Hello world",
        max_tokens = 10,
        # XXX: add the rest of parameters
        openai_api_key = Sys.getenv("OPENAI_API_KEY") #,
        # openai_organization = NULL
        ) {

    task <- "completions"
    engine <- "ada"

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}/{task}")

    result <- httr::POST(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(
            Authorization = paste("Bearer", openai_api_key, sep = " ")
        ),
        # httr::add_headers(`OpenAI-Organization` = openai_organization),
        body = list(
            prompt = prompt,
            max_tokens = max_tokens
        ),
        encode = "json"
    )

    verify_mime_type(result)

    result %>%
        httr::content(as = "text") %>%
        jsonlite::fromJSON(flatten = TRUE)

}
