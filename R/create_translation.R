#' Create translation
#'
#' Translates audio into into English. See
#' [this page](https://platform.openai.com/docs/api-reference/audio/create)
#' for details.
#'
#' For arguments description please refer to the [official
#' documentation](https://platform.openai.com/docs/api-reference/audio/create).
#'
#' @param file required; a length one character vector.
#' @param model required; a length one character vector equals to `"whisper-1"`.
#' @param prompt optional; defaults to `NULL`; a length one character vector.
#' @param response_format required; defaults to `"json"`; length one character
#'   vector equals to `"json"`. **Currently only `"json"` is implemented.**
#' @param temperature required; defaults to `1`; a length one numeric vector
#'   with the value between `0` and `2`.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain a transcription and
#'   supplementary information.
#' @examples \dontrun{
#' voice_sample_ua <- system.file(
#'     "extdata", "sample-ua.m4a", package = "openai"
#' )
#' create_translation(file = voice_sample_ua)
#' }
#' @family audio functions
#' @export
create_translation <- function(
        file,
        model = "whisper-1",
        prompt = NULL,
        response_format = "json", # json, text, srt, verbose_json, or vtt
        temperature = 0,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    model <- match.arg(model)
    response_format <- match.arg(response_format)

    #---------------------------------------------------------------------------
    # Validate arguments

    allowed_extenssions <- c(
        "mp3", "mp4", "mpeg", "mpga", "m4a", "wav", "webm"
    )
    assertthat::assert_that(
        assertthat::is.string(file),
        assertthat::noNA(file),
        file.exists(file),
        assertthat::is.readable(file),
        tools::file_ext(file) %in% allowed_extenssions
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

    task <- "audio/translations"

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

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::add_headers(.headers = headers),
        body = body,
        encode = "multipart"
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
