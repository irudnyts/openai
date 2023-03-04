#' Create chat completion
#'
#' Creates a completion for the chat message. See [this
#' page](https://platform.openai.com/docs/api-reference/chat/create) for
#' details.
#'
#' For arguments description please refer to the [official
#' documentation](https://platform.openai.com/docs/api-reference/chat/create).
#'
#' @param model required; defaults to `"gpt-3.5-turbo"`; a length one character
#'    vector, one among `"gpt-3.5-turbo"` and `"gpt-3.5-turbo-0301"`.
#' @param messages required; defaults to `NULL`; a list in the following
#'   format: `list(list("role" = "user", "content" = "Hey! How old are you?")`
#' @param temperature required; defaults to `1`; a length one numeric vector
#'   with the value between `0` and `2`.
#' @param top_p required; defaults to `1`; a length one numeric vector with the
#'   value between `0` and `1`.
#' @param n required; defaults to `1`; a length one numeric vector with the
#'   integer value greater than `0`.
#' @param stream required; defaults to `FALSE`; a length one logical vector.
#'   **Currently is not implemented.**
#' @param stop optional; defaults to `NULL`; a character vector of length
#'   between one and four.
#' @param max_tokens required; defaults to `(4096 - prompt tokens)`; a length
#'   one numeric vector with the integer value greater than `0`.
#' @param presence_penalty required; defaults to `0`; a length one numeric
#'   vector with a value between `-2` and `2`.
#' @param frequency_penalty required; defaults to `0`; a length one numeric
#'   vector with a value between `-2` and `2`.
#' @param logit_bias optional; defaults to `NULL`; a named list.
#' @param user optional; defaults to `NULL`; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain chat completion(s) and
#'   supplementary information.
#' @examples \dontrun{
#' create_chat_completion(
#'    messages = list(
#'        list(
#'            "role" = "system",
#'            "content" = "You are a helpful assistant."
#'        ),
#'        list(
#'            "role" = "user",
#'            "content" = "Who won the world series in 2020?"
#'        ),
#'        list(
#'            "role" = "assistant",
#'            "content" = "The Los Angeles Dodgers won the World Series in 2020."
#'        ),
#'        list(
#'            "role" = "user",
#'            "content" = "Where was it played?"
#'        )
#'    )
#' )
#' }
#' @export
create_chat_completion<- function(
        model = c("gpt-3.5-turbo", "gpt-3.5-turbo-0301"),
        messages = NULL,
        temperature = 1,
        top_p = 1,
        n = 1,
        stream = FALSE,
        stop = NULL,
        max_tokens = NULL,
        presence_penalty = 0,
        frequency_penalty = 0,
        logit_bias = NULL,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    model <- match.arg(model)

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(model),
        assertthat::noNA(model)
    )

    if (!is.null(messages)) {
        assertthat::assert_that(
            is.list(messages)
        )
    }

    assertthat::assert_that(
        assertthat::is.number(temperature),
        assertthat::noNA(temperature),
        value_between(temperature, 0, 2)
    )

    assertthat::assert_that(
        assertthat::is.number(top_p),
        assertthat::noNA(top_p),
        value_between(top_p, 0, 1)
    )

    if (both_specified(temperature, top_p)) {
        warning(
            "It is recommended NOT to specify temperature and top_p at a time."
        )
    }

    assertthat::assert_that(
        assertthat::is.count(n)
    )

    assertthat::assert_that(
        assertthat::is.flag(stream),
        assertthat::noNA(stream),
        is_false(stream)
    )

    if (!is.null(stop)) {
        assertthat::assert_that(
            is.character(stop),
            assertthat::noNA(stop),
            length_between(stop, 1, 4)
        )
    }


    if (!is.null(max_tokens)) {
        assertthat::assert_that(
            assertthat::is.count(max_tokens)
        )
    }

    assertthat::assert_that(
        assertthat::is.number(presence_penalty),
        assertthat::noNA(presence_penalty),
        value_between(presence_penalty, -2, 2)
    )

    assertthat::assert_that(
        assertthat::is.number(frequency_penalty),
        assertthat::noNA(frequency_penalty),
        value_between(frequency_penalty, -2, 2)
    )

    if (!is.null(logit_bias)) {
        assertthat::assert_that(
            is.list(logit_bias)
        )
    }

    if (!is.null(user)) {
        assertthat::assert_that(
            assertthat::is.string(user),
            assertthat::noNA(user)
        )
    }

    assertthat::assert_that(
        assertthat::is.string(openai_api_key),
        assertthat::noNA(openai_api_key)
    )

    if (!is.null(openai_organization)) {
        assertthat::assert_that(
            assertthat::is.string(openai_organization),
            assertthat::noNA(openai_organization)
        )
    }

    #---------------------------------------------------------------------------
    # Build path parameters

    task <- "chat/completions"

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
    body[["model"]] <- model
    body[["messages"]] <- messages
    body[["temperature"]] <- temperature
    body[["top_p"]] <- top_p
    body[["n"]] <- n
    body[["stream"]] <- stream
    body[["stop"]] <- stop
    body[["max_tokens"]] <- max_tokens
    body[["presence_penalty"]] <- presence_penalty
    body[["frequency_penalty"]] <- frequency_penalty
    body[["logit_bias"]] <- logit_bias
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
