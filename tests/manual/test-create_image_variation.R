image <- system.file("extdata", "astronaut.png", package = "openai")
create_image_variation(
    image = image,
    n = 1,
    size = "256x256",
    response_format = "url"
)
