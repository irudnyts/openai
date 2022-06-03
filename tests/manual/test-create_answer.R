create_answer(
    search_model = "ada",
    model = "curie",
    question = "How many red apples do I have?",
    documents = c("I have five green apples.", "I love oranges."),
    examples_context = "Jack has three brothers and one sister. His sister is sad",
    examples = list(
        c("How many siblings has Jack?", "Three"),
        c("Who is sad?", "Jack's sister is.")
    ),
    max_tokens = 5,
    stop = c("\n", "<|endoftext|>"),
)
