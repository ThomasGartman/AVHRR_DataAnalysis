#' This function is designed to generate all appropriate data files from R and save them as CSV Files for
#' additional processing by other R functions.

AVHRRDataGenerator <- function()
{
  ##########################################################
  # Functions Called
  ##########################################################
  source("scripts/SynchronyMatrixCalculator.R")
  source("scripts/NDVIDetrender.R")
  source("scripts/logitTransform.R")
  source("scripts/CSVInput.R")
  source("scripts/NDVITemporalAverage.R")

  ##########################################################
  # Data input and Initial Processing
  ##########################################################

  #Raw data
  print("Loading in Raw Data.....")
  NDVIdataArray <- CSVInput("AVHRR_NDVI_WaterRemoved_*", 30)
    
  #detrended data
  print("Detrending NDVI data.....")
  if(!file.exists("data/csvFiles/AVHRR_DetrendedNDVIShort_2018.csv"))
  {
    NDVIdetrendedDataArray <- NDVIDetrender(NDVIdataArray, 4587, 2889, 30, 15);
    for(i in 1:30)
    {
      write.csv(NDVIdetrendedDataArray[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVIShort_", 1988+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrendedDataArray <- CSVInput("AVHRR_DetrendedNDVIShort*", 30)
  }
  
  if(!file.exists("data/csvFiles/AVHRR_DetrendedNDVILong_2018.csv"))
  {
    NDVIdetrendedDataArrayLong <- NDVIDetrender(NDVIdataArray, 4587, 2889, 30, 30);
    for(i in 1:30)
    {
      write.csv(NDVIdetrendedDataArray[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVILong_", 1988+i, ".csv", sep=""), row.names = FALSE)
    }
  }
  else
  {
    NDVIdetrenddedDataArrayLong <- CSVInput("AVHRR_DetrendedNDVILong*", 30)
  }

  ##synchrony matrices
  #NOLA
  print("Creating Synchrony Matrices for NOLA.....")
  if(!file.exists("data/csvFiles/AVHRR_Synchrony1NOLA.csv"))
  {
    synchronyMatrix1DetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(1,15), 5)
    write.csv(synchronyMatrix1DetrendedNOLA, "data/csvFiles/AVHRR_Synchrony1NOLA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix1DetrendedNOLA <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony1NOLA.csv", headers=TRUE)))
  }
  if(!file.exists("data/csvFiles/AVHRR_Synchrony2NOLA.csv"))
  {
    synchronyMatrix2DetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(2800,3200), c(2300,2500), c(16,30), 5)
    write.csv(synchronyMatrix2DetrendedNOLA, "data/csvFiles/AVHRR_Synchrony2NOLA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix2DetrendedNOLA <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony2NOLA.csv", headers=TRUE)))
  }
  if(!file.exists("data/csvFiles/AVHRR_SynchronyLongNOLA.csv"))
  {
    synchronyMatrixLongDetrendedNOLA <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(2800,3200), c(2300,2500), c(1,30), 5)
    write.csv(synchronyMatrixLongDetrendedNOLA, "data/csvFiles/AVHRR_SynchronyLongNOLA.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrixLongDetrendedNOLA <- t(as.matrix(read.csv("data/csvFiles/AVHRR_SynchronyLongNOLA.csv", headers=TRUE)))
  }
  
  #Everglades
  print("Creating Synchrony Matrices for Everglades.....")
  if(!file.exists("data/csvFiles/AVHRR_Synchrony1Everglades.csv"))
  {
    synchronyMatrix1DetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(1,15), 5)
    write.csv(synchronyMatrix1DetrendedEverglades, "data/csvFiles/AVHRR_Synchrony1Everglades.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix1DetrendedEverglades <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony1Everglades.csv", headers = TRUE)))
  }
  if(!file.exists("data/csvFiles/AVHRR_Synchrony2Everglades.csv"))
  {
    synchronyMatrix2DetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(3800,4100), c(2600,2800), c(16,30), 5)
    write.csv(synchronyMatrix2DetrendedEverglades, "data/csvFiles/AVHRR_Synchrony2Everglades.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix2DetrendedEverglades <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony2Everglades.csv", headers = TRUE)))
  }
  if(!file.exists("data/csvFiles/AVHRR_SynchronyLongEverglades.csv"))
  {
    synchronyMatrixLongDetrendedEverglades <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(3800,4100), c(2600,2800), c(1,30), 5)
    write.csv(synchronyMatrixLongDetrendedEverglades, "data/csvFiles/AVHRR_SynchronyLongEverglades.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrixLongDetrendedEverglades <- t(as.matrix(read.csv("data/csvFiles/AVHRR_SynchronyLongEverglades.csv", headers = TRUE)))
  }
  
  #Central Valley
  print("Creating Synchrony Matrices for the Central Valley.....")
  if(!file.exists("data/csvFiles/AVHRR_Synchrony1CV.csv"))
  {
    synchronyMatrix1DetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50, 450), c(1000,1700), c(1,15), 5, "AVHRR_Synchrony1CV.csv")
    write.csv(synchronyMatrix1DetrendedCV, "data/csvFiles/AVHRR_Synchrony1CV.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix1DetrendedCV <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony1CV.csv", headers=TRUE)))
  }
  if(!file.exists("data/csvFiles/AVHRR_Synchrony2CV.csv"))
  {
    synchronyMatrix2DetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArray, c(50,450), c(1000,1700), c(16,30), 5, "AVHRR_Synchrony2CV.csv")
    write.csv(synchronyMatrix2DetrendedCV, "data/csvFiles/AVHRR_Synchrony2CV.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrix2DetrendedCV <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony2CV.csv", headers=TRUE)))
  }
  if(!file.exists("data/csvFiles/AVHRR_SynchronyLongCV.csv"))
  {
    synchronyMatrixLongDetrendedCV <- SynchronyMatrixCalculator(NDVIdetrendedDataArrayLong, c(50,450), c(1000,1700), c(1,30), 5, "AVHRR_SynchronyLongCV.csv")
    write.csv(synchronyMatrixLongDetrendedCV, "data/csvFiles/AVHRR_SynchronyLongCV.csv", row.names = FALSE)
  }
  else
  {
    synchronyMatrixLongDetrendedCV <- t(as.matrix(read.csv("data/csvFiles/AVHRR_SynchronyLongCV.csv", headers=TRUE)))
  }
  
  ##Transformed Matrices
  #NOLA
  print("Creating Transformed Matrices for NOLA.....")
  if(!file.exists("data/csvFiles/AVHRR_Transformed1NOLA.csv"))
  {
    transformedMatrix1NOLA <- logitTransform(synchronyMatrix1DetrendedNOLA, 400, 200)
    write.csv(transformedMatrix1NOLA, "data/csvFiles/AVHRR_Transformed1NOLA.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_Transformed2NOLA.csv"))
  {
    transformedMatrix2NOLA <- logitTransform(synchronyMatrix2DetrendedNOLA, 400, 200)
    write.csv(transformedMatrix2NOLA, "data/csvFiles/AVHRR_Transformed1NOLA.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_TransformedLongNOLA.csv"))
  {
    transformedMatrixLongNOLA <- logitTransform(synchronyMatrixLongDetrendedNOLA, 400, 200)
    write.csv(transformedMatrixLongNOLA, "data/csvFiles/AVHRR_TransformedLongNOLA.csv", row.names = FALSE)
  }
  
  #Everglades
  print("Creating Transformed Matrices for Everglades.....")
  if(!file.exists("data/csvFiles/AVHRR_Transformed1Everglades.csv"))
  {
    transformedMatrix1Everglades <- logitTransform(synchronyMatrix1DetrendedEverglades, 300, 200)
    write.csv(transformedMatrix1Everglades, "data/csvFiles/AVHRR_Transformed1Everglades.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_Transformed2Everglades.csv"))
  {
    transformedMatrix2Everglades <- logitTransform(synchronyMatrix2DetrendedEverglades, 300, 200)
    write.csv(transformedMatrix2Everglades, "data/csvFiles/AVHRR_Transformed2Everglades.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_TransformedLongEverglades.csv"))
  {
    transformedMatrixLongEverglades <- logitTransform(synchronyMatrixLongDetrendedEverglades, 300, 200)
    write.csv(transformedMatrixLongEverglades, "data/csvFiles/AVHRR_TransformedLongEverglades.csv", row.names = FALSE)
  }
  
  #Central Valley
  print("Creating Transformed Matrices for the Central Valley.....")
  if(!file.exists("data/csvFiles/AVHRR_Transformed1CV.csv"))
  {
    transformedMatrix1CV <- logitTransform(synchronyMatrix1DetrendedCV, 400, 700)
    write.csv(transformedMatrix1CV, "data/csvFiles/AVHRR_Transformed1CV.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_Transformed2CV.csv"))
  {
    transformedMatrix2CV <- logitTransform(synchronyMatrix2DetrendedCV, 400, 700)
    write.csv(transformedMatrix2CV, "data/csvFiles/AVHRR_Transformed2CV.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_TransformedLongCV.csv"))
  {
    transformedMatrixLongCV <- logitTransform(synchronyMatrixLongDetrendedCV, 400, 700)
    write.csv(transformedMatrixLongCV, "data/csvFiles/AVHRR_TransformedLongCV.csv", row.names = FALSE)
  }
  
  ##Temporal Averaging NDVI
  print("Temporally Averaging NDVI now.....")
  if(!file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix1.csv"))
  {
    NDVItempAveMatrix1 <- NDVITemporalAverage(NDVIdataArray, 1, 15)
    write.csv(NDVItempAveMatrix1, "data/csvFiles/AVHRR_NDVItempAveMatrix1.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix2.csv"))
  {
    NDVItempAveMatrix2 <- NDVITemporalAverage(NDVIdataArray, 16, 30)
    write.csv(NDVItempAveMatrix2, "data/csvFiles/AVHRR_NDVItempAveMatrix2.csv", row.names = FALSE)
  }
  if(!file.exists("data/csvFiles/AVHRR_NDVItempAeMatrixLong.csv"))
  {
    NDVItempAveMatrixLong <- NDVITemporalAverage(NDVIdataArray, 1, 30)
    write.csv(NDVItempAveMatrixLong, "data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv", row.names = FALSE)
  }
  print("Data Processing Complete!")
}
