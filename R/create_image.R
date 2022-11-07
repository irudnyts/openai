create_image <- function(
        prompt,
        n = 1,
        size = c("1024x1024", "256x256", "512x512"),
        response_format = c("url", "b64_json"),
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    size <- match.arg(size)
    response_format <- match.arg(response_format)

    #---------------------------------------------------------------------------
    # Validate arguments

    #---------------------------------------------------------------------------
    # Build path parameters

    task <- "images/generations"

    base_url <- glue::glue("https://api.openai.com/v1/{task}")

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "application/json"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["prompt"]] <- prompt
    body[["n"]] <- n
    body[["size"]] <- size
    body[["response_format"]] <- response_format
    body[["user"]] <- user

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::add_headers(.headers = headers),
        body = body,
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
