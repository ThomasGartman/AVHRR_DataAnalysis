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
    #Detrend the data array.
    detrendedData <- cleandat(data[,,years],1:length(data[,,years]),2)$cdat[years]
  }
  else
  {
    #Detrend the data vector
    detrendedData <- cleandat(data[years],1:length(years),2)$cdat[years]
  }
 return(detrendedData)
}
