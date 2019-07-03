#' This function is designed to perform a logit transform on synchrony data ranging from -1 to 1.
#' 
#' Arguments:
#'     @param synchronyMatrix A matrix of dimensions numCols amd numRows of synchrony values ranging from -1 to 1.
#'     @param numCols The number of columns of the synchrony matrix
#'     @param numRows The number of rows of the synchrony matrix

logitTransform <- function(synchronyMatrix, numCols, numRows)
{
  transformedMatrix <- matrix(data=NA, ncol = numCols, nrow = numRows)
  #First, transform the domain (-1, 1) to (0, 1), then perform logit transformation
  transformedMatrix <- log(((synchronyMatrix + 1)/2.0)/(1 - ((synchronyMatrix + 1)/2.0)))
  transformedMatrix
}
