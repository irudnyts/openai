#' @export
openai <- R6::R6Class(
    "openai",
    public = list(
        api_key = NULL,
        organization = NULL,
        base_url = NULL,
        max_retries = NULL,

        chat = list(completions = list()),

        initialize = function(
            api_key = NULL,
            organization = NULL,
            base_url = NULL,
            # timeout = NULL,
            max_retries = NULL #,
            # default_headers = NULL,
            # default_query = NULL,
            # http_client = NULL,
            # .strict_response_validation = NULL
        ) {

            if (is.null(api_key))
                api_key <- Sys.getenv("OPENAI_API_KEY")

            if(is.null(organization))
                organization <- Sys.getenv("OPENAI_ORG_ID")

            if(is.null(base_url))
                base_url <- "https://api.openai.com/v1/"

            if(is.null(max_retries))
                max_retries <- 2

            self$api_key = api_key
            self$organization = organization
            self$base_url = base_url
            self$max_retries = max_retries

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
