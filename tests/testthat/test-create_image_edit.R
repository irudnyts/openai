#-------------------------------------------------------------------------------
# create_image_edit()

function_name <- "create_image_edit"

test_argument_validation(
    function_name = function_name,
    argument_name = "image",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "mask",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "prompt",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "n",
    argument_type = "count",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "size",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "response_format",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "user",
    argument_type = "string",
    allow_null = TRUE
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
