#' Load Dependent Libraries

library("ggplot2")
library("ClassDiscovery")

#' Create NDVI figures and a gif for the AVHRR NDVI figure

NDVI_1989 <- read.csv("data/csvFiles/AVHRR_NDVI_WaterRemoved_1989.csv", header=FALSE)
y = 1:2889
x = 1:4587

ndviMatrix = t(data.matrix(NDVI_1989))
NDVIheatmap = image(x, y, ndviMatrix, ylim=c(2889,1), col=jetColors(64))

