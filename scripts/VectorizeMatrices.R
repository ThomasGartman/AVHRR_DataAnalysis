#' Vectorize a bunch of matrices using column major order, then for each index 
#' delete that index from every vector if any contain an NA.
#' 
#' Arguments:
#' @param ... matrices

VectorizeMatrices <- function(...)
{
  #Error Checking - all ... must be matrices
  if(any(lapply(list(...), is.matrix) == FALSE))
  {
    stop("Vectorize Matrices Error: Some arguments were not matrices.")
  }
  #Error Checking - all ... must be the same dimension
  if(any(sapply(list(...), dim)[1,] != sapply(list(...), dim)[[1]][1]) || any(sapply(list(...), dim)[2,] != sapply(list(...), dim)[[2]][1]))
  {
    stop("Vectorize Matrices Error: Some matrices not the same dimension as others.")
  }
  
  #list of vectors from matrices
  vectors <- lapply(list(...), as.vector)
  
  alteredVectors <- vectors
  for(i in 1:length(vectors))
  {
    alteredVectors[[i]] <- vectors[[i]][!Reduce("|", lapply(vectors, is.na))]
  }
  
  finalVectors <- alteredVectors
  for(i in 1:length(alteredVectors))
  {
    finalVectors[[i]] <- alteredVectors[[i]][!Reduce("|", lapply(alteredVectors, is.infinite))]
  }
  return(finalVectors)
}