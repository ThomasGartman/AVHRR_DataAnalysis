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
  #***DAN: put requires in the file but not the function, so they run only when the function
  #is sourced, not every time it is called
  #***DAN: use saveRDS or save (probably saveRDS is better) to save the whole 3d array once constructed
  #then you never have to load the csvs again
  
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
  #***DAN: insert you saveRDS here, and run this functin itself once, and then you will have
  #and RDS file with the dataArray in it. On the command line use readRDS on that file and 
  #see how long it takes
  dataArray
}
