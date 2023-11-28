chat_completion <- R6::R6Class(
    "ChatCompletion",
    public = list(
        id = NULL,
        object = NULL,
        created = NULL,
        model = NULL,
        system_fingerprint = NULL,
        choices = NULL,
        usage = NULL,

        initialize = function(id, object, created, model, system_fingerprint,
                              choices, usage) {

            self$id <- id
            self$object <- object
            self$created <- created
            self$model <- model
            self$system_fingerprint <- system_fingerprint
            self$choices <- choices
            self$usage <- usage

        }
    )
)
