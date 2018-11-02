SynchronyMapCreator <- function(synchronyMatrix, xExtent, yExtent, tExtent, radius, fileName, title, colorMap =c("#00006F", "#00008F", "#00009F", "#0000AF", "#0000BF", "#0000CF", "#0000DF", "#0000EF", "#0000FF", "#0010FF",
                                              "#0020FF", "#0030FF", "#0040FF", "#0050FF", "#0060FF", "#0070FF", "#0080FF", "#008FFF", "#009FFF", "#00AFFF",
                                              "#00BFFF", "#00CFFF", "#00DFFF", "#00EFFF", "#00FFFF", "#10FFEF", "#20FFDF", "#30FFCF", "#40FFBF", "#50FFAF",
                                              "#60FF9F", "#70FF8F", "#80FF80", "#8FFF70", "#9FFF60", "#AFFF50", "#BFFF40", "#CFFF30", "#DFFF20", "#EFFF10",
                                              "#FFFF00", "#FFEF00", "#FFDF00", "#FFCF00", "#FFBF00", "#FFAF00", "#FF9F00", "#FF8F00", "#FF8000", "#FF7000",
                                              "#FF6000", "#FF5000", "#FF4000", "#FF3000", "#FF2000", "#FF1000", "#FF0000", "#EF0000", "#DF0000", "#CF0000",
                                              "#BF0000", "#AF0000", "#9F0000", "#8F0000"))
{
  library("fields")
  png(file = fileName, width=760, height=480);
  image.plot(xExtent[1]:xExtent[2], yExtent[1]:yExtent[2], synchronyMatrix, ylim=c(yExtent[2],yExtent[1]), 
        main = title, 
        xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap);
  usr<-par('usr');
  rect(usr[1], usr[3], usr[2], usr[4], col="#696969");
  image.plot(xExtent[1]:xExtent[2], yExtent[1]:yExtent[2], synchronyMatrix, ylim=c(yExtent[2],yExtent[1]), 
             main = title, 
             xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap, add=TRUE);
  dev.off();
}