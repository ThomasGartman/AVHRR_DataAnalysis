source("scripts/SpatialMatrixSignificance.R")

# Args:
# transformedMatrix : Response matrix
# drivers : A list of predictor matrices
# xMatrix : x-coordinate matrix
# yMatrix : y co-ordinate matrix
# xrange : a vector having range for x-coordinates
# yrange : a vector having range for y-coordinates

# Output:
# A list of two numbers: a correlation value, and a p-value

SpatiallyCorrectedModels <- function(transformedMatrix, drivers, xMatrix, yMatrix, xrange, yrange){
  correlation <- vector(mode = "numeric")
  pvalue <- vector(mode = "numeric")
  for(i in 1:length(drivers)){
    result <- SpatialMatrixSignificance(data1 = transformedMatrix[xrange, yrange], 
                                        data2 = drivers[[i]][xrange, yrange], 
                                        xmatrix = xMatrix[xrange, yrange], 
                                        ymatrix = yMatrix[xrange, yrange])
    correlation <- append(correlation, result[[1]])
    pvalue <- append(pvalue, result[[2]])
  }
  return(list(correlation=correlation, 
              pvalue=pvalue))
}