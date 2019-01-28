#' This function will create a 3D array of data values from NDVI data
#' 
#'  Arguments:
#'    dataArray: A 3 dimensional matrix of data that wi
ArrayDataGenerator <- function(pathName)
{
  dataFiles <- list.files(pattern="*.csv")
  frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
  matrices <- lapply(frames, function(x) t(data.matrix(x)))

  #Make an array from the list of matrices
  dataArray <- array(NA, dim=c(4587, 2889, 27))
  
  for(i in 1:27)
  {
    dataArray[,,i] <- as.matrix(matrices[[i]])
  }
  dataArray
}