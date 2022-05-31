#-------------------------------------------------------------------------------
# create_completion()

function_name <- "create_completion"

test_argument_validation(
    function_name = function_name,
    argument_name = "engine_id",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "prompt",
    argument_type = "character",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "suffix",
    argument_type = "character",
    allow_null = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "max_tokens",
    argument_type = "count",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "temperature",
    argument_type = "number",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "top_p",
    argument_type = "number",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "n",
    argument_type = "count",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "stream",
    argument_type = "flag",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "logprobs",
    argument_type = "count",
    allow_null = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "echo",
    argument_type = "flag",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "stop",
    argument_type = "character",
    allow_null = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "presence_penalty",
    argument_type = "number",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "frequency_penalty",
    argument_type = "number",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "best_of",
    argument_type = "count",
    allow_null = FALSE
)

# test_argument_validation(
#     function_name = function_name,
#     argument_name = "logit_bias",
#     argument_type = "count",
#     allow_null = FALSE
# )

test_argument_validation(
    function_name = function_name,
    argument_name = "user",
    argument_type = "string",
    allow_null = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
