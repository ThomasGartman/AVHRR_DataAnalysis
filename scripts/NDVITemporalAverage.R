#' Create a matrix that is the temporally averaged NDVI values for the specified years
#' 
#' Arguments:
#'     @param data The NDVI array to be averaged

NDVITemporalAverage <- function(data)
{
  if(!is.array(data))
  {
    stop("NDVI Temporal Average Error: Data must be an array.")
  }
  if(!length(dim(data)) == 3)
  {
    stop("NDVI Temporal Average Error: Data must be of dimension three.")
  }
  if(!is.numeric(data))
  {
    stop("NDVI Temporal Average Error: Data must be numeric.")
  }
  tempAveMatrix <- matrix(data=NA, ncol = dim(data)[[2]], nrow=dim(data)[[1]])
  for(i in 1:dim(data)[[1]])
  {
    for(j in 1:dim(data)[[2]])
    {
      tempAveMatrix[i, j] <- mean(data[i,j,])
    }
  }
  return(tempAveMatrix)
}
