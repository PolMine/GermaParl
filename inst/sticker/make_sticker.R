library(hexSticker)
library(RColorBrewer)

# imgurl <- "http://www.constructalia.com/repository/transfer/it/resources/ContenidoProyect/05358730FOTO_AMPLIADA.jpg"

imgurl <- "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUtUA4SwDMvXw8Y6zsa4EgH93VdpAkMrdpv67BmbeHPjgsqIvv"

sticker(
  imgurl,
  package="GermaParl",
  p_size = 6,
  s_x = 1, s_y = 0.80, s_width = .63,
  h_fill = "white",
  h_color = "#004C93",
  p_color = "#004C93",
  filename="~/Lab/github/GermaParl/inst/sticker/hexsticker.png",
  url = "https://polmine.github.io/GermaParl",
  u_size = 1.35,
  u_color = "#004C93",
  spotlight = FALSE,
  l_x = 0.8,
  l_y = 0.7,
  l_alpha = 0.8,
  l_width = 10,
  l_height = 4
)
