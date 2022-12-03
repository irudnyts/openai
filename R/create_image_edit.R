#' Create image edit
#'
#' Creates an edited or extended image given an original image and a prompt. See
#' [this page](https://beta.openai.com/docs/api-reference/images/create-edit)
#' for details.
#'
#' For arguments description please refer to the [official
#' documentation](https://beta.openai.com/docs/api-reference/images/create-edit).
#'
#' @param image required; a length one character vector.
#' @param mask required; a length one character vector.
#' @param prompt required; a length one character vector.
#' @param n required; defaults to `1`; a length one numeric vector with the
#'   integer value greater than `0`.
#' @param size required; defaults to `"1024x1024"`; a length one character
#'   vector, one among `"256x256"`, `"512x512"`, and `"1024x1024"`.
#' @param response_format required; defaults to `"url"`; a length one character
#'   vector, one among `"url"` and `"b64_json"`.
#' @param user optional; defaults to `NULL`; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, an element of which contain either a link to the
#' edited image or the edited image decoded in Base64.
#' @examples \dontrun{
#' image <- system.file("extdata", "astronaut.png", package = "openai")
#' mask <- system.file("extdata", "mask.png", package = "openai")
#' create_image_edit(
#'     image = image,
#'     mask = mask,
#'     prompt = "goat",
#'     n = 1,
#'     response_format = "url"
#' )
#' }
#' @family image functions
#' @export
create_image_edit <- function(
        image,
        mask,
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

    assertthat::assert_that(
        assertthat::is.string(image),
        assertthat::noNA(image),
        file.exists(image),
        assertthat::is.readable(image)
    )

    assertthat::assert_that(
        assertthat::is.string(mask),
        assertthat::noNA(mask),
        file.exists(mask),
        assertthat::is.readable(mask)
    )

    assertthat::assert_that(
        assertthat::is.string(prompt),
        assertthat::noNA(prompt)
    )

    assertthat::assert_that(
        assertthat::is.count(n)
    )

    assertthat::assert_that(
        assertthat::is.string(size),
        assertthat::noNA(size)
    )

    assertthat::assert_that(
        assertthat::is.string(response_format),
        assertthat::noNA(response_format)
    )

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

    task <- "images/edits"

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
    body[["image"]] <- httr::upload_file(image)
    body[["mask"]] <- httr::upload_file(mask)
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
