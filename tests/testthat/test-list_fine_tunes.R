#-------------------------------------------------------------------------------
# list_fine_tunes()

test_argument_validation(
    function_name = "list_fine_tunes",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "list_fine_tunes",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
