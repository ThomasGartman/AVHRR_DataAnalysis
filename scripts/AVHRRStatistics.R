#' This script carries the statistics required for the AVHRR project
#'
#' Namely this function will need to accomplish or manage:
#'
#'	1. Read in appropriate data files into the correct matrix shape.
#'	2. Vectorize all matrices.
#'	3. Internally check to ensure all vectors have consistant NAs, then remove them (keep track of what was removed)
#'	4. Begin constructing models

########################################
# Functions Called
########################################
source("scripts/VectorizeMatrices.R")

########################################
#Read in Data
########################################
#Predictor 1 - Population
Landscan2002Matrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_Population_WaterRemoved_2002.csv", header = FALSE))
Landscan2017Matrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_Population_WaterRemoved_2017.csv", header = FALSE))

#Predictor 2 - Time Averaged NDVI
NDVItempAveMatrix1 <- t(as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrix1.csv"), header = FALSE))
NDVItempAveMatrix2 <- t(as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrix2.csv"), header = FALSE))
NDVItempAveMatrixLong <- t(as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv"), header = FALSE))

#Our transformed synchrony variable as the observed variable
transformedMatrix1 <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Transformed1USA.csv"), header = FALSE))
transformedMatrix2 <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Transformed2USA.csv"), header = FALSE))
transformedMatrixLong <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongUSA.csv"), header = FALSE)

#Coordinate Systems
Lat <- as.matrix(read.csv("data/csvFiles/AVHRR_LAT.csv", header = FALSE))
Lon <- as.matrix(read.csv("data/csvFiles/AVHRR_LON.csv", header = FALSE))
 
# Vectorize
vectors <- VectorizeMatrices(Landscan2002Matrix, Landscan2017Matrix, NDVItempAveMatrix1, NDVItempAveMatrix2, NDVItempAveMatrixLong,
                             transformedMatrix1, transformedMatrix2, transformedMatrixLong, Lat, Lon)
Landscan2002Vector <- vectors[[1]]
Landscan2017Vector <- vectors[[2]]
NDVItempAveVector1 <- vectors[[3]]
NDVItempAveVector2 <- vectors[[4]]
NDVItempAveVectorLong <- vectors[[5]]
transformedVector1 <- vectors[[6]]
transformedVector2 <- vectors[[7]]
transformedVectorLong <- vectors[[8]]
latVector <- vectors[[9]]
lonVector <- vectors[[10]]

landModel1 <- lm(transformedVector1 ~ landscan2002Vector)
landModel2 <- lm(transformedVector2 ~ landscan2017Vector)