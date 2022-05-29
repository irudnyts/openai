#-------------------------------------------------------------------------------
# retrieve_file_content()

function_name <- "retrieve_file_content"

test_argument_validation(
    function_name = function_name,
    argument_name = "file_id",
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
