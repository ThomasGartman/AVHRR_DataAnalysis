#' This function is designed to generate all appropriate data files from R and save them as CSV Files for
#' additional processing by other R functions.

AVHRRDataGenerator <- function(force = FALSE)
{
  ##########################################################
  # libraries required
  ##########################################################
  require("tseries")
  
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
  NDVIdataArray <- CSVInput("AVHRR_NDVI_WaterRemoved_", 30, 0, TRUE)
    
  #detrended data
  print("Detrending NDVI data.....")
  print("Detrending NDVI data, Short Periods.....")
  
  NDVIdetrendedDataArray <- array(data = NA, dim = c(4587, 2889, 30))
  if(force || !file.exists("data/csvFiles/AVHRR_DetrendedNDVIShort_2018.csv"))
  {
    NDVIdetrendedDataArray[,,1:15] <- NDVIDetrender(NDVIdataArray, 1:30)
    NDVIdetrendedDataArray[,,16:30] <- NDVIDetrender(NDVIdataArray, 16:30)
    for(i in 1:30)
    {
      write.csv(NDVIdetrendedDataArray[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVIShort_", 1988+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrendedDataArray <- CSVInput("AVHRR_DetrendedNDVIShort_", 30, 1, FALSE)
  }
  
  print("Detrending NDVI data, Long Periods.....")
  NDVIdetrendedDataArrayLong <- array(data = NA, dim = c(4587, 2889, 30))
  if(force || !file.exists("data/csvFiles/AVHRR_DetrendedNDVILong_2018.csv"))
  {
    NDVIdetrendedDataArrayLong[,,1:30] <- NDVIDetrender(NDVIdataArray, 30);
    for(i in 1:30)
    {
      write.csv(NDVIdetrendedDataArray[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVILong_", 1988+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrenddedDataArrayLong <- CSVInput("AVHRR_DetrendedNDVILong_", 30, 1)
  }

  
  ##synchrony matrices
  # #NOLA
  # print("Creating Synchrony Matrices for NOLA.....")
  # if(!file.exists("data/csvFiles/AVHRR_Synchrony1NOLA.csv"))
  # {
  #   synchronyMatrix1DetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(1,15), 5)
  #   write.csv(synchronyMatrix1DetrendedNOLA, "data/csvFiles/AVHRR_Synchrony1NOLA.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrix1DetrendedNOLA <- read.matrix("data/csvFiles/AVHRR_Synchrony1NOLA.csv", sep=",", skip=1)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_Synchrony2NOLA.csv"))
  # {
  #   synchronyMatrix2DetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(16,30), 5)
  #   write.csv(synchronyMatrix2DetrendedNOLA, "data/csvFiles/AVHRR_Synchrony2NOLA.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrix2DetrendedNOLA <- read.matrix("data/csvFiles/AVHRR_Synchrony2NOLA.csv", sep=",", skip=1)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_SynchronyLongNOLA.csv"))
  # {
  #   synchronyMatrixLongDetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(2800,3200), c(2300,2500), c(1,30), 5)
  #   write.csv(synchronyMatrixLongDetrendedNOLA, "data/csvFiles/AVHRR_SynchronyLongNOLA.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrixLongDetrendedNOLA <- read.matrix("data/csvFiles/AVHRR_SynchronyLongNOLA.csv", sep=",", skip=1)
  # }
  # 
  # #Everglades
  # print("Creating Synchrony Matrices for Everglades.....")
  # if(!file.exists("data/csvFiles/AVHRR_Synchrony1Everglades.csv"))
  # {
  #   synchronyMatrix1DetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(1,15), 5)
  #   write.csv(synchronyMatrix1DetrendedEverglades, "data/csvFiles/AVHRR_Synchrony1Everglades.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrix1DetrendedEverglades <- read.matrix("data/csvFiles/AVHRR_Synchrony1Everglades.csv", sep=",", skip=1)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_Synchrony2Everglades.csv"))
  # {
  #   synchronyMatrix2DetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(16,30), 5)
  #   write.csv(synchronyMatrix2DetrendedEverglades, "data/csvFiles/AVHRR_Synchrony2Everglades.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrix2DetrendedEverglades <- read.matrix("data/csvFiles/AVHRR_Synchrony2Everglades.csv", sep=",", skip=1)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_SynchronyLongEverglades.csv"))
  # {
  #   synchronyMatrixLongDetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(3800,4100), c(2600,2800), c(1,30), 5)
  #   write.csv(synchronyMatrixLongDetrendedEverglades, "data/csvFiles/AVHRR_SynchronyLongEverglades.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrixLongDetrendedEverglades <- read.matrix("data/csvFiles/AVHRR_SynchronyLongEverglades.csv", sep=",", skip=1)
  # }
  # 
  # #Central Valley
  # print("Creating Synchrony Matrices for the Central Valley.....")
  # if(!file.exists("data/csvFiles/AVHRR_Synchrony1CV.csv"))
  # {
  #   synchronyMatrix1DetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50, 450), c(1000,1700), c(1,15), 5, "AVHRR_Synchrony1CV.csv")
  #   write.csv(synchronyMatrix1DetrendedCV, "data/csvFiles/AVHRR_Synchrony1CV.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrix1DetrendedCV <- read.matrix("data/csvFiles/AVHRR_Synchrony1CV.csv", sep=",", skip=1)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_Synchrony2CV.csv"))
  # {
  #   synchronyMatrix2DetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50,450), c(1000,1700), c(16,30), 5, "AVHRR_Synchrony2CV.csv")
  #   write.csv(synchronyMatrix2DetrendedCV, "data/csvFiles/AVHRR_Synchrony2CV.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrix2DetrendedCV <- read.matrix("data/csvFiles/AVHRR_Synchrony2CV.csv", sep=",", skip=1)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_SynchronyLongCV.csv"))
  # {
  #   synchronyMatrixLongDetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(50,450), c(1000,1700), c(1,30), 5, "AVHRR_SynchronyLongCV.csv")
  #   write.csv(synchronyMatrixLongDetrendedCV, "data/csvFiles/AVHRR_SynchronyLongCV.csv", row.names = FALSE)
  # }
  # else
  # {
  #   synchronyMatrixLongDetrendedCV <- read.matrix("data/csvFiles/AVHRR_SynchronyLongCV.csv", sep=",", skip=1)
  # }
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
    synchronyMatrixLongDetrendedUS <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, 1:30, 5)
    write.csv(synchronyMatrixLongDetrendedUS, "data/csvFiles/AVHRR_SynchronyLongUSA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrixLongDetrendedUS <- read.matrix("data/csvFiles/AVHRR_SynchronyLongUSA.csv", sep=",", skip=1)
  }  
  ##Transformed Matrices
  #NOLA
  # print("Creating Transformed Matrices for NOLA.....")
  # if(!file.exists("data/csvFiles/AVHRR_Transformed1NOLA.csv"))
  # {
  #   transformedMatrix1NOLA <- logitTransform(synchronyMatrix1DetrendedNOLA, 400, 200)
  #   write.csv(transformedMatrix1NOLA, "data/csvFiles/AVHRR_Transformed1NOLA.csv", row.names = FALSE)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_Transformed2NOLA.csv"))
  # {
  #   transformedMatrix2NOLA <- logitTransform(synchronyMatrix2DetrendedNOLA, 400, 200)
  #   write.csv(transformedMatrix2NOLA, "data/csvFiles/AVHRR_Transformed1NOLA.csv", row.names = FALSE)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_TransformedLongNOLA.csv"))
  # {
  #   transformedMatrixLongNOLA <- logitTransform(synchronyMatrixLongDetrendedNOLA, 400, 200)
  #   write.csv(transformedMatrixLongNOLA, "data/csvFiles/AVHRR_TransformedLongNOLA.csv", row.names = FALSE)
  # }
  # 
  # #Everglades
  # print("Creating Transformed Matrices for Everglades.....")
  # if(!file.exists("data/csvFiles/AVHRR_Transformed1Everglades.csv"))
  # {
  #   transformedMatrix1Everglades <- logitTransform(synchronyMatrix1DetrendedEverglades, 300, 200)
  #   write.csv(transformedMatrix1Everglades, "data/csvFiles/AVHRR_Transformed1Everglades.csv", row.names = FALSE)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_Transformed2Everglades.csv"))
  # {
  #   transformedMatrix2Everglades <- logitTransform(synchronyMatrix2DetrendedEverglades, 300, 200)
  #   write.csv(transformedMatrix2Everglades, "data/csvFiles/AVHRR_Transformed2Everglades.csv", row.names = FALSE)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_TransformedLongEverglades.csv"))
  # {
  #   transformedMatrixLongEverglades <- logitTransform(synchronyMatrixLongDetrendedEverglades, 300, 200)
  #   write.csv(transformedMatrixLongEverglades, "data/csvFiles/AVHRR_TransformedLongEverglades.csv", row.names = FALSE)
  # }
  # 
  # #Central Valley
  # print("Creating Transformed Matrices for the Central Valley.....")
  # if(!file.exists("data/csvFiles/AVHRR_Transformed1CV.csv"))
  # {
  #   transformedMatrix1CV <- logitTransform(synchronyMatrix1DetrendedCV, 400, 700)
  #   write.csv(transformedMatrix1CV, "data/csvFiles/AVHRR_Transformed1CV.csv", row.names = FALSE)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_Transformed2CV.csv"))
  # {
  #   transformedMatrix2CV <- logitTransform(synchronyMatrix2DetrendedCV, 400, 700)
  #   write.csv(transformedMatrix2CV, "data/csvFiles/AVHRR_Transformed2CV.csv", row.names = FALSE)
  # }
  # if(!file.exists("data/csvFiles/AVHRR_TransformedLongCV.csv"))
  # {
  #   transformedMatrixLongCV <- logitTransform(synchronyMatrixLongDetrendedCV, 400, 700)
  #   write.csv(transformedMatrixLongCV, "data/csvFiles/AVHRR_TransformedLongCV.csv", row.names = FALSE)
  # }
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
  print("Data Processing Complete!")
}
