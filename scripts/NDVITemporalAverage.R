#' Create a matrix that is the temporally averaged NDVI values for the specified years
#' 
#' Arguments:
#'     @param matrix The NDVI array to be averaged
#'     @param startYear The first year to be included in the average
#'     @param endYear The last year to be included in the average
NDVITemporalAverage <- function(matrix, startYear, endYear)
{
  tempAveMatrix <- matrix(data=NA, ncol = 4587, nrow=2889)
  tempAveMatrix <- apply(matrix[,,startYear:endYear], 1, FUN=mean)
  tempAveMatrix
}