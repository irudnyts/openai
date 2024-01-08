client <- OpenAI()
images <- client$images$generate(
    prompt = "Big horse"
)

images$data[[1]]$url
