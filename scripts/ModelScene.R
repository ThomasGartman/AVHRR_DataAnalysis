#' Scene Modeling
#' 
#' This function will generate models based upon the data and ranges given.
#' 
#' Arguments:
#' @param ... matrix objects to perform statistics over - must be the same dimensions.... first matrix is response matrix
#' 
#' @return an lm object

source("scripts/VectorizeMatrices.R")

ModelScene <- function(...)
{
  #Error Checking - all ... must be matrices
  if(any(lapply(list(...), is.matrix) == FALSE))
  {
    stop("ModelScene Error: Some arguments were not matrices.")
  }
  #Error Checking - all ... must be the same dimension
  if(any(sapply(list(...), dim)[1,] != sapply(list(...), dim)[[1]][1]) || any(sapply(list(...), dim)[2,] != sapply(list(...), dim)[[2]][1]))
  {
    stop("ModelScene Error: Some matrices not the same dimension as others.")
  }
  if(length(list(...)) < 2)
  {
    stop("ModelScene Error: Must include at least 2 matrices.")
  }
  
  vectors <- VectorizeMatrices(...)
  
  responceVector <- vectors[[1]]
  predictorVectors <- vectors[-1]
  
  linearModel <- lm(responceVector ~ .,data=as.data.frame(sapply(predictorVectors, as.vector)))
  return(linearModel)
}