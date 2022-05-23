#-------------------------------------------------------------------------------
# list_engines()

test_argument_validation(
    function_name = "list_engines",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "list_engines",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)

#-------------------------------------------------------------------------------
# retrieve_engine()

test_argument_validation(
    function_name = "retrieve_engine",
    argument_name = "engine",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "retrieve_engine",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "retrieve_engine",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
