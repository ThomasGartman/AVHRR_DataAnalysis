#' Given some x,y AVHRR coordinate, return its Lat and Lon
AVHRRtoLatLon <- function(x, y)
{
  Lat <- t(as.matrix(read.csv("data/csvFiles/AVHRR_LAT.csv", header = FALSE)))
  Lon <- t(as.matrix(read.csv("data/csvFiles/AVHRR_LON.csv", header = FALSE)))
  
  latCoor <- Lat[x, y]
  lonCoor <- Lon[x, y]
  
  return(c(latCoor, lonCoor))
}