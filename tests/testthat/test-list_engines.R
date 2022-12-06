#-------------------------------------------------------------------------------
# list_engines()

function_name <- "list_engines"

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
