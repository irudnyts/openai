create_completion(
    engine = "text-davinci-002",
    prompt = "Say this is a test",
    max_tokens = 5
)

logit_bias <- list(
    "11" = -100,
    "13" = -100
)
create_completion(
    engine_id = "ada",
    prompt = "Generate a question and an answer",
    n = 4,
    best_of = 4,
    logit_bias = logit_bias
)
