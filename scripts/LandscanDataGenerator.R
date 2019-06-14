#' This function will create a 3D array of data values from Landscan data
#' 
#'  Arguments:
#'    dataArray: A 3 dimensional matrix of data that wi
LandscanDataGenerator <- function()
{
  dataFiles <- list.files(pattern="AVHRR_Landscan*")
  frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
  matrices <- lapply(frames, function(x) t(data.matrix(x)))
  
  #Make an array from the list of matrices
  dataArray <- array(NA, dim=c(4587, 2889, 18))
  dataArray <- lapply(1:18, function(i) as.matrix(matrices[[i]]))
  dataArray
}