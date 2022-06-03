#' Create edit
#'
#' Creates a new edit for the provided input, instruction, and parameters. See
#' \href{https://beta.openai.com/docs/api-reference/edits/create}{this page}
#' for details.
#'
#' Given a prompt and an instruction, the model will return an edited version of
#' the prompt.
#'
#' @param engine_id required; a length one character vector. The ID of the
#' engine to use for this request.
#' @param input required; defaults to \code{'"'}; a length one character vector.
#' The input text to use as a starting point for the edit.
#' @param instruction required; a length one character vector. The instruction
#' that tells the model how to edit the prompt.
#' @param temperature required; defaults to \code{1}; a length one numeric
#' vector with the value between \code{0} and \code{2}. What sampling
#' temperature to use. Higher values means the model will take more risks. Try
#' \code{0.9} for more creative applications, and \code{0} (argmax sampling) for
#' ones with a well-defined answer. We generally recommend altering (i.e.,
#' setting the value different from \code{1}) this or \code{top_p} but not both.
#' @param top_p required; defaults to \code{1}; a length one numeric
#' vector with the value between \code{0} and \code{1}. An alternative to
#' sampling with temperature, called nucleus sampling, where the model considers
#' the results of the tokens with top_p probability mass. So \code{0.1} means
#' only the tokens comprising the top 10\% probability mass are considered. We
#' generally recommend altering (i.e., setting the value different from
#' \code{1}) this or \code{temperature} but not both.
#' @param openai_api_key required; defaults to
#' \code{Sys.getenv("OPENAI_API_KEY")} (i.e., the value is retrieved from the
#' \code{.Renviron} file); a length one character vector. Specifies OpenAI API
#' key.
#' @param openai_organization optional; defaults to \code{NULL}; a length one
#' character vector. Specifies OpenAI organization.
#' @return Returns a list, an elements of which contain edited version of prompt
#' and supplementary information.
#' @examples \dontrun{
#' create_edit(
#'     engine_id = "text-davinci-edit-001",
#'     input = "What day of the wek is it?",
#'     instruction = "Fix the spelling mistakes"
#' )
#' }
#' @export
create_edit <- function(
        engine_id,
        input = '"',
        instruction,
        temperature = 1,
        top_p = 1,
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
        assertthat::is.string(input),
        assertthat::noNA(input)
    )

    assertthat::assert_that(
        assertthat::is.string(instruction),
        assertthat::noNA(instruction)
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

    task <- "edits"

    base_url <- glue::glue(
        "https://api.openai.com/v1/engines/{engine_id}/{task}"
    )

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
    body[["input"]] <- input
    body[["instruction"]] <- instruction
    body[["temperature"]] <- temperature
    body[["top_p"]] <- top_p

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
