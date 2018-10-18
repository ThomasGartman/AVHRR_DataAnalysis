#' Load Dependent Libraries

library("ggplot2")
library("reshape2")

#' Create NDVI figures and a gif for the AVHRR NDVI figure

NDVI_1989 <- read.csv("data/csvFiles/AVHRR_NDVI_WaterRemoved_1989.csv", header=FALSE)
x = 1:4587
y = 1:2889

ndviMatrix = data.matrix(NDVI_1989)
ndviMatrix = t(ndviMatrix)
NDVIheatmap <- image(x, y, ndviMatrix)
