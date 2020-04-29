# As far as I understand we want to see visually the results from spatially corrected model from AVHRRStatistics.R, so does this script.

source("scripts/MapCreator_wrapper.R")

########################################
#           Read in Data
########################################

numColors<-25 # number of color in colorscale pallette

#Coordinates
xMatrix <- readRDS("data/csvFiles/AVHRR_X_CoordinateMatrix.RDS")
yMatrix <- readRDS("data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS")

# Our synchrony mat as the observed variable
# this is syn mat calculated from the raw detrended NDVI, we do not consider logit transformed data here.
synchronyMatrix <-readRDS("data/csvFiles/AVHRR_Synchrony1990to2018USA.RDS") 

#synchronybreaks <- seq(from = min(0, na.rm = TRUE), to=max(synchronyMatrix, na.rm = TRUE), length.out = 32 + 1)

# Q for Thomas: the range for the given syn mat is range(synchronyMatrix,na.rm=T) = -0.3698671  1.0000000, but it reads as 0 to 1.
# Thomas said the -ve nvalues are very few in numbers, so we set to it as 0.

synchronybreaks <- seq(from = 0, 
                       to=1, 
                       length.out = numColors)


#---------------- Predictor 1 - Time Averaged NDVI --------------------------------------------------

# Also I remembered once Thomas told me that year 1989 has some dispute: noisy data around south west part, so he decided to do without it.

temporalAverageNDVIMatrix <- readRDS("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.RDS")

NDVIbreaks <- seq(from = min(temporalAverageNDVIMatrix, na.rm = TRUE), 
                  to = max(temporalAverageNDVIMatrix, na.rm = TRUE), 
                  length.out = numColors)

#------------------------ Predictor 2 - Population -------------------------------------------------------
LandscanPopulationArray <- readRDS("data/csvFiles/landscanArray.RDS")
landscanMatrix <- LandscanPopulationArray[,,5] # for 2004 only

#------------------- Predictor 3 - Agriculture ------------------------------------------------------------
agricultureNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.RDS")
agbreaks <- seq(from = min(agricultureNLCDMatrix, na.rm = TRUE), 
                to = max(agricultureNLCDMatrix, na.rm = TRUE), 
                length.out =numColors)

#-------------------------- Predictor 4 - Development ---------------------------------------------------
developmentNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.RDS")
devbreaks <- seq(from = min(developmentNLCDMatrix, na.rm = TRUE), 
                 to = max(developmentNLCDMatrix, na.rm = TRUE), 
                 length.out = numColors)

#------------------------- Predictor 5 - Elevation -----------------------------------------------------
elevationMatrix <- readRDS("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.RDS")
elevationbreaks <- seq(from = min(elevationMatrix, na.rm = TRUE), 
                       to = max(elevationMatrix, na.rm = TRUE), 
                       length.out = numColors)

#------------------------ Predictor 6 - Change in Elevation ------------------------------------------------
slopeMatrix <- readRDS("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.RDS")
slopebreaks <- seq(from = min(slopeMatrix, na.rm = TRUE), 
                   to = max(slopeMatrix, na.rm = TRUE), 
                   length.out = numColors)


########################################
brklist <- list(synchronybreaks = synchronybreaks,
                popbreaks = NULL,
                NDVIbreaks = NDVIbreaks,
                agbreaks = agbreaks,
                devbreaks = devbreaks,
                elevationbreaks = elevationbreaks,
                slopebreaks = slopebreaks)

########################################
# Garden City, KS
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(1926:2025),Yrange=c(1486:1585),nametag = "GC",numColors = numColors,brklist,resloc="images/")

########################################
# Central Valley
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(151:400),Yrange=c(1001:1700),nametag = "C.Valley",numColors = numColors,brklist,resloc="images/")

############################################# INTERIOR CITY ####################################################

########################################
# Charleston, Interior City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(3601:3650),Yrange=c(1301:1330),nametag = "CL",numColors = numColors,brklist,resloc="images/")

########################################
# St. Louis, MO, Interior City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(2851:2931),Yrange=c(1386:1435),nametag = "St.Louis",numColors = numColors,brklist,resloc="images/")

########################################
# Minneapolis, Interior City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(2551:2610),Yrange=c(701:770),nametag = "MN",numColors = numColors,brklist,resloc="images/")

########################################
# Salt Lake City, Interior City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(1031:1075),Yrange=c(1146:1180),nametag = "SLC",numColors = numColors,brklist,resloc="images/")


############################################# DESERT CITY ####################################################

########################################
# Las Vegas, Desert City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(676:720),Yrange=c(1591:1650),nametag = "LV",numColors = numColors,brklist,resloc="images/")

########################################
# Reno, Desert City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(361:381),Yrange=c(1141:1180),nametag = "Reno",numColors = numColors,brklist,resloc="images/")

########################################
# Page, Desert City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(1026:1038),Yrange=c(1578:1585),nametag = "Page",numColors = numColors,brklist,resloc="images/")

########################################
# Pheonix, Desert City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(891:990),Yrange=c(1911:1990),nametag = "PX",numColors = numColors,brklist,resloc="images/")

############################################# COASTAL CITY ####################################################

########################################
# Chicago, Coastal City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(3051:3095),Yrange=c(1001:1045),nametag = "CH",numColors = numColors,brklist,resloc="images/")

########################################
# New Orleans, Coastal City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(2976:3035),Yrange=c(2351:2380),nametag = "NOLA",numColors = numColors,brklist,resloc="images/")

########################################
# New York City, Coastal City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(4171:4250),Yrange=c(851:910),nametag = "NYC",numColors = numColors,brklist,resloc="images/")

########################################
# San Francisco Bay Area, Coastal City
########################################
MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(91:160),Yrange=c(1261:1380),nametag = "SF",numColors = numColors,brklist,resloc="images/")



########################################
# United States of America
########################################

MapCreator_wrapper(synchronyMatrix = synchronyMatrix,
                   landscanMatrix = landscanMatrix, 
                   temporalAverageNDVIMatrix = temporalAverageNDVIMatrix, 
                   agricultureNLCDMatrix = agricultureNLCDMatrix,
                   developmentNLCDMatrix = developmentNLCDMatrix, 
                   elevationMatrix = elevationMatrix, 
                   slopeMatrix = slopeMatrix,
                   Xrange=c(1:4587),Yrange=c(1:2889),nametag = "USA",numColors = numColors,brklist,resloc="images/")



