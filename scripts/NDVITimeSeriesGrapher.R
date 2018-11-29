#' Graph Time Series of set of points
#' 
#' Graph the NDVI data at a specific point and the points in a set radius around that point
#' 
#' @param dataArray the array of NDVI data
#' @param xCoor     the xcoordinate to graph
#' @param yCoor     the ycoordinate to graph
#' @param radius    the radius of points to graph around xCoor, yCoor
NDVITimeSeriesGrapher <- function(dataArray, xCoor, yCoor, radius)
{
  png(file = paste('Raw NDVI Time Series at point (', xCoor, '_', yCoor,') with radius = ', radius, '.png', sep=''),
      width=760, height=480);
  plot(seq(1989,2015), dataArray[xCoor, yCoor, ],
       col='red',
       main=paste('Raw NDVI Time Series at point (', xCoor, ',', yCoor,') with radius = ', radius, sep=''),
       pch=15,
       xlab='Year',
       ylab='NDVI Value');
  for(i in range((xCoor-radius):(xCoor+radius)))
  {
    if(i < 1 || i > 4587)
    {
      next;
    }
    for(j in range((yCoor-radius):(yCoor+radius)))
    {
      if(j < 1 || j > 2889)
      {
        next;
      }
      else
      {
        points(seq(1989,2015), dataArray[i,j,], col='blue', pch=1);
        dev.off();
      }
    }
  }
}