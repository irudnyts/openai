verify_mime_type <- function(result) {
    if (!httr::http_type(result) %in% c("application/json", "text/event-stream")) {
        paste(
            "OpenAI API probably has been changed. If you see this, please",
            "rise an issue at: https://github.com/irudnyts/openai/issues"
        ) %>%
            stop()
    }

}
