#' This function is designed to generate all appropriate data files from R and save them as CSV Files for
#' additional processing by other R functions.
##########################################################
# libraries required
##########################################################
require("tseries")

AVHRRDataGenerator <- function(force = FALSE)
{
  ##########################################################
  # Functions Called
  ##########################################################
  source("scripts/SynchronyMatrixCalculator.R")
  source("scripts/NDVIDetrender.R")
  source("scripts/LogitSynchronyTransform.R")
  source("scripts/CSVInput.R")
  source("scripts/NDVITemporalAverage.R")
  source("scripts/SynchronyPreTransform.R")

  ##########################################################
  # Data input and Initial Processing
  ##########################################################

  #Raw data
  print("Loading in Raw Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_DetrendedNDVIShort_2018.csv") || !file.exists("data/csvFiles/AVHRR_DetrendedNDVILong_2018.csv"))
  {
    NDVIdataArray <- CSVInput("AVHRR_NDVI_WaterRemoved_", 30, 0, 1988, TRUE)
  }
  
  #Landscan
  print("Averaging Landscan Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.csv"))
  {
    landscanArray <- CSVInput("AVHRR_Landscan_Population_WaterRemoved_", 18, 0, 1999, TRUE)
    landscan2003to2004Average <- apply(simplify2array(list(landscanArray[,,4], landscanArray[,,5])), 1:2, mean)
    write.csv(landscan2003to2004Average, "data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.csv", row.names = FALSE)
  }
  
  #NLCD
  print("Averaging NLCD Ag Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.csv"))
  {
    NLCDAg2001 <- t(read.matrix("data/csvFiles/AVHRR_NLCDAgriculture_WaterRemoved_2001.csv", sep = ",", skip = 0))
    NLCDAg2006 <- t(read.matrix("data/csvFiles/AVHRR_NLCDAgriculture_WaterRemoved_2006.csv", sep = ",", skip = 0))
    NLCDAg2001[is.nan(NLCDAg2001)] <- NA
    NLCDAg2006[is.nan(NLCDAg2006)] <- NA
    
    NLCD2001and2006Average <- apply(simplify2array(list(NLCDAg2001, NLCDAg2006)), 1:2, mean)
    write.csv(NLCD2001and2006Average, "data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.csv", row.names = FALSE)
  }
  
  #detrended data
  print("Detrending NDVI data.....")
  print("Detrending NDVI data, Short Periods.....")
  
  NDVIdetrendedDataArray <- array(data = NA, dim = c(4587, 2889, 30))
  if(force || !file.exists("data/csvFiles/AVHRR_DetrendedNDVIShort_2018.csv"))
  {
    NDVIdetrendedDataArray[,,1:15] <- NDVIDetrender(NDVIdataArray, 1:15)
    NDVIdetrendedDataArray[,,16:30] <- NDVIDetrender(NDVIdataArray, 16:30)
    for(i in 1:30)
    {
      write.csv(NDVIdetrendedDataArray[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVIShort_", 1988+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrendedDataArray <- CSVInput("AVHRR_DetrendedNDVIShort_", 30, 1, 1988, FALSE)
  }
  
  print("Detrending NDVI data, Long Periods.....")
  NDVIdetrendedDataArrayLong <- array(data = NA, dim = c(4587, 2889, 30))
  if(force || !file.exists("data/csvFiles/AVHRR_DetrendedNDVILong_2018.csv"))
  {
    NDVIdetrendedDataArrayLong[,,1:30] <- NDVIDetrender(NDVIdataArray, 1:30);
    for(i in 1:30)
    {
      write.csv(NDVIdetrendedDataArray[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVILong_", 1988+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrenddedDataArrayLong <- CSVInput("AVHRR_DetrendedNDVILong_", 30, 1, 1988)
  }
  NDVIdetrendedDataArray1990 <- array(data = NA, dim = c(4587, 2889, 29))
  if(force || !file.exists("data/csvFiles/AVHRR_DetrendedNDVILong_2018.csv"))
  {
    NDVIdetrendedDataArray1990[,,1:29] <- NDVIDetrender(NDVIdataArray, 2:30);
    for(i in 1:29)
    {
      write.csv(NDVIdetrendedDataArray1990[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVI1990to2018_", 1989+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrenddedDataArray1990 <- CSVInput("AVHRR_DetrendedNDVILong1990to2018_", 29, 1, 1988)
  }

  print("Creating Synchrony Matrices for the United States of America.....")
  print("Creating Synchrony Matrices for the United States of America, Years 1989 to 2003.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Synchrony1USA.csv"))
  {
    synchronyMatrix1DetrendedUS <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, 1:15, 5)
    write.csv(synchronyMatrix1DetrendedUS, "data/csvFiles/AVHRR_Synchrony1USA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix1DetrendedUS <- read.matrix("data/csvFiles/AVHRR_Synchrony1USA.csv", sep=",", skip=1)
  }
  print("Creating Synchrony Matrices for the United States of America, Years 2004 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Synchrony2USA.csv"))
  {
    synchronyMatrix2DetrendedUS <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, 16:30, 5)
    write.csv(synchronyMatrix2DetrendedUS, "data/csvFiles/AVHRR_Synchrony2USA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix2DetrendedUS <- read.matrix("data/csvFiles/AVHRR_Synchrony2USA.csv", sep=",", skip=1)
  }
  print("Creating Synchrony Matrices for the United States of America, Years 1989 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_SynchronyLongUSA.csv"))
  {
    synchronyMatrixLongDetrendedUS <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, 1:30, 5)
    write.csv(synchronyMatrixLongDetrendedUS, "data/csvFiles/AVHRR_SynchronyLongUSA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrixLongDetrendedUS <- read.matrix("data/csvFiles/AVHRR_SynchronyLongUSA.csv", sep=",", skip=1)
  }  
  print("Creating Synchrony Matrices for the United States of America, Years 1990 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Synchrony1990to2018USA.csv"))
  {
    synchronyMatrix1990to2018DetrendedUS <- SynchronyMatrixCalculator(NDVIdetrendedDataArray1990, 1:29, 5)
    write.csv(synchronyMatrix1990to2018DetrendedUS, "data/csvFiles/AVHRR_Synchrony1990to2018USA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix1990to2018DetrendedUS <- read.matrix("data/csvFiles/AVHRR_Synchrony1990to2018USA.csv", sep=",", skip=1)
  }  
  
  print("Creating Transformed Matrices for the United States of America....")
  print("Creating Transformed Matrix for the United States of America, Years 1989 to 2003.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Transformed1USA.csv"))
  {
    transformedMatrix1DetrendedUS <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrix1DetrendedUS))
    write.csv(transformedMatrix1DetrendedUS, "data/csvFiles/AVHRR_Transformed1USA.csv", row.names = FALSE)
  }
  print("Creating Transformed Matrix for the United States of America, Years 2004 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Transformed2USA.csv"))
  {
    transformedMatrix2DetrendedUS <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrix2DetrendedUS))
    write.csv(transformedMatrix2DetrendedUS, "data/csvFiles/AVHRR_Transformed2USA.csv", row.names = FALSE)
  }
  print("Creating Transformed Matrix for the United States of America, Years 1989 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_TransformedLongUSA.csv"))
  {
    transformedMatrixLongDetrendedUS <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrixLongDetrendedUS))
    write.csv(transformedMatrixLongDetrendedUS, "data/csvFiles/AVHRR_TransformedLongUSA.csv", row.names = FALSE)
  }
  if(force || !file.exists("data/csvFiles/AVHRR_TransformedLongUSA1990to2018.csv"))
  {
    transformedMatrixLongDetrendedUS1990to2018 <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrix1990to2018DetrendedUS))
    write.csv(transformedMatrixLongDetrendedUS1990to2018, "data/csvFiles/AVHRR_TransformedLongUSA1990to2018.csv")
  }

  ##Temporal Averaging NDVI
  print("Temporally Averaging NDVI.....")
  print("Temporally Averaging NDVI, Years 1989 to 2003.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix1.csv"))
  {
    NDVItempAveMatrix1 <- NDVITemporalAverage(NDVIdataArray[,,1:15])
    write.csv(NDVItempAveMatrix1, "data/csvFiles/AVHRR_NDVItempAveMatrix1.csv", row.names = FALSE)
  }
  print("Temporally Averaging NDVI, Years 2004 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix2.csv"))
  {
    NDVItempAveMatrix2 <- NDVITemporalAverage(NDVIdataArray[,,16:30])
    write.csv(NDVItempAveMatrix2, "data/csvFiles/AVHRR_NDVItempAveMatrix2.csv", row.names = FALSE)
  }
  print("Temporally Averaging NDVI, Years 1989 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NDVItempAeMatrixLong.csv"))
  {
    NDVItempAveMatrixLong <- NDVITemporalAverage(NDVIdataArray[,,1:30])
    write.csv(NDVItempAveMatrixLong, "data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv", row.names = FALSE)
  }
  print("Temporally Averaging NDVI, Years 1990 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NDVItempAeMatrix1990to2018.csv"))
  {
    NDVItempAveMatrix1990 <- NDVITemporalAverage(NDVIdataArray[,,2:30])
    write.csv(NDVItempAveMatrix1990, "data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.csv", row.names = FALSE)
  }
  
  ## Development Index
  print("Development Index.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.csv"))
  {
    NLCDDev2001 <- t(read.matrix("data/csvFiles/AVHRR_NLCDDevelopment_WaterRemoved_2001.csv", sep = ",", skip = 0))
    NLCDDev2006 <- t(read.matrix("data/csvFiles/AVHRR_NLCDDevelopment_WaterRemoved_2006.csv", sep = ",", skip = 0))
    NLCDDev2001[is.nan(NLCDDev2001)] <- NA
    NLCDDev2006[is.nan(NLCDDev2006)] <- NA
    
    NLCD2001and2006AverageDev <- apply(simplify2array(list(NLCDDev2001, NLCDDev2006)), 1:2, mean)
    write.csv(NLCD2001and2006AverageDev, "data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.csv", row.names = FALSE)
  }
  
  ## USGS Elevation Data
  print("Elevation Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.csv") || !file.exists("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.csv") 
     || !file.exists("data/csvFiles/AVHRR_USGS_NumElevationPrepared.csv"))
  {
    numPoints <- t(read.matrix("data/csvFiles/AVHRR_USGSNumPoints_WaterRemoved.csv", sep = ",", skip = 0))
    meanElevation <- t(read.matrix("data/csvFiles/AVHRR_USGSMeanElevation_WaterRemoved.csv", sep = ",", skip = 0))
    sdElevation <- t(read.matrix("data/csvFiles/AVHRR_USGSStandardDeviationElevation_WaterRemoved.csv", sep = ",", skip = 0))
    numPoints[is.nan(numPoints)] <- NA
    meanElevation[is.nan(meanElevation)] <- NA
    sdElevation[is.nan(sdElevation)] <- NA
    
    write.csv(numPoints, "data/csvFiles/AVHRR_USGS_NumElevationPrepared.csv", row.names = FALSE)
    write.csv(meanElevation, "data/csvFiles/AVHRR_USGS_MeanElevationPrepared.csv", row.names = FALSE)
    write.csv(sdElevation, "data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.csv", row.names = FALSE)
  }
  
  ##AVHRR Matrices
  print("AVHRR Coordinate Matrices.....")
  print("AVHRR X Coordinate Matrix.....")
  if(force || !file.exists("data/csvFiles/AVHRR_X_CoordinateMatrix.csv"))
  {
    xMat <- matrix(data = NA, nrow = 2889, ncol = 4587)
    for(i in 1:2889)
    {
      for(j in 1:4587)
      {
        xMat[i,j] <- j
      }
    }
    write.csv(xMat, "data/csvFiles/AVHRR_X_CoordinateMatrix.csv", row.names = FALSE)
  }
  print("AVHRR Y Coordinate Matrix.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Y_CoordinateMatrix.csv"))
  {
    yMat <- matrix(data = NA, nrow = 2889, ncol = 4587)
    for(i in 1:2889)
    {
      for(j in 1:4587)
      {
        yMat[i,j] <- i
      }
    }
    write.csv(yMat, "data/csvFiles/AVHRR_Y_CoordinateMatrix.csv", row.names = FALSE)
  }

  print("Data Processing Complete!")
}
