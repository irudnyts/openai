#-------------------------------------------------------------------------------
# create_transcription()

function_name <- "create_transcription"

test_argument_validation(
    function_name = function_name,
    argument_name = "file",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "model",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "prompt",
    argument_type = "character",
    allow_null = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "response_format",
    argument_type = "string",
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
    argument_name = "language",
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
