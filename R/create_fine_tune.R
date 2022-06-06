#' Create fine-tune
#'
#' Creates a job that fine-tunes a specified model based on a given dataset. See
#' [this page](https://beta.openai.com/docs/api-reference/fine-tunes/create) for
#' details.
#'
#' For arguments description please refer to the [official
#' documentation](https://beta.openai.com/docs/api-reference/fine-tunes/create).
#'
#' @param training_file required; a length one character vector.
#' @param validation_file optional; defaults to `NULL`; a length one character
#'   vector.
#' @param model model required; defaults to `"curie"`; a length one character
#'   vector, one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`.
#' @param n_epochs required; defaults to `4`; a length one numeric vector with
#'   the integer value greater than `0`.
#' @param batch_size optional; defaults to `NULL`; a length one numeric vector
#'   with the integer value greater than `0`.
#' @param learning_rate_multiplier optional; defaults to `NULL`; a length one
#'   numeric vector with the value greater than `0`.
#' @param prompt_loss_weight required; defaults to `0.1`; a length one numeric
#'   vector.
#' @param compute_classification_metrics required; defaults to `FLASE`; a length
#'   one logical vector.
#' @param classification_n_classes optional; defaults to `NULL`; a length one
#'   numeric vector with the value greater than `0`.
#' @param classification_positive_class optional; defaults to `NULL`; a length
#'   one character vector.
#' @param classification_betas optional; defaults to `NULL`; a list elements of
#'   which are numeric values greater than `0`.
#' @param suffix optional; defaults to `NULL`; a length one character vector.
#' @param openai_api_key required; defaults to `Sys.getenv("OPENAI_API_KEY")`
#'   (i.e., the value is retrieved from the `.Renviron` file); a length one
#'   character vector. Specifies OpenAI API key.
#' @param openai_organization optional; defaults to `NULL`; a length one
#'   character vector. Specifies OpenAI organization.
#' @return Returns a list, elements of which contain information about the
#'   fine-tune.
#'
#' @examples \dontrun{
#' training_file <- system.file(
#'     "extdata", "sport_prepared_train.jsonl", package = "openai"
#' )
#' validation_file <- system.file(
#'     "extdata", "sport_prepared_train.jsonl", package = "openai"
#' )
#'
#' training_info <- upload_file(training_file, "fine-tune")
#' validation_info <- upload_file(validation_file, "fine-tune")
#'
#' info <- create_fine_tune(
#'     training_file = training_info$id,
#'     validation_file = validation_info$id,
#'     model = "ada",
#'     compute_classification_metrics = TRUE,
#'     classification_positive_class = " baseball" # Mind space in front
#' )
#' }
#' @family fine-tune functions
#' @export
create_fine_tune <- function(
        training_file,
        validation_file = NULL,
        model = c("curie", "ada", "babbage", "davinci"),
        n_epochs = 4,
        batch_size = NULL,
        learning_rate_multiplier = NULL,
        prompt_loss_weight = 0.1,
        compute_classification_metrics = FALSE,
        classification_n_classes = NULL,
        classification_positive_class = NULL,
        classification_betas = NULL,
        suffix = NULL,
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = NULL
) {

    model <- match.arg(model)

    #---------------------------------------------------------------------------
    # Validate arguments

    assertthat::assert_that(
        assertthat::is.string(training_file),
        assertthat::noNA(training_file)
    )

    if (!is.null(validation_file)) {
        assertthat::assert_that(
            assertthat::is.string(validation_file),
            assertthat::noNA(validation_file)
        )
    }

    assertthat::assert_that(
        assertthat::is.string(model),
        assertthat::noNA(model)
    )

    assertthat::assert_that(
        assertthat::is.count(n_epochs)
    )

    if (!is.null(batch_size)) {
        assertthat::assert_that(
            assertthat::is.count(batch_size)
        )
    }

    if (!is.null(learning_rate_multiplier)) {
        assertthat::assert_that(
            assertthat::is.number(learning_rate_multiplier),
            assertthat::noNA(learning_rate_multiplier),
            value_between(learning_rate_multiplier, 0, Inf)
        )
    }

    assertthat::assert_that(
        assertthat::is.number(prompt_loss_weight),
        assertthat::noNA(prompt_loss_weight)
    )

    assertthat::assert_that(
        assertthat::is.flag(compute_classification_metrics),
        assertthat::noNA(compute_classification_metrics)
    )

    if (!is.null(classification_n_classes)) {
        assertthat::assert_that(
            assertthat::is.count(classification_n_classes),
            value_between(classification_n_classes, 2, Inf)
        )
    }

    if (!is.null(classification_positive_class)) {
        assertthat::assert_that(
            assertthat::is.string(classification_positive_class),
            assertthat::noNA(classification_positive_class)
        )
    }

    if (!is.null(classification_betas)) {
        assertthat::assert_that(
            is.list(classification_betas)
        )
    }

    if (!is.null(suffix)) {
        assertthat::assert_that(
            assertthat::is.string(suffix),
            assertthat::noNA(suffix),
            n_characters_between(suffix, 1, 40)
        )
    }

    #---------------------------------------------------------------------------
    # Build path parameters

    task <- "fine-tunes"

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
    body[["training_file"]] <- training_file
    body[["validation_file"]] <- validation_file
    body[["model"]] <- model
    body[["n_epochs"]] <- n_epochs
    body[["batch_size"]] <- batch_size
    body[["learning_rate_multiplier"]] <- learning_rate_multiplier
    body[["prompt_loss_weight"]] <- prompt_loss_weight
    body[["compute_classification_metrics"]] <- compute_classification_metrics
    body[["classification_n_classes"]] <- classification_n_classes
    body[["classification_positive_class"]] <- classification_positive_class
    body[["classification_betas"]] <- classification_betas
    body[["suffix"]] <- suffix

    #---------------------------------------------------------------------------
    # Make a request and parse it

    response <- httr::POST(
        url = base_url,
        httr::add_headers(.headers = headers),
        body = body,
        encode = "json"
    )

    response <- httr::GET(
        url = base_url,
        httr::add_headers(.headers = headers),
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
