client <- OpenAI()
completion <- client$chat$completions$create(
    model = "gpt-4-1106-preview",
    messages = list(list("role" = "user", "content" = "What's up?"))
)

completion

completion$choices[[1]]$message$content

#-------------------------------------------------------------------------------

client <- OpenAI()
completion <- client$chat$completions$create(
    model = "gpt-3.5-turbo",
    messages = list(list("role" = "user", "content" = "What's up?")),
    logprobs = TRUE,
    top_logprobs = 2
)

completion$choices[[1]]$logprobs
