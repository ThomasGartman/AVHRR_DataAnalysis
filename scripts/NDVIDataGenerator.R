#' This function will create a 3D array of data values from NDVI data
#' 
ArrayDataGenerator <- function()
{
  dataFiles <- list.files(pattern="AVHRR_NDVI_WaterRemoved_*")
  frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
  matrices <- lapply(frames, function(x) t(data.matrix(x)))

  #Make an array from the list of matrices
  dataArray <- array(NA, dim=c(4587, 2889, 30))
  
  for(i in 1:30)
  {
    dataArray[,,i] <- as.matrix(matrices[[i]])
  }
  dataArray
}