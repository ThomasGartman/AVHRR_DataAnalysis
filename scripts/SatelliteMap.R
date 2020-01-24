#Get Satellite Views


require("ggplot2")
require("ggmap")
source("scripts/AVHRRtoLatLon.R")

SatelliteMap <- function(x1, y1, x2, y2, loc, xOffset, yOffset, fileName, z)
{
  point1 <- AVHRRtoLatLon(x1, y1)
  point2 <- AVHRRtoLatLon(x2, y2)
  pointsDataFrame <- data.frame(lon = c(point1[2], point2[2], point1[2], point2[2]), lat = c(point1[1], point2[1], point2[1], point1[1]))
  
  return(pointsDataFrame)
}