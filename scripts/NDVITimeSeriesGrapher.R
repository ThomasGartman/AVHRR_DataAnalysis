#' Graph Time Series of set of points
#' 
#' Graph the NDVI data at a specific point and the points in a set radius around that point
#' 
#' @param dataArray the array of NDVI data
#' @param fileName  Name of the file
#' @param title     Title of the plot
#' @param xCoor     the xcoordinate to graph
#' @param yCoor     the ycoordinate to graph
#' @param radius    the radius of points to graph around xCoor, yCoor
#' 
#' @export
NDVITimeSeriesGrapher <- function(dataArray, fileName, title, xCoor, yCoor, radius)
{
  png(file = fileName,width=1024, height=768);
  plot.new();
  plot(seq(1989,2015), dataArray[xCoor, yCoor, ],
       col='red',
       main=title,
       type='l',
       xlab='Year',
       ylim=c(min(dataArray[(xCoor-radius):(xCoor+radius), (yCoor-radius):(yCoor+radius), ]),max(dataArray[(xCoor-radius):(xCoor+radius), (yCoor-radius):(yCoor+radius), ])),
       ylab='NDVI Value');
  for(i in (xCoor-radius):(xCoor+radius))
  {
    if(i < 1 | i > 4587)
    {
      next;
    }
    for(j in (yCoor-radius):(yCoor+radius))
    {
      if(j < 1 | j > 2889)
      {
        next;
      }
      else
      {
        lines(seq(1989,2015), dataArray[i,j,], col='blue');
      }
    }
  }
  lines(seq(1989,2015), dataArray[xCoor, yCoor, ],col='red', lwd=2)
  dev.off();
}