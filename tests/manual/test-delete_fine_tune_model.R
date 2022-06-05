fine_tunes <- list_fine_tunes()

fine_tunes <- fine_tunes$data

id <- fine_tunes[!is.na(fine_tunes[, "fine_tuned_model"]), "fine_tuned_model"]

delete_fine_tune_model(model = id[1])
