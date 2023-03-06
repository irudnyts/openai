create_chat_completion(
    messages = list(
        list(
            "role" = "system",
            "content" = "You are a helpful assistant."
        ),
        list(
            "role" = "user",
            "content" = "Who won the world series in 2020?"
        ),
        list(
            "role" = "assistant",
            "content" = "The Los Angeles Dodgers won the World Series in 2020."
        ),
        list(
            "role" = "user",
            "content" = "Where was it played?"
        )
    )
)
