#' Create transcription
#'
#' Transcribes audio into the input language. See
#' [this page](https://platform.openai.com/docs/api-reference/audio/create)
#' for details.
#'
#' For arguments description please refer to the [official
#' documentation](https://platform.openai.com/docs/api-reference/audio/create).
#'
#' @param file required; a length one character vector.
#' @param model required; a length one character vector.
#' @param prompt optional; defaults to `NULL`; a length one character vector.
#' @param response_format required; defaults to `"json"`; length one character
#'   vector with one of "json", "verbose_json", "text", "srt" or "vtt".
#' @param temperature required; defaults to `1`; a length one numeric vector
#'   with the value between `0` and `2`.
#' @param language optional; defaults to `NULL`; a length one character vector
#'   with an ISO 639-1 language code.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain a transcription and
#'   supplementary information, if the response format is json, otherwise
#'   the transcription text is returned
#' @examples \dontrun{
#' voice_sample_en <- system.file(
#'     "extdata", "sample-en.m4a", package = "openai"
#' )
#' create_transcription(file = voice_sample_en, model = "whisper-1")
#' }
#' @family audio functions
#' @export
create_transcription <- function(
        file,
        model,
        prompt = NULL,
        response_format = c("json", "text", "srt", "verbose_json", "vtt"),
        temperature = 0,
        language = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    response_format <- match.arg(response_format)

    parse_json <- function(x) jsonlite::fromJSON(txt = x, flatten = TRUE)
    parse_fn <- switch(response_format, json = parse_json, verbose_json = parse_json)

    #---------------------------------------------------------------------------
    # Validate arguments

    allowed_extensions <- c(
        "mp3", "mp4", "mpeg", "mpga", "m4a", "wav", "webm"
    )
    assertthat::assert_that(
        assertthat::is.string(file),
        assertthat::noNA(file),
        file.exists(file),
        assertthat::is.readable(file),
        tools::file_ext(file) %in% allowed_extensions
    )

    assertthat::assert_that(
        assertthat::is.string(model),
        assertthat::noNA(model)
    )

    if (!is.null(prompt)) {
        assertthat::assert_that(
            assertthat::is.string(prompt),
            assertthat::noNA(prompt)
        )
    }

    assertthat::assert_that(
        assertthat::is.string(response_format),
        assertthat::noNA(response_format)
    )

    assertthat::assert_that(
        assertthat::is.number(temperature),
        assertthat::noNA(temperature),
        value_between(temperature, 0, 2)
    )

    if (!is.null(language)) {
        assertthat::assert_that(
            assertthat::is.string(language),
            assertthat::noNA(language),
            language %in% openai::iso_languages
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

    task <- "audio/transcriptions"

    base_url <- glue::glue("https://api.openai.com/v1/{task}")

    headers <- c(
        "Authorization" = paste("Bearer", openai_api_key),
        "Content-Type" = "multipart/form-data"
    )

    if (!is.null(openai_organization)) {
        headers["OpenAI-Organization"] <- openai_organization
    }

    #---------------------------------------------------------------------------
    # Build request body

    body <- list()
    body[["file"]] <- httr::upload_file(file)
    body[["model"]] <- model
    body[["prompt"]] <- prompt
    body[["response_format"]] <- response_format
    body[["temperature"]] <- temperature
    body[["language"]] <- language

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::add_headers(.headers = headers),
        body = body,
        encode = "multipart"
    )

    if (is.null(parse_fn)) {
        if (httr::http_error(response))
            stop(sprintf("OpenAI API request failed [%s]", httr::http_status(response)),
                 call. = FALSE)
        return (httr::content(response, as = "text", encoding = "UTF-8"))
    }

    verify_mime_type(response)

    parsed <- response %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        parse_fn()

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
