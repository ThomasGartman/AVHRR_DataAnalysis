#' Create Synchrony Maps from a given Synchrony Matrix
#' 
#' You can either create a map with a synchrony scale of 0 to 1 or -1 to 1
#' 
#' @param synchronyMatrix A Matrix that holds synchrony values for a specific area of the world. Assumed to start at 1,1 and be the length of the area sides in question.
#' @param xExtent A two-long vector that holds the starting and ending points for the horizontal portion of the map. Its length must match the number of columns of the synchrony matrix
#' @param yExtent A two-long vector that holds the starting and ending points for the vertical portion of the map. Its length must match the number of rows of the synchrony matrix
#' @param tExtent A two-long vector that holds the starting and ending years for the time scale of the synchrony map.
#' @param radius The radius chosen to calculate the synchrony value for a given pixel. This value determines how many pixels around any given pixel to include in the calculations.
#' @param cor The correlation test used to generate the synchronyMatrix. Must be Pearson, Spearman, or Kendall. Defaults to Pearson.
#' @param fileName The name given to the .png file the image is saved on.
#' @param title The title of the image.
#' @param colorMap The colormap for the image and colorbar to use. Defaults to an altered version of MATLAB(tm)'s Jet color scheme
#' @param brk Where the breaks in the colorMap should be. Defaults to forcing all values smaller than 0 to be black. The number of breaks must be 1 more than the number of colors in colorMap
#' 
#' @return A .png image of the synchronyMatrix in the current working directory.
#' 
#' @author Thomas Gartman \email{thomasgartman@@ku.edu};
#' 
#' @note 
#' 
#' @export
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
  numNegPoints=0
  #Calculate the number of negative points. No choice but to loop
  for(i in xExtent[1]:xExtent[2])
  {
    for(j in yExtent[1]:yExtent[2])
    {
      if(is.na(synchronyMatrix[i - xExtent[1] + 1, j - yExtent[1] + 1]) == FALSE & synchronyMatrix[i - xExtent[1] + 1, j - yExtent[1] + 1] < 0)
      {
        numNegPoints = numNegPoints + 1;
      }
    }
  }
  
  
  #Plot map
  png(file = fileName, width=760, height=480);
  plot.new();
  par("mar"=c(5,4,4,7))
  image(xExtent[1]:xExtent[2], yExtent[1]:yExtent[2], synchronyMatrix, ylim=c(yExtent[2],yExtent[1]), 
        main = title, 
        xlab="Horizontal Coordinate (Kilometers)", ylab="Vertical Coordinate (Kilometers)", col=colorMap,breaks=brk);
  image.plot(col = c("#0020FF", "#0030FF", "#0040FF","#0050FF", "#0060FF", "#0070FF", "#0080FF", "#008FFF", "#009FFF", "#00AFFF",
                     "#00BFFF", "#00CFFF", "#00DFFF", "#00EFFF", "#00FFFF", "#10FFEF", "#20FFDF", "#30FFCF", "#40FFBF", "#50FFAF",
                     "#60FF9F", "#70FF8F", "#80FF80", "#8FFF70", "#9FFF60", "#AFFF50", "#BFFF40", "#CFFF30", "#DFFF20", "#EFFF10",
                     "#FFFF00", "#FFEF00", "#FFDF00", "#FFCF00", "#FFBF00", "#FFAF00", "#FF9F00", "#FF8F00", "#FF8000", "#FF7000",
                     "#FF6000", "#FF5000", "#FF4000", "#FF3000", "#FF2000", "#FF1000", "#FF0000", "#EF0000", "#DF0000", "#CF0000",
                     "#BF0000", "#AF0000", "#9F0000", "#8F0000"), zlim=c(0,1), legend.only=TRUE, add=TRUE);
  usr<-par('usr');
  text(usr[1] + 85, usr[3] - 5, paste("Number of Negative Coorelation Points: ", numNegPoints, sep=""))
  dev.off();
}