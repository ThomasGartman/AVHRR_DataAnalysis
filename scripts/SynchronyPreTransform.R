#' This function performs a transformation from the domain [-1, 1] to the domain [0, 1].
#' 
SynchronyPreTransform <- function(data)
{
  if(any(data < -1, na.rm=TRUE))
  {
    stop("Synchrony Pre-Transform Error: Some values less than -1.")
  }
  if(any(data > 1, na.rm=TRUE))
  {
    stop("Synchrony Pre-Transform Error: Some values greater than 1.")
  }
  
  return ((data + 1)/2)
}