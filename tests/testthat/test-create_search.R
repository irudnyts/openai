#-------------------------------------------------------------------------------
# create_search()

function_name <- "create_search"

test_argument_validation(
    function_name = function_name,
    argument_name = "engine",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "query",
    argument_type = "string",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "documents",
    argument_type = "character",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "file",
    argument_type = "string",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "max_rerank",
    argument_type = "count",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "return_metadata",
    argument_type = "flag",
    allow_null = FALSE,
    suppress_warnings = TRUE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "user",
    argument_type = "string",
    allow_null = TRUE,
    suppress_warnings = TRUE
)

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
