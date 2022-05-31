#-------------------------------------------------------------------------------
# retrieve_engine()

function_name <- "retrieve_engine"

test_argument_validation(
    function_name = function_name,
    argument_name = "engine_id",
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
