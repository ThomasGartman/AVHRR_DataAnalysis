#' This function is designed to generate all appropriate data files from R and save them as CSV Files for
#' additional processing by other R functions.
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
source("scripts/NormalizedRanking.R")

AVHRRDataGenerator <- function(force = FALSE){
  #Raw NDVI data
  print("Loading in Raw NDVI Data.....")
  if(force || !file.exists("data/csvFiles/NDVIdataArray.RDS")){
    NDVIdataArray <- CSVInput("AVHRR_NDVI_WaterRemoved_", 30, 0, 1988, TRUE)
    saveRDS(NDVIdataArray,"data/csvFiles/NDVIdataArray.RDS")
  }else{
    NDVIdataArray<-readRDS("data/csvFiles/NDVIdataArray.RDS")
  }
  
  #Landscan
  print("Averaging Landscan Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.RDS")){
    landscanArray <- CSVInput("AVHRR_Landscan_Population_WaterRemoved_", 18, 0, 1999, TRUE)
    landscan2003to2004Average <- apply(simplify2array(list(landscanArray[,,4], landscanArray[,,5])), 1:2, mean)
    write.csv(landscan2003to2004Average, "data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.csv", row.names = FALSE)
    saveRDS(landscan2003to2004Average,"data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.RDS")
  }
  
  #NLCD
  print("Averaging NLCD Ag Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.RDS")){
    NLCDAg2001 <- t(read.matrix("data/csvFiles/AVHRR_NLCDAgriculture_WaterRemoved_2001.csv", sep = ",", skip = 0))
    NLCDAg2006 <- t(read.matrix("data/csvFiles/AVHRR_NLCDAgriculture_WaterRemoved_2006.csv", sep = ",", skip = 0))
    NLCDAg2001[is.nan(NLCDAg2001)] <- NA
    NLCDAg2006[is.nan(NLCDAg2006)] <- NA
    
    NLCD2001and2006Average <- apply(simplify2array(list(NLCDAg2001, NLCDAg2006)), 1:2, mean)
    write.csv(NLCD2001and2006Average, "data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.csv", row.names = FALSE)
    saveRDS(NLCD2001and2006Average, "data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.RDS")
  }
  
  ##############################################################
  # Detrended NDVI Data
  ##############################################################
  print("Detrending NDVI data.....")
  
  if(force || !file.exists("data/csvFiles/NDVIdetrendedDataArray1990to2018.RDS")){
    NDVIdetrendedDataArray1990 <- NDVIDetrender(NDVIdataArray, 2:30)
    for(i in 1:29){
      write.csv(NDVIdetrendedDataArray1990[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVI1990to2018_", 1989+i, ".csv", sep=""), row.names = FALSE)
    }
    saveRDS(NDVIdetrendedDataArray1990,"data/csvFiles/NDVIdetrendedDataArray1990to2018.RDS")
  }else{
    NDVIdetrendedDataArray1990 <- readRDS("data/csvFiles/NDVIdetrendedDataArray1990to2018.RDS") #time saving than next line
    #NDVIdetrendedDataArray1990 <- CSVInput(pat="AVHRR_DetrendedNDVI1990to2018_", numFiles=29, skipNum=1, startYear=1989)
  }
  
  print("Detrending NDVI data for Chicago: without Year = 2010.....")
 
  if(force || !file.exists("data/csvFiles/NDVIdetrendedDataArrayChicago1990to2018_except2010.RDS")){
    NDVIdetrendedDataArrayChicago <- NDVIDetrender(NDVIdataArray, c(2:21, 23:30))
    for(i in 1:28){
      write.csv(NDVIdetrendedDataArrayChicago[,,i], paste("data/csvFiles/AVHRR_DetrendedNDVIChicago_", i, ".csv", sep=""), row.names = FALSE)
    }
    saveRDS(NDVIdetrendedDataArrayChicago,"data/csvFiles/NDVIdetrendedDataArrayChicago1990to2018_except2010.RDS") # actually it is for whole US but we are 
    # focusing on Chicago
  }else{
    NDVIdetrendedDataArrayChicago <- readRDS("data/csvFiles/NDVIdetrendedDataArrayChicago1990to2018_except2010.RDS") #time saving than next line
    #NDVIdetrendedDataArrayChicago <- CSVInput("AVHRR_DetrendedNDVIChicago_", 28, 1, 0)
  }
  
  ###################################################################################
  # Generating Normalized ranked version of detrended data array
  ###################################################################################
  print("Applying normalized ranking on detrended data for the USA (1990 to 2018).....")
  if(force || !file.exists("data/csvFiles/NDVIdetrendedDataArray1990to2018_NormRanked.RDS")){
    NDVIdetrendedDataArray1990_NormRanked <- NormalizedRanking(NDVIdetrendedDataArray1990)
    saveRDS(NDVIdetrendedDataArray1990_NormRanked,"data/csvFiles/NDVIdetrendedDataArray1990to2018_NormRanked.RDS")
  }else{
    NDVIdetrendedDataArray1990_NormRanked <- readRDS("data/csvFiles/NDVIdetrendedDataArray1990to2018_NormRanked.RDS") 
  }
 
  ##############################################################
  # Generating Synchrony Matrices
  ##############################################################
  print("Creating Synchrony Matrices for the United States of America.....")
  
  print("Creating Synchrony Matrix for the United States of America, Pearson.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Synchrony1990to2018USA.RDS")){
    synchronyMatrix1990to2018DetrendedUS <- SynchronyMatrixCalculator(dataArray=NDVIdetrendedDataArray1990, 
                                                                      dataArrayRanked = NA, 
                                                                      years=1:29, radius=5, coorTest = "pearson")
    write.csv(synchronyMatrix1990to2018DetrendedUS, "data/csvFiles/AVHRR_Synchrony1990to2018USA.csv", row.names = FALSE)
    saveRDS(synchronyMatrix1990to2018DetrendedUS,"data/csvFiles/AVHRR_Synchrony1990to2018USA.RDS")
  }else{
    synchronyMatrix1990to2018DetrendedUS <- readRDS("data/csvFiles/AVHRR_Synchrony1990to2018USA.RDS")
  } 
  
  print("Creating Synchrony Matrix for the United States of America, Spearman .....")
  if(force || !file.exists("data/csvFiles/AVHRR_SynchronySpearman1990to2018USA.RDS")){
    synchronyMatrix1990to2018DetrendedUS_Spearman <- SynchronyMatrixCalculator(dataArray=NDVIdetrendedDataArray1990, 
                                                                               dataArrayRanked = NA, 
                                                                               years=1:29, radius=5, coorTest = "spearman")
     write.csv(synchronyMatrix1990to2018DetrendedUS_Spearman, "data/csvFiles/AVHRR_SynchronySpearman1990to2018USA.csv", row.names = FALSE)
    saveRDS(synchronyMatrix1990to2018DetrendedUS_Spearman,"data/csvFiles/AVHRR_SynchronySpearman1990to2018USA.RDS")
  }else{
    synchronyMatrix1990to2018DetrendedUS_Spearman <- readRDS("data/csvFiles/AVHRR_SynchronySpearman1990to2018USA.RDS")
  }
  
  print("Creating Synchrony Matrix for the United States of America, Pearson, No 2010.....")
  if(force || !file.exists("data/csvFiles/AVHRR_SynchronyNo2010USA.RDS")){
    synchronyMatrixNo2010DetrendedUS <- SynchronyMatrixCalculator(dataArray=NDVIdetrendedDataArrayChicago, 
                                                                  dataArrayRanked = NA, 
                                                                  years=1:28, radius=5, coorTest = "pearson")
    write.csv(synchronyMatrixNo2010DetrendedUS, "data/csvFiles/AVHRR_SynchronyNo2010USA.csv", row.names = FALSE)
    saveRDS(synchronyMatrixNo2010DetrendedUS,"data/csvFiles/AVHRR_SynchronyNo2010USA.RDS")
  }else{
    synchronyMatrixNo2010DetrendedUS<-readRDS("data/csvFiles/AVHRR_SynchronyNo2010USA.RDS")
  }  
  
  print("Creating Synchrony Matrix for the United States of America, Spearman, No 2010.....")
  if(force || !file.exists("data/csvFiles/AVHRR_SynchronySpearmanNo2010USA.RDS")){
    synchronyMatrixNo2010DetrendedUS_Spearman <- SynchronyMatrixCalculator(dataArray=NDVIdetrendedDataArrayChicago, 
                                                                           dataArrayRanked = NA, 
                                                                           years=1:28, radius=5, coorTest = "spearman")
    write.csv(synchronyMatrixNo2010DetrendedUS_Spearman, "data/csvFiles/AVHRR_SynchronySpearmanNo2010USA.csv", row.names = FALSE)
    saveRDS(synchronyMatrixNo2010DetrendedUS_Spearman,"data/csvFiles/AVHRR_SynchronySpearmanNo2010USA.RDS")
  }else{
    synchronyMatrixNo2010DetrendedUS_Spearman <- readRDS("data/csvFiles/AVHRR_SynchronySpearmanNo2010USA.RDS")
  } 
  
  print("Creating Copula Synchrony Matrices for the United States of America .....")
  if(force || !file.exists("data/csvFiles/AVHRR_Lower_and_UpperTailDependence1990to2018USA.RDS")){
    tailedSynchronyMatrices <- SynchronyMatrixCalculator(dataArray=NDVIdetrendedDataArray1990, 
                                                         dataArrayRanked = NDVIdetrendedDataArray1990_NormRanked, 
                                                         years=1:29, radius=5, coorTest ="copula")
    lowerTailedSynchronyMatrix <- tailedSynchronyMatrices[[1]]
    upperTailedSynchronyMatrix <- tailedSynchronyMatrices[[2]]
    
    saveRDS(tailedSynchronyMatrices,"data/csvFiles/AVHRR_Lower_and_UpperTailDependence1990to2018USA.RDS")
    
    write.csv(lowerTailedSynchronyMatrix, "data/csvFiles/AVHRR_LowerTailDependence1990to2018USA.csv", row.names = FALSE)
    write.csv(upperTailedSynchronyMatrix, "data/csvFiles/AVHRR_UpperTailDependence1990to2018USA.csv", row.names = FALSE)
  }else{
    tailedSynchronyMatrices <- readRDS("data/csvFiles/AVHRR_Lower_and_UpperTailDependence1990to2018USA.RDS") #it's a list of 2 matrices
    lowerTailedSynchronyMatrix <- tailedSynchronyMatrices[[1]]
    upperTailedSynchronyMatrix <- tailedSynchronyMatrices[[2]]
  }
  
  ##############################################################
  # Generating Transformation Matrices
  ##############################################################
  print("Creating Transformed Matrices for the United States of America....")
  print("Creating Pearson Transformed Matrix for the United States of America....")
  if(force || !file.exists("data/csvFiles/AVHRR_TransformedLongUSA1990to2018.RDS")){
    transformedMatrixLongDetrendedUS1990to2018 <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrix1990to2018DetrendedUS))
    saveRDS(transformedMatrixLongDetrendedUS1990to2018,"data/csvFiles/AVHRR_TransformedLongUSA1990to2018.RDS")
    write.csv(transformedMatrixLongDetrendedUS1990to2018, "data/csvFiles/AVHRR_TransformedLongUSA1990to2018.csv", row.names = FALSE)
  }
  print("Creating Spearman Transformed Matrix for the United States of America....")
  if(force || !file.exists("data/csvFiles/AVHRR_TransformedLongUSA1990to2018Spearman.RDS")){
    transformedMatrixLongDetrendedUS1990to2018_Spearman <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrix1990to2018DetrendedUS_Spearman))
    saveRDS(transformedMatrixLongDetrendedUS1990to2018_Spearman,"data/csvFiles/AVHRR_TransformedLongUSA1990to2018Spearman.RDS")
    write.csv(transformedMatrixLongDetrendedUS1990to2018_Spearman, "data/csvFiles/AVHRR_TransformedLongUSA1990to2018Spearman.csv", row.names = FALSE)
  }
  print("Creating Pearson Transformed Matrix No 2010 for the United States of America....")
  if(force || !file.exists("data/csvFiles/AVHRR_TransformedLongUSANo2010.RDS")){
    transformedMatrixLongDetrendedUSNo2010 <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrixNo2010DetrendedUS))
    saveRDS(transformedMatrixLongDetrendedUSNo2010,"data/csvFiles/AVHRR_TransformedLongUSANo2010.RDS")
    write.csv(transformedMatrixLongDetrendedUSNo2010, "data/csvFiles/AVHRR_TransformedLongUSANo2010.csv", row.names = FALSE)
  }
  print("Creating Spearman Transformed Matrix No 2010 for the United States of America....")
  if(force || !file.exists("data/csvFiles/AVHRR_TransformedLongUSANo2010Spearman.RDS")){
    transformedMatrixLongDetrendedUSNo2010_Spearman <- LogitSynchronyTransform(SynchronyPreTransform(synchronyMatrixNo2010DetrendedUS_Spearman))
    saveRDS(transformedMatrixLongDetrendedUSNo2010_Spearman, "data/csvFiles/AVHRR_TransformedLongUSANo2010Spearman.RDS")
    write.csv(transformedMatrixLongDetrendedUSNo2010_Spearman, "data/csvFiles/AVHRR_TransformedLongUSANo2010Spearman.csv", row.names = FALSE)
  }
  
  ##############################################################
  # Driver Data Prep
  ##############################################################
  print("Temporally Averaging NDVI, Years 1990 to 2018.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.RDS")){
    NDVItempAveMatrix1990 <- NDVITemporalAverage(NDVIdataArray[,,2:30])
    saveRDS(NDVItempAveMatrix1990,"data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.RDS")
    write.csv(NDVItempAveMatrix1990, "data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.csv", row.names = FALSE)
  }
  
  print("Temporally Averaging NDVI, Years 1990 to 2018, Without 2010.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018No2010.RDS")){
    NDVItempAveMatrixNo2010 <- NDVITemporalAverage(NDVIdataArray[,,c(2:21, 23:30)])
    saveRDS(NDVItempAveMatrixNo2010,"data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018No2010.RDS")
    write.csv(NDVItempAveMatrixNo2010, "data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018No2010.csv", row.names = FALSE)
  }
  
  print("Development Index.....")
  if(force || !file.exists("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.RDS")){
    NLCDDev2001 <- t(read.matrix("data/csvFiles/AVHRR_NLCDDevelopment_WaterRemoved_2001.csv", sep = ",", skip = 0))
    NLCDDev2006 <- t(read.matrix("data/csvFiles/AVHRR_NLCDDevelopment_WaterRemoved_2006.csv", sep = ",", skip = 0))
    NLCDDev2001[is.nan(NLCDDev2001)] <- NA
    NLCDDev2006[is.nan(NLCDDev2006)] <- NA
    
    NLCD2001and2006AverageDev <- apply(simplify2array(list(NLCDDev2001, NLCDDev2006)), 1:2, mean)
    write.csv(NLCD2001and2006AverageDev, "data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.csv", row.names = FALSE)
    saveRDS(NLCD2001and2006AverageDev,"data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.RDS")
  }
  
  print("Elevation Data.....")
  if(force || !file.exists("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.RDS") || !file.exists("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.RDS")){
    meanElevation <- t(read.matrix("data/csvFiles/AVHRR_USGSMeanElevation_WaterRemoved.csv", sep = ",", skip = 0))
    sdElevation <- t(read.matrix("data/csvFiles/AVHRR_USGSStandardDeviationElevation_WaterRemoved.csv", sep = ",", skip = 0))
    
    meanElevation[is.nan(meanElevation)] <- NA
    sdElevation[is.nan(sdElevation)] <- NA
    
    write.csv(meanElevation, "data/csvFiles/AVHRR_USGS_MeanElevationPrepared.csv", row.names = FALSE)
    write.csv(sdElevation, "data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.csv", row.names = FALSE)
    
    saveRDS(meanElevation, "data/csvFiles/AVHRR_USGS_MeanElevationPrepared.RDS")
    saveRDS(sdElevation, "data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.RDS")
  }
  
  ##AVHRR Matrices
  print("AVHRR Coordinate Matrices.....")
  print("AVHRR X Coordinate Matrix.....")
  if(force || !file.exists("data/csvFiles/AVHRR_X_CoordinateMatrix.RDS")){
    xMat <- matrix(data = NA, nrow = 2889, ncol = 4587)
    for(i in 1:2889){
      for(j in 1:4587){
        xMat[i,j] <- j
      }
    }
    write.csv(xMat, "data/csvFiles/AVHRR_X_CoordinateMatrix.csv", row.names = FALSE)
    saveRDS(xMat, "data/csvFiles/AVHRR_X_CoordinateMatrix.RDS")
  }
  print("AVHRR Y Coordinate Matrix.....")
  if(force || !file.exists("data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS")){
    yMat <- matrix(data = NA, nrow = 2889, ncol = 4587)
    for(i in 1:2889){
      for(j in 1:4587){
        yMat[i,j] <- i
      }
    }
    write.csv(yMat, "data/csvFiles/AVHRR_Y_CoordinateMatrix.csv", row.names = FALSE)
    saveRDS(yMat, "data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS")
  }
  
  print("Data Processing Complete!")
}