# devtools::load_all()

# client <- OpenAI$new("your_api_key")
# client <- openai$new(Sys.getenv("OPENAI_API_KEY"))
client <- OpenAI(api_key = Sys.getenv("OPENAI_API_KEY"))

messages <- list(
    list("role" = "system",
         "content" = "You are a helpful assistant."),
    list("role" = "user",
         "content" = "Who won the world series in 2020?"),
    list("role" = "assistant",
         "content" = "The Los Angeles Dodgers won the World Series in 2020."),
    list("role" = "user",
         "content" = "Where was it played?")
)

client$chat$completions$create(
    model = "gpt-3.5-turbo",
    messages = messages
)
