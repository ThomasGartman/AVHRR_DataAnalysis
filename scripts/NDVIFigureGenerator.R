#' Create NDVI figures and a gif for the AVHRR NDVI figure

NDVI_1989 <- read.csv("data/csvFiles/AVHRR_NDVI_WaterRemoved_1989.csv", header=FALSE)
NDVI_1989Numeric <-data.matrix(NDVI_1989)
NDVIheatmap <- heatmap(NDVI_1989Numeric)