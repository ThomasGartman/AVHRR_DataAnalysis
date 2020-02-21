source("scripts/SpatialMatrixSignificance.R")

SpatiallyCorrectedModels <- function(transformedMatrix, drivers, xMatrix, yMatrix, xrange, yrange)
{
  correlation <- vector(mode = "numeric")
  pvalue <- vector(mode = "numeric")
  for(i in 1:length(drivers))
  {
    result <- SpatialMatrixSignificance(transformedMatrix[xrange, yrange], drivers[[i]][xrange, yrange], xMatrix[xrange, yrange], yMatrix[xrange, yrange])
    correlation <- append(correlation, result[[1]])
    pvalue <- append(pvalue, result[[2]])
  }
  return(list(correlation, pvalue))
}