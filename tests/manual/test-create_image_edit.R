image <- system.file("extdata", "astronaut.png", package = "openai")
mask <- system.file("extdata", "mask.png", package = "openai")

create_image_edit(
    image = image,
    mask = mask,
    prompt = "goat",
    n = 1,
    response_format = "url"
)
