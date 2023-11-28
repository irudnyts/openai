chat_completions_create <- function(messages,
                                    model,
                                    frequency_penalty = NULL,
                                    logit_bias = NULL,
                                    max_tokens = NULL,
                                    n = NULL,
                                    presence_penalty = NULL,
                                    response_format = NULL,
                                    seed = NULL,
                                    stop = NULL,
                                    strem = NULL,
                                    temperature = NULL,
                                    top_p = NULL,
                                    tools = NULL,
                                    tool_choice = NULL,
                                    user = NULL,
                                    function_call = NULL,
                                    functions = NULL,
                                    api_key,
                                    organization,
                                    base_url,
                                    max_retries

) {
    # set default arguments

    # validate arguments

    body <- list()
    body[["messages"]] <- messages
    body[["model"]] <- model
    body[["frequency_penalty"]] <- frequency_penalty
    body[["logit_bias"]] <- logit_bias
    body[["max_tokens"]] <- max_tokens
    body[["n"]] <- n
    body[["presence_penalty"]] <- presence_penalty
    body[["response_format"]] <- response_format
    body[["seed"]] <- seed
    body[["stop"]] <- stop
    body[["strem"]] <- strem
    body[["temperature"]] <- temperature
    body[["top_p"]] <- top_p
    body[["tools"]] <- tools
    body[["tool_choice"]] <- tool_choice
    body[["user"]] <- user
    body[["function_call"]] <- function_call
    body[["functions"]] <- functions

    resp <- httr2::request(base_url) |>
        httr2::req_url_path_append("chat/completions") |>
        httr2::req_auth_bearer_token(api_key) |>
        httr2::req_headers("OpenAI-Organization" = organization) |>
        httr2::req_body_json(data = body) |>
        httr2::req_retry(max_tries = max_retries) |>
        httr2::req_perform() # httr2::req_stream() if strem = TRUE

    resp <- resp |>
        httr2::resp_body_json()

    chat_completion$new(
        id = resp$id,
        object = resp$object,
        created = resp$created,
        model = resp$model,
        system_fingerprint = resp$system_fingerprint,
        choices = resp$choices,
        usage = resp$usage
    )

}
