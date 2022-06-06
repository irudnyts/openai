#' Create edit
#'
#' Creates an edit based on the provided input, instruction, and parameters. See
#' [this page](https://beta.openai.com/docs/api-reference/edits/create) for
#' details.
#'
#' For arguments description please refer to the [official
#' documentation](https://beta.openai.com/docs/api-reference/edits/create).
#'
#' @param engine_id required; a length one character vector.
#' @param input required; defaults to `'"'`; a length one character vector.
#' @param instruction required; a length one character vector.
#' @param temperature required; defaults to `1`; a length one numeric vector
#'   with the value between `0` and `2`.
#' @param top_p required; defaults to `1`; a length one numeric vector with the
#'   value between `0` and `1`.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain edited version of prompt
#'   and supplementary information.
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
