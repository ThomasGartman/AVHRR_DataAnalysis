#' Create Synchrony Maps from a given Synchrony Matrix
#' 
#' You can either create a map with a synchrony scale of 0 to 1 or -1 to 1
#' 
#' @param data A Matrix
#' @param fileName The name given to the .png file the image is saved on.
#' @param title The title of the image.
#' @param numColors The number of colors to have
#' @param xOffset Where the x coordinates should start counting from
#' @param yOffset Where the y coordinates should start counting from
#' 
#' @return A .png image of the synchronyMatrix in the current working directory.
#' 
#' @author Thomas Gartman \email{thomasgartman@@ku.edu};
#' 
#' @note 
#' 
#' @export
require("fields")
require("ggplot2")

source("scripts/MatrixToDataFrame.R")
MapCreator <- function(data, fileName, title, legendLabel, xOffset, yOffset, numColors, brk = NULL)
{
  if(is.null(brk))
  {
    brk = seq(from = min(data, na.rm = TRUE), to = max(data, na.rm = TRUE), length.out = numColors + 1)
  }
  
  tempdata <- data
  tempdata[which(tempdata < brk[[1]])] <- brk[[1]]
  dataFrame <- MatrixtoDataFrame(tempdata)
  ggplot(dataFrame, aes(x = dataFrame$x + xOffset, y = dataFrame$y + yOffset, fill = dataFrame$data))  +
    geom_raster() + 
    scale_y_reverse() +
    coord_fixed(ratio = 1, expand = F) + 
    scale_fill_gradientn(
      colors = colorRampPalette(c("Black", "Blue", "Green", "Yellow", "Red"))(numColors), 
      breaks = brk, 
      limits = c(0, brk[[length(brk)]]), 
      labels = c(expression(""<=0), round(brk[2:length(brk)], 3)),
      na.value = "white",
      guide = guide_colorbar(
        direction = "vertical", 
        label.position = "right", 
        label.theme = element_text(size = 8, hjust = .5))) + 
    theme_light() +
    xlab("Horizontal Coordinates (Kilometers)") + 
    ylab("Vertical Coordinates (Kilometers)") + 
    ggtitle(title) + 
    labs(fill = legendLabel) + 
    theme(panel.ontop = T, 
          panel.background = element_blank(), 
          legend.position = "right", 
          legend.key.height = unit(.8, "in"))
  
  ggsave(fileName, device = png(), units = "in")
  dev.off()
  return()
}