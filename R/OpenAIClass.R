#' @export
openai <- R6::R6Class(
    "openai",
    public = list(
        api_key = NULL,
        base_url = NULL,
        organization = NULL,
        chat = list(completions = list()),

        initialize = function(api_key) {

            self$api_key = api_key
            self$base_url = "https://api.openai.com/v1/"

            self$chat$completions$create <- private$chat_competions_create

        }

    ),
    private = list(
        chat_competions_create = function(model,
                                          messages = NULL,
                                          temperature = 1,
                                          top_p = 1,
                                          n = 1,
                                          stream = FALSE,
                                          stop = NULL,
                                          max_tokens = NULL,
                                          presence_penalty = 0,
                                          frequency_penalty = 0,
                                          logit_bias = NULL,
                                          user = NULL) {
            create_chat_completion(
                model = model,
                messages = messages,
                temperature = temperature,
                top_p = top_p,
                n = n,
                stream = stream,
                stop = stop,
                max_tokens = max_tokens,
                presence_penalty = presence_penalty,
                frequency_penalty = frequency_penalty,
                logit_bias = logit_bias,
                user = user,
                openai_api_key = self$api_key,
                openai_organization = self$organization
            )
        }
    )
)
