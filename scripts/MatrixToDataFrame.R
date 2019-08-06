#Data frames required for ggplot2

MatrixtoDataFrame <- function(data)
{
  xVector <- rep(NA, dim(data)[[1]]*dim(data)[[2]])
  yVector <- rep(NA, dim(data)[[1]]*dim(data)[[2]])
  zVector <- rep(NA, dim(data)[[1]]*dim(data)[[2]])
  for(i in 1:dim(data)[[1]])
  {
    for(j in 1:dim(data)[[2]])
    {
      xVector[((i - 1) * dim(data)[[2]]) + j] <- i 
      yVector[((i - 1) * dim(data)[[2]]) + j] <- j
      zVector[((i - 1) * dim(data)[[2]]) + j] <- data[i, j]
    }
  }
  newDataFrame <- data.frame(x = xVector, y = yVector, data = zVector)
  return(newDataFrame)
}