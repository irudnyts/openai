library(hexSticker)
library(here)

image <- here("inst/figures/mini-dalle.png")

sticker(
    image,
    package = "openi",
    p_size = 20,
    s_x = 1,
    s_y = .75,
    p_color = "#419072",
    h_fill = "#eef5f4",
    h_color = "#419072",
    s_width = .4,
    s_height = .4,
    filename = "man/figures/logo.png"
)
