#' This function will create a 3D array of data values from CSV data
#' in the AVHRR coordinate system.
#' 
#' Assumptions:
#'     1. The data is structured in CSV files, 1 Matrix per CSV file
#'     2. Each Matrix is in the AVHRR coordinate system
#'     3. One year represents one matrix.

CSVInput <- function(pat, numFiles)
{
  dataFiles <- list.files(pattern=pat)
  frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
  matrices <- lapply(frames, function(x) t(data.matrix(x)))

  #Make an array from the list of matrices
  dataArray <- array(NA, dim=c(4587, 2889, numFiles))
  
  for(i in 1:numFiles)
  {
    dataArray[,,i] <- as.matrix(matrices[[i]])
  }
  dataArray
}