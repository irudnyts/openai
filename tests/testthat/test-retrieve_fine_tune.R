#-------------------------------------------------------------------------------
# retrieve_fine_tune()

test_argument_validation(
    function_name = "retrieve_fine_tune",
    argument_name = "fine_tune_id",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "retrieve_fine_tune",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "retrieve_fine_tune",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
