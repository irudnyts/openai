#-------------------------------------------------------------------------------
# create_moderation()

function_name <- "create_moderation"

test_argument_validation(
    function_name = function_name,
    argument_name = "input",
    argument_type = "character",
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
