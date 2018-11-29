#' Detrend NDVI data
#' 
#' Model NDVI data as a function that takes in x and y coordinates and returns an NDVI value. Create a linear model then
#' compute the residuals of that data.
#' 
#' @param dataArray The array of data to be detrended.
#' @param numCol    The number of columns in the dataArray
#' @param numRow    The number of rows in the dataArray
#' @param numYears  The number of years in the dataArray
#' @param breakYear The last year in the first dataset
#' 
#' @return A detrended dataArray
#' 
#' @export
NDVIDetrender <- function(dataArray, numCol, numRow, numYears, breakYear)
{
  #preallocate a new array
  detrendedDataArray = array(data=NA, dim=c(numCol, numRow, numYears));
  
  #for each year, create a linear model based on x and y coordinates
  #then find the residuals of the linear model and input them into the detrendedDataArray
  times <- 1:breakYear
  for(i in 1:numCol)
  {
    print(i);
    for(j in 1:numRow)
    {
      detrendedDataArray[i, j,times] = residuals(lm(dataArray[i,j,times]~times))
    }
  }

  
  times <- (breakYear+1):numYears
  for(i in 1:numCol)
  {
    print(i);
    for(j in 1:numRow)
    {
      detrendedDataArray[i, j,times] = residuals(lm(dataArray[i,j,times]~times))
    }
  }
 detrendedDataArray;
}