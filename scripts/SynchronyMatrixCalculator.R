#' This function is designed to create a synchrony matrix of a specified region
#' of the continental United States for a specified range of years. The synchrony
#' data is currently designed to work with the Normalized Difference Vegetation 
#' Index data developed in the Reuman lab, but it should be general enough to 
#' operate with any list of matrix data.
#' 
#' Arguments:
#'   @param dataArray: List of Matrices of data. Every matrix represents one year.
#'   @param years: Numeric vector that represents time bounds of the synchrony matrix. Should be given as list indexes.
#'   @param radius: Number of pixels to make a circular synchrony matrix.
#'   @param coorTest: The statistical coorelation test used to generate the synchrony matrix. Options are pearson, kendall, and
#'             spearman tests. Defaults to pearson.
#' 
#' Preconditions:
#'   1. All argument values are valid
#'   2. years is given with the lowest value first
#'
#' Postconditions:
#'   None
#'   
#' Returns:
#'   A matrix of the synchrony values of the map at the specified region.
source("scripts/ta_pscor.R")
SynchronyMatrixCalculator <- function(dataArray, years, radius, coorTest = "pearson")
{
  #Error Checking - is the dataArray an array of dimension 3?
  if(!is.array(dataArray) || length(dim(dataArray)) != 3)
  {
    stop("Error in SynchronyMatrixCalculator: dataArray must be a 3D array.")
  }
  #Error Checking - is the years a vector?
  if(!is.vector(years) || !is.numeric(years))
  {
    stop("Error in SynchronyMatrixCalculator: years must be a numeric vector")
  }
  #Error Checking - Do the dimensions match the years?
  if(years[1] <= 0)
  {
    stop("Error in SynchronyMatrixCalculator: Year range starts before 1.")
  }
  if(dim(dataArray)[3] < years[length(years)])
  {
    stop("Error in SynchronyMatrixCalculator: Year range ends after array ends.")
  }
  #Error checking - radius is numeric
  if(!(is.vector(radius) && length(radius) == 1) || !is.numeric(radius))
  {
    stop("Error in SynchronyMatrixCalculator: radius must be a numeric value.")
  }
  #Error checking - radius is greater than zero
  if(radius <= 0)
  {
    stop("Error in SynchronyMatrixCalculator: radius must be a positive number.")
  }
  #Error checking - coorelation test is pearson, kendall, or spearman
  if(!is.character(coorTest) || (coorTest != "pearson" && coorTest != "kendall" && coorTest != "spearman" && coorTest != "copula"))
  {
    stop("Error in SynchronyMatrixCalculator: coorelation test must be exactly 'pearson', 'kendall', 'spearman', or 'copula'.")
  }
  
  
  
  #First, preallocate a matrix of dataArray dimensions
  synchronyMatrix <- matrix(data=NA, nrow=dim(dataArray)[[1]], ncol=dim(dataArray)[[2]])
  lowerMatrix <- matrix(data=NA, nrow=dim(dataArray)[[1]], ncol=dim(dataArray)[[2]])
  upperMatrix <- matrix(data=NA, nrow=dim(dataArray)[[1]], ncol=dim(dataArray)[[2]])
  
  #Calcuate the coorelation matrix for a specific set of pixels
  for(i in 1:dim(dataArray)[[1]])
  {
    for(j in 1:dim(dataArray)[[2]])
    {
      count <- 0;
      lowerCopulaCount <- 0;
      upperCopulaCount <- 0;
      
      corNum <- 0;
      lowerCopulaValue <- 0;
      upperCopulaValue <- 0;
      #For each pixel, calculate the synchrony of each point around the radius
      for(k in (i-radius):(i+radius))#only consider points in a square around the specific synchrony point
      {
        for(m in (j-radius):(j+radius))
        {
          if((k > 0 && m > 0) && !(k == i && m == j) && (k <= dim(dataArray)[[1]] && m <= dim(dataArray)[[2]]))
          {
            if(any(is.na(dataArray[k, m, years])))
            {
              next;
            }
            if(radius*radius >= (i - k)^2 + (j - m)^2) #check to see if it is within the circle of radius R.
            {
              if(coorTest != 'copula')
              {
                correlationVal <- cor(dataArray[i, j,years], dataArray[k, m, years], method = coorTest)
                if(!is.na(correlationVal))
                {
                  corNum <- corNum + correlationVal
                  count <- count + 1
                }
              }
              else
              {
                tails <- ta_pscor(dataArray[i, j,years], dataArray[k, m, years])
                if(!is.na(tails[[1]]))
                {
                  lowerCopulaValue <- tails[[1]]
                  lowerCopulaCount <- lowerCopulaCount + 1
                }
                if(!is.na(tails[[2]]))
                {
                  upperCopulaValue <- tails[[2]]
                  upperCopulaCount <- upperCopulaCount + 1
                }
              }
            }#end if
          }#end if
        }#end for
      }#end for
      
      #Now calcuate the average of all of the numbers and store that value in the matrix
      #if count == 0, this means that the pixel is a water pixel
      if(coorTest == 'copula')
      {
        if(lowerCopulaCount == 0)
        {
          lowerMatrix[i, j] <- NA;
        }
        else
        {
          lowerMatrix[i, j] <- lowerCopulaValue/(lowerCopulaCount)
        }
        if(upperCopulaCount == 0)
        {
          upperMatrix[i, j] <- NA;
        }
        else
        {
          upperMatrix[i, j] <- lowerCopulaValue/(lowerCopulaCount)
        }
      }
      else
      {      
        if(count == 0)
        {
          synchronyMatrix[i, j] <- NA
        }
        else
        {
          synchronyMatrix[i, j] <- corNum/(count)
        }
      }
    }#end for
    print(i)
  }#end for

  if(coorTest == 'copula')
  {
    return(list(lowerMatrix, upperMatrix)) 
  }
  else
  {
    return(synchronyMatrix)
  }
}
