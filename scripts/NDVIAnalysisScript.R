##########################################################
# Functions Called
##########################################################
source("scripts/SynchronyMatrixCalculator.R")
source("scripts/CSVInput.R")
source("scripts/NDVIDetrender.R")
source("sripts/NDVITemporalAverage.R")

##########################################################
# Data input and Initial Processing
##########################################################
setwd("data/csvFiles/")

#Raw data
NDVIdataArray <- CSVInput("AVHRR_NDVI_WaterRemoved_*", 30)
LandscanPop2002 <- read.csv("AVHRR_Landscan_Population_WaterRemoved_2002.csv")
LandscanPop2017 <- read.csv("AVHRR_Landscan_Population_WaterRemoved_2017.csv")
latMatrix <- as.matrix(read.csv("AVHRR_LAT.csv"))
lonMatrix <- as.matrix(read.csv("AVHRR_LON.csv"))

#detrended data
if(file.exists("AVHRR_DetrendedNDVIShort_2018.csv")){
  NDVIdetrendedDataArray <- CSVInput("AVHRR_DetrendedNDVIShort*", 30, TRUE)
}else{
  NDVIdetrendedDataArray <- NDVIDetrender(NDVIdataArray, 4587, 2889, 30, 15);
}

if(file.exists("AVHRR_DetrendedNDVILong_2018.csv")){
  NDVIdetrendedDataArrayLong <- CSVInput("AVHRR_DetrendedNDVILong*", 30, TRUE)
}else{
  NDVIdetrendedDataArrayLong <- NDVIDetrender(NDVIdataArray, 4587, 2889, 30, 30);
}

##synchrony matrices
#NOLA
if(file.exists("AVHRR_Synchrony1NOLA.csv"))
{
  synchronyMatrix1DetrendedNOLA <- as.matrix(read.csv("AVHRR_Synchrony1NOLA.csv"))
} else {
  synchronyMatrix1DetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(1,15), 5, "AVHRR_Synchrony1NOLA.csv")
}
if(file.exists("AVHRR_Synchrony2NOLA.csv"))
{
  synchronyMatrix2DetrendedNOLA <- as.matrix(read.csv("AVHRR_Synchrony2NOLA.csv"))
} else {
  synchronyMatrix2DetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(16,30), 5, "AVHRR_Synchrony2NOLA.csv")
}
if(file.exists("AVHRR_SynchronyLongNOLA.csv"))
{
  synchronyMatrixLongDetrendedNOLA <- as.matrix(read.csv("AVHRR_SynchronyLongNOLA.csv"))
} else {
  synchronyMatrixLongDetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(2800,3200), c(2300,2500), c(1,30), 5, "AVHRR_SynchronyLongNOLA.csv")
}

#Everglades
if(file.exists("AVHRR_Synchrony1Everglades.csv"))
{
  synchronyMatrix1DetrendedEverglades <- as.matrix(read.csv("AVHRR_Synchrony1Everglades.csv"))
} else {
  synchronyMatrix1DetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(1,15), 5, "AVHRR_Synchrony1Everglades.csv")
}
if(file.exists("AVHRR_Synchrony2Everglades.csv"))
{
  synchronyMatrix2DetrendedEverglades <- as.matrix(read.csv("AVHRR_Synchrony2Everglades.csv"))
} else {
  synchronyMatrix2DetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(16,30), 5, "AVHRR_Synchrony2Everglades.csv")
}
if(file.exists("AVHRR_SynchronyLongEverglades.csv"))
{
  synchronyMatrixLongDetrendedEverglades <- as.matrix(read.csv("AVHRR_SynchronyLongEverglades.csv"))
} else {
  synchronyMatrixLongDetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(3800,4100), c(2600,2800), c(1,30), 5, "AVHRR_SynchronyLongEverglades.csv")
}

#Central Valley
if(file.exists("AVHRR_Synchrony1CV.csv"))
{
  synchronyMatrix1DetrendedCV <- as.matrix(read.csv("AVHRR_Synchrony1CV.csv"))
} else {
  synchronyMatrix1DetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50, 450), c(1000,1700), c(1,15), 5, "AVHRR_Synchrony1CV.csv")
}
if(file.exists("AVHRR_Synchrony2CV.csv"))
{
  synchronyMatrix2DetrendedCV <- as.matrix(read.csv("AVHRR_Synchrony2CV.csv"))
} else {
  synchronyMatrix2DetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50,450), c(1000,1700), c(16,30), 5, "AVHRR_Synchrony2CV.csv")
}
if(file.exists("AVHRR_SynchronyLongCV.csv"))
{
  synchronyMatrixLongDetrendedCV <- as.matrix(read.csv("AVHRR_SynchronyLongCV.csv"))
} else {
  synchronyMatrixLongDetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(50,450), c(1000,1700), c(1,30), 5, "AVHRR_SynchronyLongCV.csv")
}

##Transformed Matrices
#NOLA
if(file.exists("AVHRR_Transformed1NOLA.csv"))
{
  transformedMatrix1NOLA <- as.matrix(read.csv("AVHRR_Transformed1NOLA.csv"))
} else {
  transformedMatrix1NOLA <- logitTransform(synchronyMatrix1DetrendedNOLA, 400, 200)
  write.csv(transformedMatrix1NOLA, "AVHRR_Transformed1NOLA.csv", row.names = FALSE)
}
if(file.exists("AVHRR_Transformed2NOLA.csv"))
{
  transformedMatrix2NOLA <- as.matrix(read.csv("AVHRR_Transformed2NOLA.csv"))
} else {
  transformedMatrix2NOLA <- logitTransform(synchronyMatrix2DetrendedNOLA, 400, 200)
  write.csv(transformedMatrix2NOLA, "AVHRR_Transformed1NOLA.csv", row.names = FALSE)
}
if(file.exists("AVHRR_TransformedLongNOLA.csv"))
{
  transformedMatrixLongNOLA <- as.matrix(read.csv("AVHRR_TransformedLongNOLA.csv"))
} else {
  transformedMatrixLongNOLA <- logitTransform(synchronyMatrixLongDetrendedNOLA, 400, 200)
  write.csv(transformedMatrixLongNOLA, "AVHRR_TransformedLongNOLA.csv", row.names = FALSE)
}

#Everglades
if(file.exists("AVHRR_Transformed1Everglades.csv"))
{
  transformedMatrix1Everglades <- as.matrix(read.csv("AVHRR_Transformed1Everglades.csv"))
} else {
  transformedMatrix1Everglades <- logitTransform(synchronyMatrix1DetrendedEverglades, 300, 200)
  write.csv(transformedMatrix1Everglades, "AVHRR_Transformed1Everglades.csv", row.names = FALSE)
}
if(file.exists("AVHRR_Transformed2Everglades.csv"))
{
  transformedMatrix2Everglades <- as.matrix(read.csv("AVHRR_Transformed2Everglades.csv"))
} else {
  transformedMatrix2Everglades <- logitTransform(synchronyMatrix2DetrendedEverglades, 300, 200)
  write.csv(transformedMatrix2Everglades, "AVHRR_Transformed2Everglades.csv", row.names = FALSE)
}
if(file.exists("AVHRR_TransformedLongEverglades.csv"))
{
  transformedMatrixLongEverglades <- as.matrix(read.csv("AVHRR_TransformedLongEverglades.csv"))
} else {
  transformedMatrixLongEverglades <- logitTransform(synchronyMatrixLongDetrendedEverglades, 300, 200)
  write.csv(transformedMatrixLongEverglades, "AVHRR_TransformedLongEverglades.csv", row.names = FALSE)
}

#Central Valley
if(file.exists("AVHRR_Transformed1CV.csv"))
{
  transformedMatrix1CV <- as.matrix(read.csv("AVHRR_Transformed1CV.csv"))
} else {
  transformedMatrix1CV <- logitTransform(synchronyMatrix1DetrendedCV, 400, 700)
  write.csv(transformedMatrix1CV, "AVHRR_Transformed1CV.csv", row.names = FALSE)
}
if(file.exists("AVHRR_Transformed2CV.csv"))
{
  transformedMatrix2CV <- as.matrix(read.csv("AVHRR_Transformed2CV.csv"))
} else {
  transformedMatrix2CV <- logitTransform(synchronyMatrix2DetrendedCV, 400, 700)
  write.csv(transformedMatrix2CV, "AVHRR_Transformed2CV.csv", row.names = FALSE)
}
if(file.exists("AVHRR_TransformedLongCV.csv"))
{
  transformedMatrixLongCV <- as.matrix(read.csv("AVHRR_TransformedLongCV.csv"))
} else {
  transformedMatrixLongCV <- logitTransform(synchronyMatrixLongDetrendedCV, 400, 700)
  write.csv(transformedMatrixLongCV, "AVHRR_TransformedLongCV.csv", row.names = FALSE)
}

##Temporal Averaging NDVI
if(file.exists("AVHRR_NDVIAverage1.csv"))
{
  NDVItempAveMatrix1 <- as.matrix(read.csv("AVHRR_NDVIAverage1.csv"))
} else {
  NDVItempAveMatrix1 <- NDVITemporalAverage(NDVIdataArray, 1, 15)
  write.csv(NDVItempAveMatrix1, "AVHRR_NDVItempAveMatrix1.csv", row.names = FALSE)
}
if(file.exists("AVHRR_NDVIAverage2.csv"))
{
  NDVItempAveMatrix2 <- as.matrix(read.csv("AVHRR_NDVIAverage2.csv"))
} else {
  NDVItempAveMatrix2 <- NDVITemporalAverage(NDVIdataArray, 16, 30)
  write.csv(NDVItempAveMatrix2, "AVHRR_NDVItempAveMatrix2.csv", row.names = FALSE)
}
if(file.exists("AVHRR_NDVIAverageLong.csv"))
{
  NDVItempAveMatrixLong <- as.matrix(read.csv("AVHRR_NDVIAverageLong.csv"))
} else {
  NDVItempAveMatrixLong <- NDVITemporalAverage(NDVIdataArray, 1, 30)
  write.csv(NDVItempAveMatrixLong, "AVHRR_NDVItempAveMatrixLong.csv", row.names = FALSE)
}
##########################################################
# Processing (Vectorization and NA handling)
##########################################################

##########################################################
# Statistical Modeling
##########################################################