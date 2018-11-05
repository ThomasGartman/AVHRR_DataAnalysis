SynchronyMapCreator <- function(synchronyMatrix, xExtent, yExtent, tExtent, radius, fileName, title, colorMap =c("#000000", "#0020FF", "#0030FF", "#0040FF","#0050FF", "#0060FF", "#0070FF", "#0080FF", "#008FFF", "#009FFF", "#00AFFF",
                                              "#00BFFF", "#00CFFF", "#00DFFF", "#00EFFF", "#00FFFF", "#10FFEF", "#20FFDF", "#30FFCF", "#40FFBF", "#50FFAF",
                                              "#60FF9F", "#70FF8F", "#80FF80", "#8FFF70", "#9FFF60", "#AFFF50", "#BFFF40", "#CFFF30", "#DFFF20", "#EFFF10",
                                              "#FFFF00", "#FFEF00", "#FFDF00", "#FFCF00", "#FFBF00", "#FFAF00", "#FF9F00", "#FF8F00", "#FF8000", "#FF7000",
                                              "#FF6000", "#FF5000", "#FF4000", "#FF3000", "#FF2000", "#FF1000", "#FF0000", "#EF0000", "#DF0000", "#CF0000",
                                              "#BF0000", "#AF0000", "#9F0000", "#8F0000"), brk=c(-1,1/55, 2/55, 3/55, 4/55, 5/55, 6/55, 7/55, 8/55, 9/55, 10/55,
                                                                                                 11/55, 12/55, 13/55, 14/55, 15/55, 16/55, 17/55, 18/55, 19/55, 20/55
                                                                                                 ,21/55, 22/55,23/55,24/55,25/55,26/55,27/55,28/55,29/55,30/55,31/55,
                                                                                                 32/55,33/55,34/55,35/55,36/55,37/55,38/55,39/55,40/55,41/55,42/55,43/55,
                                                                                                 44/55,45/55,46/55,47/55,48/55,49/55,50/55,51/55,52/55,53/55,54/55,1))
{
  #,"#00006F", "#00008F", "#00009F", "#0000AF", "#0000BF", "#0000CF", "#0000DF","#0000EF", "#0000FF", "#0010FF",
  #
  library("fields")
  
  png(file = fileName, width=760, height=480);
  image(xExtent[1]:xExtent[2], yExtent[1]:yExtent[2], synchronyMatrix, ylim=c(yExtent[2],yExtent[1]), 
        main = title, 
        xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap,breaks=brk);
  par("mar"=c(5,4,4,7))
  usr<-par('usr');
  rect(usr[1], usr[3], usr[2], usr[4], col="#BBBBBB");
  image(xExtent[1]:xExtent[2], yExtent[1]:yExtent[2], synchronyMatrix, ylim=c(yExtent[2],yExtent[1]), 
        main = title, 
        xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap,breaks=brk);
  image.plot(col = c("#0020FF", "#0030FF", "#0040FF","#0050FF", "#0060FF", "#0070FF", "#0080FF", "#008FFF", "#009FFF", "#00AFFF",
                     "#00BFFF", "#00CFFF", "#00DFFF", "#00EFFF", "#00FFFF", "#10FFEF", "#20FFDF", "#30FFCF", "#40FFBF", "#50FFAF",
                     "#60FF9F", "#70FF8F", "#80FF80", "#8FFF70", "#9FFF60", "#AFFF50", "#BFFF40", "#CFFF30", "#DFFF20", "#EFFF10",
                     "#FFFF00", "#FFEF00", "#FFDF00", "#FFCF00", "#FFBF00", "#FFAF00", "#FF9F00", "#FF8F00", "#FF8000", "#FF7000",
                     "#FF6000", "#FF5000", "#FF4000", "#FF3000", "#FF2000", "#FF1000", "#FF0000", "#EF0000", "#DF0000", "#CF0000",
                     "#BF0000", "#AF0000", "#9F0000", "#8F0000"), zlim=c(0,1), legend.only=TRUE);
  dev.off();
}