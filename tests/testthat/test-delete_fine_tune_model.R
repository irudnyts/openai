#-------------------------------------------------------------------------------
# delete_fine_tune_model()

test_argument_validation(
    function_name = "delete_fine_tune_model",
    argument_name = "model",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "delete_fine_tune_model",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "delete_fine_tune_model",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)
