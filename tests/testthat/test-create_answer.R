#-------------------------------------------------------------------------------
# create_answer()

function_name <- "create_answer"

test_argument_validation(
    function_name = function_name,
    argument_name = "model",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "question",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "examples_context",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "documents",
    argument_type = "character",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "file",
    argument_type = "string",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "search_model",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "max_rerank",
    argument_type = "count",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "temperature",
    argument_type = "number",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "logprobs",
    argument_type = "count",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "max_tokens",
    argument_type = "count",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "stop",
    argument_type = "character",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "n",
    argument_type = "count",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "return_metadata",
    argument_type = "flag",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "return_prompt",
    argument_type = "flag",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "user",
    argument_type = "string",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE,
    suppress_warnings = TRUE
)
