create_classification(
    search_model = "ada",
    model = "curie",
    examples = list(
        c("A happy moment", "Positive"),
        c("I am sad.", "Negative"),
        c("I am feeling awesome", "Positive")
    ),
    query = "I'm ok",
    labels = c("Positive", "Negative", "Neutral")
)
