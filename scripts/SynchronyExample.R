source("scripts/MapCreator.R")
source("scripts/SynchronyMatrixCalculator.R")
SynchronyExample <- function()
{
  #Given a 100x100x10 array
  example <- array(data=runif(100000, max=.5), dim = c(24, 24, 10))
  
  for(k in (8-5):(8+5))
  {
    for(m in (8-5):(8+5))
    {
      if((k > 0 && m > 0) && (k <= 24 && m <= 24))
      {
        if(25 >= (8 - k)^2 + (8 - m)^2) #check to see if it is within the circle of radius R.
        {
          example[k, m, ] <- c(.9,.9,.9,.9,.9,.9,.9,.9,.89,.9)
        }#end if
      }#end if
    }#end for
  }#end for
  
  for(k in (16-5):(16+5))
  {
    for(m in (16-5):(16+5))
    {
      if((k > 0 && m > 0) && (k <= 24 && m <= 24))
      {
        if(25 >= (16 - k)^2 + (16 - m)^2) #check to see if it is within the circle of radius R.
        {
          example[k, m, ] <- c(.9,.9,.9,.9,.9,.9,.9,.9,.89,.9)
        }#end if
      }#end if
    }#end for
  }#end for

  synchronyExample <- SynchronyMatrixCalculator(example, 1:10, 5)
  synchronyExample2 <- matrix(data = NA, nrow = 24, ncol = 24)
  
  for(k in (8-5):(8+5))
  {
    for(m in (8-5):(8+5))
    {
      if((k > 0 && m > 0) && (k <= 24 && m <= 24))
      {
        if(25 >= (8 - k)^2 + (8 - m)^2) #check to see if it is within the circle of radius R.
        {
          synchronyExample2[k, m] <- synchronyExample[k, m]
        }#end if
      }#end if
    }#end for
  }#end for
  
  for(k in (16-5):(16+5))
  {
    for(m in (16-5):(16+5))
    {
      if((k > 0 && m > 0) && (k <= 24 && m <= 24))
      {
        if(25 >= (16 - k)^2 + (16 - m)^2) #check to see if it is within the circle of radius R.
        {
          synchronyExample2[k, m] <- synchronyExample[k, m]
        }#end if
      }#end if
    }#end for
  }#end for
  
  synchronyExample2 <- abs(synchronyExample2)
  MapCreator(synchronyExample2, "images/ExampleSynchrony.png", "Example Synchrony Map, Pearson Correlation, r = 5", "Synchrony", 0, 0, 8)
}