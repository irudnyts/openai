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
