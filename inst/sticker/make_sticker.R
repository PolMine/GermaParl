library(hexSticker)
library(RColorBrewer)
library(magick)

# imgurl <- "http://www.constructalia.com/repository/transfer/it/resources/ContenidoProyect/05358730FOTO_AMPLIADA.jpg"

imgurl <- "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUtUA4SwDMvXw8Y6zsa4EgH93VdpAkMrdpv67BmbeHPjgsqIvv"
plenary <- image_read(imgurl)
plenary_min <- image_crop(plenary, "270x179")
plenary_min_file <- file.path(tempdir(), "plenary_min.png")
image_write(plenary_min, path = plenary_min_file, format = "png")

sticker(
  plenary_min_file,
  package="GermaParl",
  p_size = 7,
  s_x = 1, s_y = 0.80, s_width = .66,
  h_fill = "white",
  h_color = "#004C93",
  p_color = "#004C93",
  filename="~/Lab/github/GermaParl/inst/sticker/hexsticker.png",
  # url = "https://polmine.github.io/GermaParl",
  # u_size = 1.35,
  # u_color = "#004C93",
  # spotlight = FALSE,
  # l_x = 0.8,
  # l_y = 0.7,
  # l_alpha = 0.8,
  # l_width = 10,
  # l_height = 4
)


polmineR_sticker <- image_read('~/Lab/github/GermaParl/inst/sticker/hexsticker.png')
polmineR_sticker_min <- image_scale(polmineR_sticker, "130x150")
image_write(polmineR_sticker_min, path = "~/Lab/github/GermaParl/inst/sticker/hexsticker.png", format = "png")
