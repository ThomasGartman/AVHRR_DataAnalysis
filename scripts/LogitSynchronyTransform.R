#' This function is designed to perform a logit transform on data ranging from 0 to 1.
#' 
#' Arguments:
#'     @param data Some structure that has synchrony values ranging from 0 to 1.

LogitSynchronyTransform <- function(data)
{
  if(any(data <= 0, na.rm=TRUE))
  {
    stop("Logit Synchrony Transform Error: Some values equal to or less than 0.")
  }
  if(any(data > 1, na.rm=TRUE))
  {
    stop("Logit Synchrony Transform Error: Some values greater than 1.")
  }

  return(log(data/(1-data)))
}

