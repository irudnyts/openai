between_zero_and_two <- function(x) {
    x >= 0 && x <= 2
}

assertthat::on_failure(between_zero_and_two) <- function(call, env) {
    paste0(deparse(call$x), " is not between zero and two")
}

between_zero_and_one <- function(x) {
    x >= 0 && x <= 2
}

assertthat::on_failure(between_zero_and_two) <- function(call, env) {
    paste0(deparse(call$x), " is not between zero and one")
}

### XXX
not_both_specified <- function(x, y) {
    x != 1 && y != 1
}
