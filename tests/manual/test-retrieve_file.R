file <- system.file("extdata", "classification-file.jsonl", package = "openai")
file_info <- upload_file(file = file, purpose = "classification")
retrieve_file(file_info$id)
