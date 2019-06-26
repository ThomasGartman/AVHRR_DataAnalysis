#' This function will create a 3D array of data values from CSV data
#' in the AVHRR coordinate system.
#' 
#' Assumptions:
#'     1. The data is structured in CSV files, 1 Matrix per CSV file
#'     2. Each Matrix is in the AVHRR coordinate system
#'     3. One year represents one matrix.

CSVInput <- function(pat, numFiles, skipNum, transpose=FALSE)
{
  require("tseries")
  
  dataArray <- array(NA, dim=c(4587, 2889, numFiles))
  
  for(i in 1:numFiles)
  {
    dataFile <- paste("data/csvFiles/", pat, sep="")
    if(transpose)
    {
      dataArray[,,i] <- t(read.matrix(file=dataFile, sep=",", skip=skipNum))
    }
    else
    {
      dataArray[,,i] <- read.matrix(file=dataFile, sep=",", skip=skipNum)
    }
  }
  dataArray[is.nan(dataArray)] <- NA
  dataArray
}
