#-------------------------------------------------------------------------------
# create_fine_tune()

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "training_file",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "validation_file",
    argument_type = "string",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "model",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "n_epochs",
    argument_type = "count",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "batch_size",
    argument_type = "count",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "learning_rate_multiplier",
    argument_type = "number",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "prompt_loss_weight",
    argument_type = "number",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "compute_classification_metrics",
    argument_type = "flag",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "classification_n_classes",
    argument_type = "count",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "classification_positive_class",
    argument_type = "string",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "suffix",
    argument_type = "string",
    allow_null = TRUE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "create_fine_tune",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)

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

#-------------------------------------------------------------------------------
# cancel_fine_tune()

test_argument_validation(
    function_name = "cancel_fine_tune",
    argument_name = "fine_tune_id",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "cancel_fine_tune",
    argument_name = "openai_api_key",
    argument_type = "string",
    allow_null = FALSE
)

test_argument_validation(
    function_name = "cancel_fine_tune",
    argument_name = "openai_organization",
    argument_type = "string",
    allow_null = TRUE
)

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
