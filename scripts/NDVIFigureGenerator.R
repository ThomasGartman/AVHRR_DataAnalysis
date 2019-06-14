GIFCreator <- function(dataArray, lat=NULL, lon=NULL, colorMap =c("#000000", "#00008F", "#00009F", "#0000AF", "#0000BF", "#0000CF", "#0000DF", "#0000EF", "#0000FF", "#0010FF",
                                              "#0020FF", "#0030FF", "#0040FF", "#0050FF", "#0060FF", "#0070FF", "#0080FF", "#008FFF", "#009FFF", "#00AFFF",
                                              "#00BFFF", "#00CFFF", "#00DFFF", "#00EFFF", "#00FFFF", "#10FFEF", "#20FFDF", "#30FFCF", "#40FFBF", "#50FFAF",
                                              "#60FF9F", "#70FF8F", "#80FF80", "#8FFF70", "#9FFF60", "#AFFF50", "#BFFF40", "#CFFF30", "#DFFF20", "#EFFF10",
                                              "#FFFF00", "#FFEF00", "#FFDF00", "#FFCF00", "#FFBF00", "#FFAF00", "#FF9F00", "#FF8F00", "#FF8000", "#FF7000",
                                              "#FF6000", "#FF5000", "#FF4000", "#FF3000", "#FF2000", "#FF1000", "#FF0000", "#EF0000", "#DF0000", "#CF0000",
                                              "#BF0000", "#AF0000", "#9F0000", "#8F0000"), brk=c(-1,0,1/63, 2/63, 3/63, 4/63, 5/63, 6/63, 7/63, 8/63, 9/63, 10/63,
                                                                                               11/63, 12/63, 13/63, 14/63, 15/63, 16/63, 17/63, 18/63, 19/63, 20/63
                                                                                               ,21/63, 22/63,23/63,24/63,25/63,26/63,27/63,28/63,29/63,30/63,31/63,
                                                                                               32/63,33/63,34/63,35/63,36/63,37/63,38/63,39/63,40/63,41/63,42/63,43/63,
                                                                                               44/63,45/63,46/63,47/63,48/63,49/63,50/63,51/63,52/63,53/63,54/63,55/63,56/63,57/63,58/63,59/63,60/63,61/63,62/63,1))
{
  #' Load Dependent Libraries

  library("ggplot2")

  #' Create figures and a gif for the data in the Array
  x = 1:4587
  y = 1:2889
  
  if(is.null(lat) || is.null(lon))
  {
    for(i in 1:30)
    {
      png(file = paste("NormalizedDifferenceVegetationIndex", (i + 1988), ".png", sep=""), width=1024, height=768)
      plot.new();
      par("mar"=c(5,4,4,7))
      image(x, y, as.matrix(dataArray[,,i]), ylim=c(2889,1), main = paste("Normalized Difference Vegetation Index for ", (i + 1988), sep=""),
          xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap, breaks=brk)
      image.plot(col = colorMap, zlim=c(0,1), legend.only=TRUE, add=TRUE);
      usr<-par('usr');
      dev.off()
    }
  }
  else
  {
    for(i in 1:30)
    {
      png(file = paste("NormalizedDifferenceVegetationIndex", (i + 1988), ".png", sep=""), width=1024, height=768)
      plot.new();
      par("mar"=c(5,4,4,7))
      image(lonVector, latVector, as.matrix(dataArray[,,i]), xlim=c(20, 60), ylim=c(-120,-60), main = paste("Normalized Difference Vegetation Index for ", (i + 1988), sep=""),
            xlab="Latitude", ylab="Longitude", col=colorMap, breaks=brk)
      image.plot(col = colorMap, zlim=c(0,1), legend.only=TRUE, add=TRUE);
      usr<-par('usr');
      dev.off()
      dev.off()
    }
  }
  
  system('magick convert -delay 90 -loop 0 *.png NDVI1989To2018.gif')
}