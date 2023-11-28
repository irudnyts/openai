#' @export
openai <- R6::R6Class(
    "OpenAI",
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
        chat_competions_create = function(
            messages,
            model,
            frequency_penalty = NULL,
            logit_bias = NULL,
            max_tokens = NULL,
            n = NULL,
            presence_penalty = NULL,
            response_format = NULL,
            seed = NULL,
            stop = NULL,
            strem = NULL,
            temperature = NULL,
            top_p = NULL,
            tools = NULL,
            tool_choice = NULL,
            user = NULL,
            function_call = NULL,
            functions = NULL
        ) {
            chat_completions_create(
                messages = messages,
                model = model,
                frequency_penalty = frequency_penalty,
                logit_bias = logit_bias,
                max_tokens = max_tokens,
                n = n,
                presence_penalty = presence_penalty,
                response_format = response_format,
                seed = seed,
                stop = stop,
                strem = strem,
                temperature = temperature,
                top_p = top_p,
                tools = tools,
                tool_choice = tool_choice,
                user = user,
                function_call = function_call,
                functions = functions,

                api_key = self$api_key,
                organization = self$organization,
                base_url = self$base_url,
                max_retries = self$max_retries
            )
        }
    )
)
