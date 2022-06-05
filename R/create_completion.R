#' Create completion
#'
#' Creates a new completion for the provided prompt and parameters. See [this
#' page](https://beta.openai.com/docs/api-reference/completions/create) for
#' details.
#'
#' Given a prompt, the model will return one or more predicted completions, and
#' can also return the probabilities of alternative tokens at each position.
#'
#' @param engine_id required; a length one character vector. The ID of the
#'   engine to use for this request.
#' @param prompt required; defaults to `"<|endoftext|>"`; an arbitrary length
#'   character vector. The prompt(s) to generate completions for, encoded as a
#'   string, array of strings, array of tokens, or array of token arrays. Note
#'   that `<|endoftext|>` is the document separator that the model sees during
#'   training, so if a prompt is not specified the model will generate as if
#'   from the beginning of a new document.
#' @param suffix optional; defaults to `NULL`; a length one character vector.
#'   The suffix that comes after a completion of inserted text.
#' @param max_tokens required; defaults to `16`; a length one numeric vector
#'   with the integer value greater than `0`. The maximum number of tokens to
#'   generate in the completion. The token count of your prompt plus
#'   `max_tokens` cannot exceed the model's context length. Most models have a
#'   context length of `2048` tokens (except for the newest models, which
#'   support `4096`).
#' @param temperature required; defaults to `1`; a length one numeric vector
#'   with the value between `0` and `2`. What sampling temperature to use.
#'   Higher values means the model will take more risks. Try `0.9` for more
#'   creative applications, and `0` (argmax sampling) for ones with a
#'   well-defined answer. We generally recommend altering (i.e., setting the
#'   value different from `1`) this or `top_p` but not both.
#' @param top_p required; defaults to `1`; a length one numeric vector with the
#'   value between `0` and `1`. An alternative to sampling with temperature,
#'   called nucleus sampling, where the model considers the results of the
#'   tokens with top_p probability mass. So `0.1` means only the tokens
#'   comprising the top 10\% probability mass are considered. We generally
#'   recommend altering (i.e., setting the value different from `1`) this or
#'   `temperature` but not both.
#' @param n required; defaults to `1`; a length one numeric vector with the
#'   integer value greater than `0`. How many completions to generate for each
#'   prompt. **Note:** Because this parameter generates many completions, it can
#'   quickly consume your token quota. Use carefully and ensure that you have
#'   reasonable settings for `max_tokens` and `stop`.
#' @param stream required; defaults to `FALSE`; a length one logical vector.
#'   Whether to stream back partial progress. If set, tokens will be sent as
#'   data-only server-sent events as they become available, with the stream
#'   terminated by a `data: [DONE]` message. **Currently is not implemented.**
#' @param logprobs optional; defaults to `NULL`; a length one numeric vector
#'   with the integer value between `0` and `5`. Include the log probabilities
#'   on the logprobs most likely tokens, as well the chosen tokens. For example,
#'   if `logprobs` is `5`, the API will return a list of the 5 most likely
#'   tokens. The API will always return the `logprob` of the sampled token, so
#'   there may be up to `logprobs+1` elements in the response. The maximum value
#'   for logprobs is `5`. If you need more than this, please contact
#'   \email{support@openai.com} and describe your use case.
#' @param echo required; defaults to `FALSE`; a length one logical vector. Echo
#'   back the prompt in addition to the completion?
#' @param stop optional; defaults to `NULL`; a character vector of length
#'   between one and four. Up to 4 sequences where the API will stop generating
#'   further tokens. The returned text will not contain the stop sequence.
#' @param presence_penalty required; defaults to `0`; a length one numeric
#'   vector with a value between `-2` and `2`. Positive values penalize new
#'   tokens based on whether they appear in the text so far, increasing the
#'   model's likelihood to talk about new topics.
#' @param frequency_penalty required; defaults to `0`; a length one numeric
#'   vector with a value between `-2` and `2`. Positive values penalize new
#'   tokens based on their existing frequency in the text so far, decreasing the
#'   model's likelihood to repeat the same line verbatim.
#' @param best_of required; defaults to `1`; a length one numeric vector with
#'   the integer value greater than `0`. Generates `best_of` completions
#'   server-side and returns the "best" (the one with the lowest log probability
#'   per token). Results cannot be streamed. When used with `n`, `best_of`
#'   controls the number of candidate completions and `n` specifies how many to
#'   return - `best_of` must be greater than `n`. **Note:** Because this
#'   parameter generates many completions, it can quickly consume your token
#'   quota. Use carefully and ensure that you have reasonable settings for
#'   `max_tokens` and `stop`.
#' @param logit_bias optional; defaults to `NULL`; a named list. Modify the
#'   likelihood of specified tokens appearing in the completion. Accepts a list
#'   that maps tokens (specified by their token ID in the GPT tokenizer) to an
#'   associated bias value from `-100` to `100`. You can use this tokenizer tool
#'   (which works for both GPT-2 and GPT-3) to convert text to token IDs.
#'   Mathematically, the bias is added to the logits generated by the model
#'   prior to sampling. The exact effect will vary per model, but values between
#'   `-1` and `1` should decrease or increase likelihood of selection; values
#'   like `-100` or `100` should result in a ban or exclusive selection of the
#'   relevant token. As an example, you can pass `list("50256" = -100)` to
#'   prevent the `<|endoftext|>` token from being generated.
#' @param user optional; defaults to `NULL`; a length one character vector. A
#'   unique identifier representing your end-user, which will help OpenAI to
#'   monitor and detect abuse.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain completion(s) and
#'   supplementary information.
#' @examples \dontrun{
#' create_completion(
#'     engine = "text-davinci-002",
#'     prompt = "Say this is a test",
#'     max_tokens = 5
#' )
#'
#' logit_bias <- list(
#'     "11" = -100,
#'     "13" = -100
#' )
#' create_completion(
#'     engine_id = "ada",
#'     prompt = "Generate a question and an answer",
#'     n = 4,
#'     best_of = 4,
#'     logit_bias = logit_bias
#' )
#' }
#' @export
create_completion <- function(
        engine_id,
        prompt = "<|endoftext|>",
        suffix = NULL,
        max_tokens = 16,
        temperature = 1,
        top_p = 1,
        n = 1,
        stream = FALSE,
        logprobs = NULL,
        echo = FALSE,
        stop = NULL,
        presence_penalty = 0,
        frequency_penalty = 0,
        best_of = 1,
        logit_bias = NULL,
        user = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
        ) {

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(engine_id),
        assertthat::noNA(engine_id)
    )

    assertthat::assert_that(
        is.character(prompt),
        assertthat::noNA(prompt)
    )

    if (!is.null(suffix)) {
        assertthat::assert_that(
            assertthat::is.string(suffix),
            assertthat::noNA(suffix)
        )
    }

    assertthat::assert_that(
        assertthat::is.count(max_tokens)
    )

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

    if (!is.null(logprobs)) {
        assertthat::assert_that(
            assertthat::is.count(logprobs + 1),
            value_between(logprobs, 0, 5)

        )
    }

    assertthat::assert_that(
        assertthat::is.flag(echo),
        assertthat::noNA(echo)
    )

    if (!is.null(stop)) {
        assertthat::assert_that(
            is.character(stop),
            assertthat::noNA(stop),
            length_between(stop, 1, 4)
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

    assertthat::assert_that(
        assertthat::is.count(best_of)
    )

    assertthat::assert_that(
        best_of >= n
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

    task <- "completions"

    base_url <- glue::glue("https://api.openai.com/v1/engines/{engine_id}/{task}")

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
    body[["suffix"]] <- suffix
    body[["max_tokens"]] <- max_tokens
    body[["temperature"]] <- temperature
    body[["top_p"]] <- top_p
    body[["n"]] <- n
    body[["stream"]] <- stream
    body[["logprobs"]] <- logprobs
    body[["echo"]] <- echo
    body[["stop"]] <- stop
    body[["presence_penalty"]] <- presence_penalty
    body[["frequency_penalty"]] <- frequency_penalty
    body[["best_of"]] <- best_of
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
