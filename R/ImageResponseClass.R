images_response <- R6::R6Class(
    "ImagesResponse",
    public = list(
        created = NULL,
        data = NULL,
        initialize = function(created, data) {

            self$created <- created
            self$data <- data

        }
    )
)
