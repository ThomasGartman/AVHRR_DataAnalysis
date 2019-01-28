source("scripts/SynchronyMatrixCalculator.R")
source("scripts/NDVIDataGenerator.R")
source("scripts/NDVIDetrender.R")
source("scripts/SynchronyMapCreator.R")
source("scripts/NDVITimeSeriesGrapher.R")
##########################################################
# Data input and cleanup
##########################################################
setwd("data/csvFiles/")
dataArray <- ArrayDataGenerator("data/csvFiles/")
detrendedDataArray <- NDVIDetrender(dataArray, 4587, 2889, 27, 14);
setwd("../../Images")

##########################################################
# Graphing Raw Time Series in the Mississippi Delta
##########################################################
NDVITimeSeriesGrapher(dataArray, 'RawNDVITimeSeries_(2950,2375)_R=5.png', 'Raw NDVI Time Series at point (2950, 2375) with radius = 5',2950,2375,5)
NDVITimeSeriesGrapher(detrendedDataArray, 'DetrendedNDVITimeSeries_(2950,2375)_R=5.png','Detrended NDVI Time Series at point (2950, 2375) with radius = 5' ,2950,2375,5)

##########################################################
# Graphing Synchrony Maps for the Mississippi Delta
##########################################################
synchronyMatrix1 <- SynchronyMatrixCalculator(dataArray, c(2800,3200), c(2300,2500), c(1,14), 5)
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(2800,3200), c(2300,2500), c(1,14), 5)
SynchronyMapCreator(synchronyMatrix1, c(2800,3200), c(2300,2500), c(1,14), 5, "NDVISynchronyMap_MississippiDelta_1989to2002_r5_Pearson.png", "NDVI Synchrony Map Mississippi Delta, 1989 to 2002, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix1Detrended, c(2800,3200), c(2300,2500), c(1,14), 5, "NDVIDetrendedSynchronyMap_MississippiDelta_1989to2002_r5_Pearson.png", "NDVI Detrended Synchrony Map Mississippi Delta, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2 <- SynchronyMatrixCalculator(dataArray, c(2800,3200), c(2300,2500), c(15,27), 5)
synchronyMatrix2Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(2800,3200), c(2300,2500), c(15,27), 5)
SynchronyMapCreator(synchronyMatrix2, c(2800,3200), c(2300,2500), c(15,27), 5, "NDVISynchronyMap_MississippiDelta_2003to2015_r5_Pearson.png", "NDVI Synchrony Map Mississippi Delta, 2003 to 2015, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix2Detrended, c(2800,3200), c(2300,2500), c(15,27), 5, "NDVIDetrendedSynchronyMap_MississippiDelta_2003to2015_r5_Pearson.png", "NDVI Detrended Synchrony Map Mississippi Delta, 2003 to 2015, radius = 5, Pearson correlation")

##########################################################
# Graphing Synchrony Maps for Southern Florida
##########################################################
synchronyMatrix1 <- SynchronyMatrixCalculator(dataArray, c(3800,4100), c(2600,2800), c(1,14), 5)
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(3800,4100), c(2600,2800), c(1,14), 5)
SynchronyMapCreator(synchronyMatrix1, c(3800,4100), c(2600,2800), c(1,14), 5, "NDVISynchronyMap_SouthFlorida_1989to2002_r5_Pearson.png", "NDVI Synchrony Map South Florida, 1989 to 2002, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix1Detrended, c(3800,4100), c(2600,2800), c(1,14), 5, "NDVIDetrendedSynchronyMap_SouthFlorida_1989to2002_r5_Pearson.png", "NDVI Detrended Synchrony Map South Florida, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2 <- SynchronyMatrixCalculator(dataArray, c(3800,4100), c(2600,2800), c(15,27), 5)
synchronyMatrix2Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(3800,4100), c(2600,2800), c(15,27), 5)
SynchronyMapCreator(synchronyMatrix2, c(3800,4100), c(2600,2800), c(15,27), 5, "NDVISynchronyMap_SouthFlorida_2003to2015_r5_Pearson.png", "NDVI Synchrony Map South Florida, 2003 to 2015, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix2Detrended, c(3800,4100), c(2600,2800), c(15,27), 5, "NDVIDetrendedSynchronyMap_SouthFlorida_2003to2015_r5_Pearson.png", "NDVI Detrended Synchrony Map South Florida, 2003 to 2015, radius = 5, Pearson correlation")

##########################################################
# Graphing Synchrony Maps for the Central Valley
##########################################################
synchronyMatrix1 <- SynchronyMatrixCalculator(dataArray, c(50,450), c(1000,1700), c(1,14), 5)
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(50, 450), c(1000,1700), c(1,14), 5)
SynchronyMapCreator(synchronyMatrix1, c(50,450), c(1000,1700), c(1,14), 5, "NDVISynchronyMap_CentralValley_1989to2002_r5_Pearson.png", "NDVI Synchrony Map Central Valley, 1989 to 2002, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix1Detrended, c(50,450), c(1000,1700), c(1,14), 5, "NDVIDetrendedSynchronyMap_CentralValley_1989to2002_r5_Pearson.png", "NDVI Detrended Synchrony Map Central Valley, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2 <- SynchronyMatrixCalculator(dataArray, c(50,450), c(1000,1700), c(15,27), 5)
synchronyMatrix2Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(50,450), c(1000,1700), c(15,27), 5)
SynchronyMapCreator(synchronyMatrix2, c(50,450), c(1000,1700), c(15,27), 5, "NDVISynchronyMap_CentralValley_2003to2015_r5_Pearson.png", "NDVI Synchrony Map Central Valley, 2003 to 2015, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix2Detrended, c(50,450), c(1000,1700), c(15,27), 5, "NDVIDetrendedSynchronyMap_CentralValley_2003to2015_r5_Pearson.png", "NDVI Detrended Synchrony Map Central Valley, 2003 to 2015, radius = 5, Pearson correlation")

##########################################################
# Graphing Synchrony Maps for Snake River
##########################################################
synchronyMatrix1 <- SynchronyMatrixCalculator(dataArray, c(400,900), c(600,950), c(1,14), 5)
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(400,900), c(600,950), c(1,14), 5)
SynchronyMapCreator(synchronyMatrix1, c(400,900), c(600,950), c(1,14), 5, "NDVISynchronyMap_SnakeRiver_1989to2002_r5_Pearson.png", "NDVI Synchrony Map Snake River, 1989 to 2002, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix1Detrended, c(400,900), c(600,950), c(1,14), 5, "NDVIDetrendedSynchronyMap_SnakeRiver_1989to2002_r5_Pearson.png", "NDVI Detrended Synchrony Map Snake River, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2 <- SynchronyMatrixCalculator(dataArray, c(400,900), c(600,950), c(15,27), 5)
synchronyMatrix2Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(400,900), c(600,950), c(15,27), 5)
SynchronyMapCreator(synchronyMatrix2, c(400,900), c(600,950), c(15,27), 5, "NDVISynchronyMap_SnakeRiver_2003to2015_r5_Pearson.png", "NDVI Synchrony Map Snake River, 2003 to 2015, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix2Detrended, c(400,900), c(600,950), c(15,27), 5, "NDVIDetrendedSynchronyMap_SnakeRiver_2003to2015_r5_Pearson.png", "NDVI Detrended Synchrony Map Snake River, 2003 to 2015, radius = 5, Pearson correlation")

##########################################################
# Graphing Synchrony Maps for the St Louis Area
##########################################################
synchronyMatrix1 <- SynchronyMatrixCalculator(dataArray, c(2800,3000), c(1300,1500), c(1,14), 5)
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(2800,3000), c(1300,1500), c(1,14), 5)
SynchronyMapCreator(synchronyMatrix1, c(2800,3000), c(1300,1500), c(1,14), 5, "NDVISynchronyMap_StLouis_1989to2002_r5_Pearson.png", "NDVI Synchrony Map St. Louis, 1989 to 2002, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix1Detrended, c(2800,3000), c(1300,1500), c(1,14), 5, "NDVIDetrendedSynchronyMap_StLouis_1989to2002_r5_Pearson.png", "NDVI Detrended Synchrony Map St. Louis, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2 <- SynchronyMatrixCalculator(dataArray, c(2800,3000), c(1300,1500), c(15,27), 5)
synchronyMatrix2Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(2800,3000), c(1300,1500), c(15,27), 5)
SynchronyMapCreator(synchronyMatrix2, c(2800,3000), c(1300,1500), c(15,27), 5, "NDVISynchronyMap_StLouis_2003to2015_r5_Pearson.png", "NDVI Synchrony Map St. Louis, 2003 to 2015, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix2Detrended, c(2800,3000), c(1300,1500), c(15,27), 5, "NDVIDetrendedSynchronyMap_StLouis_2003to2015_r5_Pearson.png", "NDVI Detrended Synchrony Map St. Louis, 2003 to 2015, radius = 5, Pearson correlation")

###########################################################
# Graphing Synchrony Maps for the Continental United States
###########################################################
synchronyMatrix1 <- SynchronyMatrixCalculator(dataArray, c(1,4587), c(1,2889), c(1,14), 5)
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(1,4587), c(1,2889), c(1,14), 5)
SynchronyMapCreator(synchronyMatrix1, c(1,4587), c(1,2889), c(1,14), 5, "NDVISynchronyMap_UnitedStates_1989to2002_r5_Pearson.png", "NDVI Synchrony Map Continental United States, 1989 to 2002, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix1Detrended, c(1,4587), c(1,2889), c(1,14), 5, "NDVIDetrendedSynchronyMap_UnitedStates_1989to2002_r5_Pearson.png", "NDVI Detrended Synchrony Map Continental United States, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2 <- SynchronyMatrixCalculator(dataArray, c(1,4587), c(1,2889), c(15,27), 5)
synchronyMatrix2Detrended <- SynchronyMatrixCalculator(detrendedDataArray, c(1,4587), c(1,2889), c(15,27), 5)
SynchronyMapCreator(synchronyMatrix2, c(1,4587), c(1,2889), c(15,27), 5, "NDVISynchronyMap_UnitedStates_2003to2015_r5_Pearson.png", "NDVI Synchrony Map Continental United States, 2003 to 2015, radius = 5, Pearson correlation")
SynchronyMapCreator(synchronyMatrix2Detrended, c(1,4587), c(1,2889), c(15,27), 5, "NDVIDetrendedSynchronyMap_UnitedStates_2003to2015_r5_Pearson.png", "NDVI Detrended Synchrony Map Continental United States, 2003 to 2015, radius = 5, Pearson correlation")