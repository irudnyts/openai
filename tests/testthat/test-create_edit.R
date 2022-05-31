#-------------------------------------------------------------------------------
# create_edit()

function_name <- "create_edit"

test_argument_validation(
    function_name = function_name,
    argument_name = "engine_id",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "input",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "instruction",
    argument_type = "character",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "temperature",
    argument_type = "number",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "top_p",
    argument_type = "number",
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
