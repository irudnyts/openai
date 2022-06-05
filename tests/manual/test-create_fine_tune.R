training_file <- system.file(
    "extdata", "sport_prepared_train.jsonl", package = "openai"
)
validation_file <- system.file(
    "extdata", "sport_prepared_train.jsonl", package = "openai"
)

training_info <- upload_file(training_file, "fine-tune")
validation_info <- upload_file(validation_file, "fine-tune")

info <- create_fine_tune(
    training_file = training_info$id,
    validation_file = validation_info$id,
    model = "ada",
    compute_classification_metrics = TRUE,
    classification_positive_class = " baseball" # Mind space in front
)
