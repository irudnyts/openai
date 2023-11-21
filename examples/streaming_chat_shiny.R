library(openai)
library(shiny)
library(promises)
library(future)
plan(multisession)

temp_stream_content <- tempfile(fileext = ".rds")
temp_finished <- tempfile(fileext = ".rds")

stream_parser <- function(x) {
    stream_content <- character()
    finished <- FALSE
    for (i in seq_along(x)) {
        stream_content <- paste0(stream_content, x[[i]]$choices$delta.content)
        finished <- !is.na(x[[i]]$choices$finish_reason)
    }
    list(
        stream_content = stream_content,
        finished = finished
    )
}

ui <- fluidPage(
    selectInput(inputId = "model", label = "Select model", choices = c("gpt-4", "gpt-3.5-turbo")),
    textAreaInput(inputId = "prompt", label = "Enter your prompt here", value = "Count to 100"),
    actionButton(inputId = "send", label = "Send"),
    textOutput(outputId = "answer")
)

server <- function(input, output, session) {
    finished <- reactiveVal(TRUE)
    observeEvent(input$send, {
        saveRDS(character(), temp_stream_content)
        prompt <- input$prompt
        model <- input$model
        future_promise({
            create_chat_completion(
                model = model,
                messages = list(
                    list(
                        "role" = "system",
                        "content" = "You are a helpful assistant."
                    ),
                    list(
                        "role" = "user",
                        "content" = prompt
                    )
                ),
                stream = TRUE,
                stream_function = function(x) {
                    rds_content <- readRDS(temp_stream_content)
                    stream <- stream_parser(x)
                    stream_content <- paste0(rds_content, stream$stream_content)
                    saveRDS(stream_content, temp_stream_content)
                    saveRDS(stream$finished, temp_finished)
                }
            )
        })
        finished(FALSE)
        saveRDS(finished(), temp_finished)
    })
    output$answer <- renderText({
        if (input$send > 0 && !finished()) {
            invalidateLater(250)
        }
        if (file.exists(temp_stream_content)) {
            finished(readRDS(temp_finished))
            readRDS(temp_stream_content)
        }
    })
}

shinyApp(ui, server)
