#' @export
completion <- function(
        engine = "ada",
        prompt = "Hello world",
        max_tokens = 10,
        openai_api_key = Sys.getenv("OPENAI_API_KEY")
        ) {

    task <- "completions"
    engine <- "ada"

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine}/{task}")

    result <- httr::POST(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(Authorization = paste("Bearer", api_key, sep = " ")),
        body = list(
            prompt = prompt,
            max_tokens = max_tokens
        ),
        encode = "json"
    )

    # XXX: check the mime-type is what you expect, and then parse yourself
    # XXX: See ?content
    httr::content(result)

}
