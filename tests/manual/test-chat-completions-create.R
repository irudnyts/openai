client <- OpenAI()
completion <- client$chat$completions$create(
    model = "gpt-4-1106-preview",
    messages = list(list("role" = "user", "content" = "What's up?"))
)

completion

completion$choices[[1]]$message$content
