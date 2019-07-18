#' Detrend NDVI data
#' 
#' Model NDVI data as a function that takes in x and y coordinates and returns an NDVI value. Create a linear model then
#' compute the residuals of that data.
#' 
#' @param data The array of data to be detrended.
#' @param years The range of years to detrend.
#' 
#' @return Detrended data
#' 
#' @export
library("wsyn")
NDVIDetrender <- function(data, years)
{
  #Error Checking - is the data the appropriate type? 
  if(!(is.array(data) && !is.matrix(data)) && !is.vector(data))
  {
    stop("Error in NDVIDetrender: data must be an array or vector.")
  }
  #Error Checking - is the years a vector?
  if(!is.vector(years) || !is.numeric(years))
  {
    stop("Error in NDVIDetrender: years must be a numeric vector")
  }
  #Error Checking - Do the dimensions match the years?
  if(years[1] <= 0)
  {
    stop("Error in NDVIDetrender: Year range starts before 1.")
  }
  if(is.array(data) && dim(data)[3] < years[length(years)])
  {
    stop("Error in NDVIDetrender: Year range ends after array ends.")
  }
  if(is.vector(data) && length(data) < years[length(years)])
  {
    stop("Error in NDVIDetrender: Year range ends after vector ends.")
  }
  
  if(is.array(data))
  {
    detrendedData <- array(data = NA, dim = c(dim(data)[[1]], dim(data)[[2]], length(years)))
    #Detrend the data array.
    for(i in 1:dim(data)[[1]])
    {
      for(j in 1:dim(data)[[2]])
      {
        if(any(is.na(data[i, j,])))
        {
          next
        }
        detrendedData[i, j, ] <- cleandat(data[i,j,years],1:length(years),2)$cdat[years]
      }
    }
  }
  else
  {
    #Detrend the data vector
    if(any(is.na(data)))
    {
      return(NA)
    }
    detrendedData <- cleandat(data[years],1:length(years),2)$cdat[years]
  }
 return(detrendedData)
}
