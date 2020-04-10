#' Detrend NDVI Array or Vector Data.
#' 
#' This function wraps the \code{pracma} library function \code{detrend} for detrending data
#' in three dimensional arrays.
#' 
#' @param data The numeric array or vector of data to be detrended.
#' @param years The range of years to detrend.
#' 
#' @return Array or vector object, depending on if input was an array or vector object.
#' 
#' @details This function assumes a structure of data where the years are the last index in the array or the index of the vector.
#' 
#' Normalized Difference Vegetation Index (NDVI) data is structured in the format [x,y,t], where
#' x and y are a 2D mapping of latitude(or longitude) and longitude(or lattitude) onto the Advanced Very High Resolution Radiometer coordinates.
#' Since this data is spatial in nature, it makes sense to store in an array versus a dataframe. This function was written
#' to break the array into [x,y,] vectors and detrend each vector separately. \code{Pracma}'s function \code{detrend} was perfect
#' for this task since it handles missing values exactly as needed.
#' 
#' @author Thomas Gartman, \email{thomasgartman@@ku.edu}, with contributions from Daniel Reuman, \email{reuman@@ku.edu}.
#' 
#' @references 
#' 
#' @export
require("pracma")
NDVIDetrender <- function(data, years){
  #Error Checking - is the data the appropriate type? 
  if(!(is.array(data) && !is.matrix(data)) && !is.vector(data)){
    stop("Error in NDVIDetrender: data must be an array or vector.")
  }
  #Error Checking - is the years a vector?
  if(!is.vector(years) || !is.numeric(years)){
    stop("Error in NDVIDetrender: years must be a numeric vector")
  }
  #Error Checking - Do the dimensions match the years?
  if(years[1] <= 0){
    stop("Error in NDVIDetrender: Year range starts before 1.")
  }
  if(is.array(data) && dim(data)[3] < years[length(years)]){
    stop("Error in NDVIDetrender: Year range ends after array ends.")
  }
  if(is.vector(data) && length(data) < years[length(years)]){
    stop("Error in NDVIDetrender: Year range ends after vector ends.")
  }
  
  if(is.array(data)){
    detrendedData <- data[,,years]
    #Detrend the data array.
    for(i in 1:dim(data)[[1]]){
      for(j in 1:dim(data)[[2]]){
        detrendedData[i, j, 1:length(years)] <- as.vector(detrend(detrendedData[i, j,1:length(years)]))
      }
    }
  }else{
    #Detrend the data vector
    detrendedData <- as.vector(detrend(data[years]))
  }
  return(detrendedData)
}
