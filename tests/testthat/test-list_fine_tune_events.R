#-------------------------------------------------------------------------------
# list_fine_tune_events()

test_argument_validation(
    function_name = "list_fine_tune_events",
    argument_name = "fine_tune_id",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "list_fine_tune_events",
    argument_name = "stream",
    argument_type = "flag",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "list_fine_tune_events",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "list_fine_tune_events",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
