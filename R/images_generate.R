images_generate <- function(prompt,
                            model,
                            n,
                            quality,
                            response_format,
                            size,
                            style,
                            user,
                            api_key,
                            organization,
                            base_url,
                            max_retries) {
    # set default arguments

    # validate arguments

    body <- list()
    body[["prompt"]] <- prompt
    body[["model"]] <- model
    body[["n"]] <- n
    body[["quality"]] <- quality
    body[["response_format"]] <- response_format
    body[["size"]] <- size
    body[["style"]] <- style
    body[["user"]] <- user

    resp <- httr2::request(base_url) |>
        httr2::req_url_path_append("images/generations") |>
        httr2::req_auth_bearer_token(api_key) |>
        httr2::req_headers("OpenAI-Organization" = organization) |>
        httr2::req_body_json(data = body) |>
        httr2::req_retry(max_tries = max_retries) |>
        httr2::req_perform() # httr2::req_stream() if strem = TRUE

    resp <- resp |>
        httr2::resp_body_json()

    images_response$new(
        created = resp$created,
        data = resp$data
    )

}
