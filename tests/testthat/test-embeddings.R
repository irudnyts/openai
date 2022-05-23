#-------------------------------------------------------------------------------
# embedding()

test_argument_validation(
    function_name = "embedding",
    argument_name = "engine",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "embedding",
    argument_name = "input",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "embedding",
    argument_name = "user",
    argument_type = "string",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "embedding",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "embedding",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
