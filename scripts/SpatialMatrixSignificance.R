#' Determine the correlation and p-value between responce and predictor of the same scene.
#' 
#' Given a responce matrix and a predictor matrix of the same scene, we can correct for spatial 
#' autocorrelation and determine whether or not a particular predictor is actually significant.
#' This function can be viewed as a SpatialPack::modified.ttest wrapper.
#' 
#' Arguments:
#'   @param data1: First matrix of scene
#'   @param data2: Second matrix of scene
#'   @param xmatrix: x coordinate Matrix of scene
#'   @param ymatrix: y coordinate Matrix of scene
#' 
#' Returns:
#'   A list of the correlation and p-value between data1 and data2
require("SpatialPack")
source("scripts/VectorizeMatrices.R")
SpatialMatrixSignificance <- function(data1, data2, xmatrix, ymatrix)
{
  #Error Checking - is data1 a 2D numeric matrix
  if(!is.matrix(data1) || !is.numeric(data1))
  {
    stop("Error in SpatialMatrixSignificance: data1 must be a 2D numeric matrix.")
  }
  #Error Checking - is data2 a 2D numeric matrix
  if(!is.matrix(data2) || !is.numeric(data2))
  {
    stop("Error in SpatialMatrixSignificance: data2 must be a 2D numeric matrix.")
  }
  #Error Checking - do the two data matrices have the same length?
  if(nrow(data1) != nrow(data2) || ncol(data1) != ncol(data2))
  {
    stop("Error in SpatialMatrixSignificance: data1 and data2 must have the same dimensions.")
  }
  #Error Checking - is the x coordinate matrix a numeric matrix?
  if(!is.matrix(xmatrix) || !is.numeric(xmatrix))
  {
    stop("Error in spatialMatrixSignificance: xmatrix must be a numeric matrix.")
  }
  #Error Checking - is the y coordinate matrix a numeric matrix?
  if(!is.matrix(ymatrix) || !is.numeric(ymatrix))
  {
    stop("Error in spatialMatrixSignificance: ymatrix must be a numeric matrix.")
  }
  #Error Checking - does the x matrix have the same dimenisions as the data matrices?
  if(ncol(xmatrix) != ncol(data1) || nrow(xmatrix) != nrow(data1))
  {
    stop("Error in spatialMatrixSignificance: xmatrix must have the same dimensions as data.")
  }
  #Error Checking - does the y matrix have the same dimenisions as the data matrices?
  if(ncol(ymatrix) != ncol(data1) || nrow(ymatrix) != nrow(data1))
  {
    stop("Error in spatialMatrixSignificance: ymatrix must have the same dimensions as data.")
  }
  
  #vectorize
  vectors <- VectorizeMatrices(data1, data2, xmatrix, ymatrix)
  
  result <- modified.ttest(vectors[[1]], vectors[[2]], matrix(c(vectors[[3]], vectors[[4]]), nrow = length(vectors[[1]]), ncol = 2))
  return(c(result$corr, result$p.value))
}
