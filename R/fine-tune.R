#' @export
create_fine_tune <- function(
        training_file,
        validation_file = NULL,
        model = c("ada", "babbage", "curie", "davinci"),
        n_epochs = 4,
        batch_size = NULL,
        learning_rate_multiplier = NULL,
        prompt_loss_weight = 0.1,
        compute_classification_metrics = FALSE,
        classification_n_classes = NULL,
        classification_positive_class = NULL,
        classification_betas = NULL,
        suffix = NULL
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

    # XXX: validate prompt_loss_weight
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
            assertthat::noNA(classification_positive_class),

        )
    }

    # XXX: validate classification_betas
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
        Authorization = paste("Bearer", openai_api_key)
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
    # Make a request and verify its result

    result <- httr::POST(
        url = base_url,
        httr::content_type_json(),
        httr::add_headers(.headers = headers),
        body = body,
        encode = "json"
    )

    verify_mime_type(result)

    httr::stop_for_status(result)

    #---------------------------------------------------------------------------
    # Parse the result of the request

    result %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

}
