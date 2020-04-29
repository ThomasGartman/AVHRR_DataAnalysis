source("scripts/MapCreator.R")
#################################################################################
# This function creates maps for response and predictor maps 
# specifically written to summarize visual findings from AVHRRStatistics.R output

# Args
# 1 observed and 6 predictor matrices,
# Xrange = a vector specifying range for x-coordinates from the whole US map
# Yrange = a vector specifying range for y-coordinates from the whole US map
# nametag = a charcter, generally I use the focal city name around which the plot scene to be drawn
# numColors = an integer for the number of colors to have
# brklist = a named list, specifying brk argument for each of the 7 matrices
# resloc = a character - location folder to save the 7 output png plots, default "images/"


Xrange=c(1926:2025)
Yrange=c(1486:1585)
MapCreator_wrapper<-function(synchronyMatrix,
                             landscanMatrix,temporalAverageNDVIMatrix,agricultureNLCDMatrix,
                             developmentNLCDMatrix,elevationMatrix,slopeMatrix,
                             Xrange,Yrange,nametag,numColors,brklist,resloc="images/"){
  
  # Observed response matrix
  synchronyMatrix <- synchronyMatrix[Xrange, Yrange]
  
  # Predictor matrices
  landscanMatrix <- landscanMatrix[Xrange, Yrange]
  temporalAverageNDVIMatrix <- temporalAverageNDVIMatrix[Xrange, Yrange]
  agricultureNLCDMatrix <-agricultureNLCDMatrix[Xrange, Yrange]
  developmentMatrix <- developmentNLCDMatrix[Xrange, Yrange]
  elevationMatrix <- elevationMatrix[Xrange, Yrange]
  slopeMatrix <- slopeMatrix[Xrange, Yrange]
  
  xOffset <- Xrange[1]-1
  yOffset <- Yrange[1]-1
  
  # Map for response matrix
  MapCreator(data = synchronyMatrix, fileName = paste(resloc,nametag,"_Synchrony1990to2018.png",sep=""),
             title = paste(nametag, " Synchrony 1990 to 2018, Pearson, r = 5", sep=""),
             legendLabel = "Synchrony", xOffset = xOffset, yOffset = yOffset, numColors = numColors, brk = brklist$synchronybreaks)
  
  # Map for predictor matrices
  MapCreator(data = landscanMatrix, fileName = paste(resloc,nametag,"_Landscan_Population_2003and2004.png",sep=""), 
             title = paste(nametag," Landscan Population Average 2003 and 2004",sep=""), 
             legendLabel = "Population", xOffset=xOffset,  yOffset = yOffset, numColors = numColors, brk = brklist$popbreaks)
  
  MapCreator(data = temporalAverageNDVIMatrix, fileName = paste(resloc,nametag,"_NDVI_TemporalAverage_1990to2018.png",sep=""),
             title = paste(nametag, " NDVI Temporal Average 1990 to 2018", sep=""),
             legendLabel = "Average NDVI", xOffset = xOffset, yOffset = yOffset, numColors = numColors, brk = brklist$NDVIbreaks)
  
  MapCreator(data = agricultureNLCDMatrix, fileName = paste(resloc,nametag,"_NLCD_Agriculture_Average_2001and2006.png",sep=""),
             title = paste(nametag, " NLCD Agricultural Average 2001 and 2006", sep=""),
             legendLabel = "Percent Ag", xOffset = xOffset, yOffset = yOffset, numColors = numColors, brk = brklist$agbreaks)
  
  MapCreator(data = developmentMatrix,  fileName = paste(resloc,nametag,"_NLCD_DevelopmentIndex_Average_2001and2006.png",sep=""), 
             title = paste(nametag, " NLCD Development Index Average 2001 and 2006", sep=""),
             legendLabel = "Index", xOffset = xOffset, yOffset = yOffset, numColors = numColors, brk = brklist$devbreaks)
  
  MapCreator(data = elevationMatrix, fileName = paste(resloc,nametag,"_Elevation.png",sep=""), 
             title = paste(nametag, " Mean Elevation Map", sep=""),
             legendLabel = "Meters", xOffset = xOffset, yOffset = yOffset, numColors = numColors, brk = brklist$elevationbreaks)
  
  MapCreator(data = slopeMatrix, fileName = paste(resloc,nametag,"_Slope.png",sep=""), 
             title = paste(nametag, " Standard Deviation Elevation Map", sep=""),
             legendLabel = "Meters", xOffset = xOffset, yOffset = yOffset, numColors = numColors, brk = brklist$slopebreaks)
  
}

































