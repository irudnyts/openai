create_image(
    prompt = "An astronaut riding a horse in a photorealistic style",
    n = 1,
    size = "256x256",
    response_format = "url"
)

# test `response_format = "b64_json"`

# response <- create_image(
#     prompt = "An astronaut riding a horse in a photorealistic style",
#     size = "256x256",
#     response_format = "b64_json"
# )
#
# image <- jsonlite::base64_dec(response$data$b64_json) %>%
#     png::readPNG()
#
# grid::grid.raster(image)
