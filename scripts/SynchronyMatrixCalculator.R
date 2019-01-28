#' This function is designed to create a synchrony matrix of a specified region
#' of the continental United States for a specified range of years. The synchrony
#' data is currently designed to work with the Normalized Difference Vegetation 
#' Index data developed in the Reuman lab, but it should be general enough to 
#' operate with any list of matrix data.
#' 
#' Arguments:
#'   dataArray: List of Matrices of data. Every matrix represents one year
#'   xExtent: 2-Long vector that represents the left and right bounds of the synchrony matrix. Should be given in kilometers
#'   yExtent: 2-Long vector that represents the lower and upper bounds of the synchrony matrix. Should be given in kilometers
#'   tExtent: 2-Long vector that represents time bounds of the synchrony matrix. Should be given as list indexes.
#'   radius: Number of pixels to make a square synchrony matrix. TODO - Define this as a circular radius in kilometers.
#'   coorTest: The statistical coorelation test used to generate the synchrony matrix. Options are pearson, kendall, and
#'             spearman tests. Defaults to pearson.
#' 
#' Preconditions:
#'   1. All argument values are valid
#'   2. xExtent, yExtent, and tExtent are given with the lower value first
#'
#' Postconditions:
#'   None
#'   
#' Returns:
#'   A matrix of the synchrony values of the map at the specified region.
SynchronyMatrixCalculator <- function(dataArray, xExtent, yExtent, tExtent, radius, coorTest = "pearson")
{
  #First, preallocate a matrix of length xExtent, yExtent
  synchronyMatrix <- matrix(data=NA, nrow=xExtent[2]-xExtent[1]+1, ncol=yExtent[2]-yExtent[1]+1);
  corNum = 0.0;
  count = 0;
  
  #Calcuate the coorelation matrix for a specific set of pixels
  for(i in xExtent[1]:xExtent[2])
  {
    for(j in yExtent[1]:yExtent[2])
    {
      count = 0;
      corNum = 0.0;
      #For each pixel, calculate the synchrony of each point around the radius
      for(k in (i-radius):(i+radius))
      {
        for(m in (j-radius):(j+radius))
        {
          if(is.na(dataArray[i, j, tExtent[1]:tExtent[2]]) || median(dataArray[i, j, tExtent[1]:tExtent[2]]) == 0)
          {
            next;
          }
          if((k > 0 && m > 0 && i > 0 && j > 0) && (k != i || m != j) && median(dataArray[k, m, tExtent[1]:tExtent[2]]) != 0)
          {
            correlationVal = cor(dataArray[i, j,tExtent[1]:tExtent[2]], dataArray[k, m, tExtent[1]:tExtent[2]])
            if(is.na(correlationVal))
            {
              #print(dataArray[i, j,tExtent[1]:tExtent[2]]);
              #print(dataArray[k, m, tExtent[1]:tExtent[2]]);
            }
            else
            {
              corNum = corNum + correlationVal;
              count = count + 1;
            }
          }#end if
        }#end for
      }#end for
      
      #Now calcuate the average of all of the numbers and store that value in the matrix
      #if count == 0, this means that the pixel is a water pixel
      if(count == 0)
      {
        synchronyMatrix[i + 1 - xExtent[1], j + 1 - yExtent[1]] = NA;
      }
      else
      {
        synchronyMatrix[i + 1 - xExtent[1], j + 1 - yExtent[1]] = corNum/(count);
      }
      #print(paste("Synchrony Value for point (", i, ",", j, "): ", synchronyMatrix[i + 1 - xExtent[1], j + 1 - yExtent[1]], sep=""));
    }#end for
    print(i);
  }#end for
  synchronyMatrix;
}