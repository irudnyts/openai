test_argument_validation <- function(
        function_name,
        argument_name,
        argument_type = c("character", "string", "number", "count", "flag"),
        allow_null = FALSE,
        suppress_warnings = FALSE
) {

    argument_type <- match.arg(argument_type)

    if (argument_type == "character") {
        non_valid_values <- list(NA_character_, 35, NA)
    } else if (argument_type == "string") {
        non_valid_values <- list(NA_character_, c("one", "two"), 35, NA)
    } else if (argument_type == "number") {
        non_valid_values <- list(NA_character_, NA_integer_, NaN)
    } else if (argument_type == "count") {
        non_valid_values <- list(NA_character_, -10, 0.5, NA_integer_)
    } else if (argument_type == "flag") {
        non_valid_values <- list(NA, NA_integer_, 32, "TRUE")
    }

    if (!allow_null) {
        non_valid_values <- append(non_valid_values, list(NULL))
    }

    test_that(
        paste0(function_name, "() validates ", argument_name), {
            purrr::walk(
                non_valid_values,
                function(x) {

                    function_object <- match.fun(function_name)

                    argument_object <- list()

                    argument_object[[argument_name]] <- x

                    if (is.null(x))
                        argument_object[argument_name] <- list(NULL)

                    if (suppress_warnings) {
                        suppressWarnings(
                            expect_error(
                                do.call(
                                    what = function_object,
                                    args = argument_object
                                )
                            )
                        )
                    } else {
                        expect_error(
                            do.call(
                                what = function_object,
                                args = argument_object
                            )
                        )
                    }



                }
            )
        })

}
