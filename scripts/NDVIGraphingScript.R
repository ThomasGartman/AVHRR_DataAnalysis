
source("scripts/NDVIFigureGenerator.R")
source("scripts/SynchronyMapCreator.R")
source("scripts/NDVITimeSeriesGrapher.R")
##########################################################
# Graphing Detrended NDVI VS Lat/Lon and creating a gif 
##########################################################
setwd("../../images")
GIFCreator(NDVIdetrendedDataArray, latVector, lonVector)

##########################################################
# Graphing Raw Time Series in the Mississippi Delta
##########################################################
NDVITimeSeriesGrapher(dataArray, 'RawNDVITimeSeries_(2950,2375)_R=5.png', 'Raw NDVI Time Series at point (2950, 2375) with radius = 5',2950,2375,5)
NDVITimeSeriesGrapher(NDVIdetrendedDataArray, 'DetrendedNDVITimeSeries_(2950,2375)_R=5.png','Detrended NDVI Time Series at point (2950, 2375) with radius = 5' ,2950,2375,5)

##########################################################
# Graphing Synchrony Maps for the Mississippi Delta
##########################################################
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(1,15), 5)
SynchronyMapCreator(synchronyMatrix1Detrended, c(2800,3200), c(2300,2500), c(1,15), 5, "NDVIDetrendedSynchronyMap_MississippiDelta_1989to2003_r5_Pearson.png", "NDVI Detrended Synchrony Map Mississippi Delta, 1989 to 2003, radius = 5, Pearson correlation")

synchronyMatrix2Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(16,30), 5)
SynchronyMapCreator(synchronyMatrix2Detrended, c(2800,3200), c(2300,2500), c(16,30), 5, "NDVIDetrendedSynchronyMap_MississippiDelta_2004to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map Mississippi Delta, 2004 to 2018, radius = 5, Pearson correlation")

synchronyMatrixLongDetrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(2800,3200), c(2300,2500), c(1,30), 5)
SynchronyMapCreator(synchronyMatrixLongDetrended, c(2800,3200), c(2300,2500), c(1,30), 5, "NDVIDetrendedSynchronyMap_MississippiDelta_1998to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map Mississippi Delta, 1998 to 2018, radius = 5, Pearson correlation")

##########################################################
# Graphing Synchrony Maps for Southern Florida
##########################################################
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(1,15), 5)
SynchronyMapCreator(synchronyMatrix1Detrended, c(3800,4100), c(2600,2800), c(1,14), 5, "NDVIDetrendedSynchronyMap_SouthFlorida_1989to2003_r5_Pearson.png", "NDVI Detrended Synchrony Map South Florida, 1989 to 2002, radius = 5, Pearson correlation")

synchronyMatrix2Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(16,30), 5)
SynchronyMapCreator(synchronyMatrix2Detrended, c(3800,4100), c(2600,2800), c(15,27), 5, "NDVIDetrendedSynchronyMap_SouthFlorida_2004to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map South Florida, 2003 to 2015, radius = 5, Pearson correlation")

synchronyMatrixLongDetrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(3800,4100), c(2600,2800), c(1,30), 5)
SynchronyMapCreator(synchronyMatrixLongDetrended, c(3800,4100), c(2600,2800), c(1,30), 5, "NDVIDetrendedSynchronyMap_SouthFlorida_1998to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map South Florida, 1998 to 2018, radius = 5, Pearson correlation")

##########################################################
# Graphing Synchrony Maps for the Central Valley
##########################################################
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50, 450), c(1000,1700), c(1,15), 5)
SynchronyMapCreator(synchronyMatrix1Detrended, c(50,450), c(1000,1700), c(1,15), 5, "NDVIDetrendedSynchronyMap_CentralValley_1989to2003_r5_Pearson.png", "NDVI Detrended Synchrony Map Central Valley, 1989 to 2003, radius = 5, Pearson correlation")

synchronyMatrix2Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50,450), c(1000,1700), c(16,30), 5)
SynchronyMapCreator(synchronyMatrix2Detrended, c(50,450), c(1000,1700), c(16,30), 5, "NDVIDetrendedSynchronyMap_CentralValley_2004to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map Central Valley, 2004 to 2018, radius = 5, Pearson correlation")

synchronyMatrixLongDetrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(50,450), c(1000,1700), c(1,30), 5)
SynchronyMapCreator(synchronyMatrixLongDetrended, c(50,450), c(1000,1700), c(1,30), 5, "NDVIDetrendedSynchronyMap_CentralValley_1998to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map Central Valley, 1998 to 2018, radius = 5, Pearson correlation")

###########################################################
# Graphing Synchrony Maps for the Continental United States
###########################################################
synchronyMatrix1Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(1,4587), c(1,2889), c(1,15), 5)
SynchronyMapCreator(synchronyMatrix1Detrended, c(1,4587), c(1,2889), c(1,14), 5, "NDVIDetrendedSynchronyMap_UnitedStates_1989to2003_r5_Pearson.png", "NDVI Detrended Synchrony Map Continental United States, 1989 to 2003, radius = 5, Pearson correlation")

synchronyMatrix2Detrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(1,4587), c(1,2889), c(16,30), 5)
SynchronyMapCreator(synchronyMatrix2Detrended, c(1,4587), c(1,2889), c(15,27), 5, "NDVIDetrendedSynchronyMap_UnitedStates_2004to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map Continental United States, 2004 to 2018, radius = 5, Pearson correlation")

synchronyMatrixLongDetrended <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(1,4587), c(1,2889), c(1,30), 5)
SynchronyMapCreator(synchronyMatrixLongDetrended,  c(1,4587), c(1,2889), c(1,30), 5, "NDVIDetrendedSynchronyMap_UnitedStates_1998to2018_r5_Pearson.png", "NDVI Detrended Synchrony Map Continental United States, 1998 to 2018, radius = 5, Pearson correlation")
