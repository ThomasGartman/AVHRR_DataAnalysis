GIFCreator <- function(dataArray, colorMap =c("#000000", "#00008F", "#00009F", "#0000AF", "#0000BF", "#0000CF", "#0000DF", "#0000EF", "#0000FF", "#0010FF",
                                              "#0020FF", "#0030FF", "#0040FF", "#0050FF", "#0060FF", "#0070FF", "#0080FF", "#008FFF", "#009FFF", "#00AFFF",
                                              "#00BFFF", "#00CFFF", "#00DFFF", "#00EFFF", "#00FFFF", "#10FFEF", "#20FFDF", "#30FFCF", "#40FFBF", "#50FFAF",
                                              "#60FF9F", "#70FF8F", "#80FF80", "#8FFF70", "#9FFF60", "#AFFF50", "#BFFF40", "#CFFF30", "#DFFF20", "#EFFF10",
                                              "#FFFF00", "#FFEF00", "#FFDF00", "#FFCF00", "#FFBF00", "#FFAF00", "#FF9F00", "#FF8F00", "#FF8000", "#FF7000",
                                              "#FF6000", "#FF5000", "#FF4000", "#FF3000", "#FF2000", "#FF1000", "#FF0000", "#EF0000", "#DF0000", "#CF0000",
                                              "#BF0000", "#AF0000", "#9F0000", "#8F0000"))
{
  #' Load Dependent Libraries

  library("ggplot2")

  #' Create figures and a gif for the data in the Array
  x=1:4587
  y=1:2889
  

  for(i in 1:27)
  {
    png(file = paste("NormalizedDifferenceVegitationIndex", (i + 1988), ".png", sep=""), width=640, height=480)
    image(x, y, dataArray[[i]], ylim=c(2889,1), main = paste("Normalized Difference Vegitation Index for ", (i + 1988), sep=""),
          xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap)
    dev.off()
  }
  
  system('magick convert -delay 100 -loop 0 *.png NDVI1989To2015.gif')
}