#' This function is designed to create a synchrony matrix of a specified region
#' of the continental United States for a specified range of years. The synchrony
#' data is currently designed to work with the Normalized Difference Vegetation 
#' Index data developed in the Reuman lab, but it should be general enough to 
#' operate with any list of matrix data.
#' 
#' Arguments:
#'   DataArray: List of Matrices of data. Every matrix represents one year
#'   Xextent: 2-Long vector that represents the left and right bounds of the synchrony matrix. Should be given in kilometers
#'   Yextent: 2-Long vector that represents the lower and upper bounds of the synchrony matrix. Should be given in kilometers
#'   Textent: 2-Long vector that represents time bounds of the synchrony matrix. Should be given as list indexes.
#'   radius: Number of pixels to make a square synchrony matrix. TODO - Define this as a circular radius in kilometers.
#'   coorTest: The statistical coorelation test used to generate the synchrony matrix. Options are Pearson, Kendall, and
#'             Spearman tests. Defaults to Pearson.
#' 
#' Preconditions:
#'   1. All argument values are valid
#'
#' Postconditions:
#'   None
#'   
#' Returns:
#'   A matrix of the synchrony values of the map at the specified region.