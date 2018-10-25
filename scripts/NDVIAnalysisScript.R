source("../../scripts/NDVIFigureGenerator.R")
source("../../scripts/NDVIDataGenerator.R")
dataArray <- ArrayDataGenerator("data/csvFiles/")
GIFCreator(dataArray)