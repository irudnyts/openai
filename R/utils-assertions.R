#-------------------------------------------------------------------------------

value_between <- function(x, lower, upper) {
    x >= lower && x <= upper
}

assertthat::on_failure(value_between) <- function(call, env) {
    paste0(
        deparse(call$x),
        " is not between ",
        deparse(call$lower),
        " and ",
        deparse(call$upper)
    )
}

#-------------------------------------------------------------------------------

both_specified <- function(x, y) {
    x != 1 && y != 1
}

#-------------------------------------------------------------------------------

length_between <- function(x, lower, upper) {
    length(x) >= lower && length(x) <= upper
}

assertthat::on_failure(length_between) <- function(call, env) {
    paste0(
        "Length of ",
        deparse(call$x),
        " is not between ",
        deparse(call$lower),
        " and ",
        deparse(call$upper)
    )
}

#-------------------------------------------------------------------------------

n_characters_between <- function(x, lower, upper) {
    nchar(x) >= lower && nchar(x) <= upper
}

assertthat::on_failure(n_characters_between) <- function(call, env) {
    paste0(
        "Number of characters of ",
        deparse(call$x),
        " is not between ",
        deparse(call$lower),
        " and ",
        deparse(call$upper)
    )
}

#-------------------------------------------------------------------------------

is_false <- function(x) {
    !x
}

assertthat::on_failure(is_false) <- function(call, env) {
    paste0(deparse(call$x), " is not yet implemented.")
}

#-------------------------------------------------------------------------------

is_null <- function(x) {
    is.null(x)
}

assertthat::on_failure(is_null) <- function(call, env) {
    paste0(deparse(call$x), " is not yet implemented.")
}
