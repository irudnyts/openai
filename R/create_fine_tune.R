#' Create fine-tune
#'
#' Creates a job that fine-tunes a specified model from a given dataset. See
#' [this page](https://beta.openai.com/docs/api-reference/fine-tunes/create) for
#' details.
#'
#' Manage fine-tuning jobs to tailor a model to your specific training data.
#' Creates a job that fine-tunes a specified model from a given dataset.
#' Response includes details of the enqueued job including job status and the
#' name of the fine-tuned models once complete. Related guide: [Fine-tune
#' models](https://beta.openai.com/docs/guides/fine-tuning).
#'
#' @param training_file required; a length one character vector. The ID of an
#'   uploaded file that contains training data. See [upload_file()] for how to
#'   upload a file. Your dataset must be formatted as a JSONL file, where each
#'   training example is a JSON object with the keys "prompt" and "completion".
#'   Additionally, you must upload your file with the purpose `fine-tune`. See
#'   the [fine-tuning
#'   guide](https://beta.openai.com/docs/guides/fine-tuning/creating-training-data)
#'   for more details.
#' @param validation_file optional; defaults to `NULL`; a length one character
#'   vector. The ID of an uploaded file that contains validation data. If you
#'   provide this file, the data is used to generate validation metrics
#'   periodically during fine-tuning. These metrics can be viewed in the
#'   [fine-tuning results
#'   file](https://beta.openai.com/docs/guides/fine-tuning/analyzing-your-fine-tuned-model).
#'   Your train and validation data should be mutually exclusive. Your dataset
#'   must be formatted as a JSONL file, where each validation example is a JSON
#'   object with the keys "prompt" and "completion". Additionally, you must
#'   upload your file with the purpose `fine-tune`. See the [fine-tuning
#'   guide](https://beta.openai.com/docs/guides/fine-tuning/creating-training-data)
#'   for more details.
#' @param model model required; defaults to `"curie"`; a length one character
#'   vector, one among `"ada"`, `"babbage"`, `"curie"`, and `"davinci"`. The
#'   name of the base model to fine-tune. To learn more about these models, see
#'   the [Engines](https://beta.openai.com/docs/engines) documentation.
#' @param n_epochs required; defaults to `4`; a length one numeric vector with
#'   the integer value greater than `0`. The number of epochs to train the model
#'   for. An epoch refers to one full cycle through the training dataset.
#' @param batch_size optional; defaults to `NULL`; a length one numeric vector
#'   with the integer value greater than `0`. The batch size to use for
#'   training. The batch size is the number of training examples used to train a
#'   single forward and backward pass. By default, the batch size will be
#'   dynamically configured to be ~0.2% of the number of examples in the
#'   training set, capped at 256 - in general, we've found that larger batch
#'   sizes tend to work better for larger datasets.
#' @param learning_rate_multiplier optional; defaults to `NULL`; a length one
#'   numeric vector with the value greater than `0`. The learning rate
#'   multiplier to use for training. The fine-tuning learning rate is the
#'   original learning rate used for pretraining multiplied by this value. By
#'   default, the learning rate multiplier is the 0.05, 0.1, or 0.2 depending on
#'   final `batch_size` (larger learning rates tend to perform better with
#'   larger batch sizes). We recommend experimenting with values in the range
#'   0.02 to 0.2 to see what produces the best results.
#' @param prompt_loss_weight required; defaults to `0.1`; a length one numeric
#'   vector. The weight to use for loss on the prompt tokens. This controls how
#'   much the model tries to learn to generate the prompt (as compared to the
#'   completion which always has a weight of 1.0), and can add a stabilizing
#'   effect to training when completions are short. If prompts are extremely
#'   long (relative to completions), it may make sense to reduce this weight so
#'   as to avoid over-prioritizing learning the prompt.
#' @param compute_classification_metrics required; defaults to `FLASE`; a length
#'   one logical vector. If set, we calculate classification-specific metrics
#'   such as accuracy and F-1 score using the validation set at the end of every
#'   epoch. These metrics can be viewed in the [results
#'   file](https://beta.openai.com/docs/guides/fine-tuning/analyzing-your-fine-tuned-model).
#'   In order to compute classification metrics, you must provide a
#'   `validation_file`. Additionally, you must specify
#'   `classification_n_classes` for multiclass classification or
#'   `classification_positive_class` for binary classification.
#' @param classification_n_classes optional; defaults to `NULL`; a length one
#'   numeric vector with the value greater than `0`. The number of classes in a
#'   classification task. This parameter is required for multiclass
#'   classification.
#' @param classification_positive_class optional; defaults to `NULL`; a length
#'   one character vector. The positive class in binary classification. This
#'   parameter is needed to generate precision, recall, and F1 metrics when
#'   doing binary classification.
#' @param classification_betas optional; defaults to `NULL`; a list elements of
#'   which are numeric values greater than `0`. If this is provided, we
#'   calculate F-beta scores at the specified beta values. The F-beta score is a
#'   generalization of F-1 score. This is only used for binary classification.
#'   With a beta of 1 (i.e. the F-1 score), precision and recall are given the
#'   same weight. A larger beta score puts more weight on recall and less on
#'   precision. A smaller beta score puts more weight on precision and less on
#'   recall.
#' @param suffix optional; defaults to `NULL`; a length one character vector. A
#'   string of up to 40 characters that will be added to your fine-tuned model
#'   name. For example, a `suffix` of "custom-model-name" would produce a model
#'   name like `ada:ft-your-org:custom-model-name-2022-02-15-04-21-04`.
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
