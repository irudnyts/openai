#-------------------------------------------------------------------------------
# list_files()

function_name <- "list_files"

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

#-------------------------------------------------------------------------------
# upload_file()

function_name <- "upload_file"

test_argument_validation(
    function_name = function_name,
    argument_name = "file",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = function_name,
    argument_name = "purpose",
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

#-------------------------------------------------------------------------------
# delete_file()

function_name <- "delete_file"

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

#-------------------------------------------------------------------------------
# retrieve_file()

function_name <- "retrieve_file"

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
