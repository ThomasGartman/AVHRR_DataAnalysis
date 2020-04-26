source("scripts/MapCreator_wrapper.R")

########################################
#           Read in Data
########################################
#Coordinates
xMatrix <- readRDS("data/csvFiles/AVHRR_X_CoordinateMatrix.RDS")
yMatrix <- readRDS("data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS")

# Our transformed synchrony variable as the observed variable
synchronyMatrix <-readRDS("data/csvFiles/AVHRR_Synchrony1990to2018USA.RDS")

# Q for Thomas: synchronyMatrix <- readRDS("data/csvFiles/AVHRR_TransformedLongUSA1990to2018.RDS") should not be this Pearson based one?

#synchronybreaks <- seq(from = min(0, na.rm = TRUE), to=max(synchronyMatrix, na.rm = TRUE), length.out = 32 + 1)

# Q for Thomas: the range for the given syn mat is range(synchronyMatrix,na.rm=T) = -0.3698671  1.0000000, but it reads as 0 to 1.
# So, should we first transform from [-1,1] to a [0,1] scale? and if we do that then do that transformation should be applied on predictors too?

synchronybreaks <- seq(from = 0, 
                       to=1, 
                       length.out = 32 + 1)


#---------------- Predictor 1 - Time Averaged NDVI --------------------------------------------------

#temporalAverageNDVIMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv"), header = FALSE) 

# Q for Thomas: why the above 1989 to 2018 matrix is used everywhere in this code, should not it be 1990 to 2018?
# Also I remembered once Thomas told me that year 1989 has some dispute, so he decided to do without it.
# As far as I understand we want to see visually the results from spatially corrected model from AVHRRStatistics.R

temporalAverageNDVIMatrix1990 <- readRDS("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.RDS")

NDVIbreaks <- seq(from = min(temporalAverageNDVIMatrix1990, na.rm = TRUE), 
                  to = max(temporalAverageNDVIMatrix1990, na.rm = TRUE), 
                  length.out = 32 + 1)
# Q for Thomas:
# why always you put 32+1 = 33 for length of color scale? 1989 to 2018 = 30 yrs, we are considering from 1990 to 2018,
# numcolors = 32 used as args in MapCreator function

#------------------------ Predictor 2 - Population -------------------------------------------------------
landscanMatrix <- readRDS("data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.RDS")

# Q for Thomas: landscanpop matrix used in spatially corrected model in AVHRRStatistics was only for 2004,
# should not be the above matrix only for 2004, not the avg. of 2003 and 2004?

#------------------- Predictor 3 - Agriculture ------------------------------------------------------------
agricultureNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.RDS")
agbreaks <- seq(from = min(agricultureNLCDMatrix, na.rm = TRUE), 
                to = max(agricultureNLCDMatrix, na.rm = TRUE), 
                length.out = 32 + 1)

#-------------------------- Predictor 4 - Development ---------------------------------------------------
developmentNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.RDS")
devbreaks <- seq(from = min(developmentNLCDMatrix, na.rm = TRUE), 
                 to = max(developmentNLCDMatrix, na.rm = TRUE), 
                 length.out = 32 + 1)

#------------------------- Predictor 5 - Elevation -----------------------------------------------------
elevationMatrix <- readRDS("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.RDS")
elevationbreaks <- seq(from = min(elevationMatrix, na.rm = TRUE), 
                       to = max(elevationMatrix, na.rm = TRUE), 
                       length.out = 32 + 1)

#------------------------ Predictor 6 - Change in Elevation ------------------------------------------------
slopeMatrix <- readRDS("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.RDS")
slopebreaks <- seq(from = min(slopeMatrix, na.rm = TRUE), 
                   to = max(slopeMatrix, na.rm = TRUE), 
                   length.out = 32 + 1)


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
                   Xrange=c(1926:2025),Yrange=c(1486:1585),nametag = "GC",brklist,resloc="images/")

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
                   Xrange=c(151:400),Yrange=c(1001:1700),nametag = "C.Valley",brklist,resloc="images/")

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
                   Xrange=c(3601:3650),Yrange=c(1301:1330),nametag = "CL",brklist,resloc="images/")

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
                   Xrange=c(2851:2931),Yrange=c(1386:1435),nametag = "St.Louis",brklist,resloc="images/")

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
                   Xrange=c(2551:2610),Yrange=c(701:770),nametag = "MN",brklist,resloc="images/")

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
                   Xrange=c(1031:1075),Yrange=c(1146:1180),nametag = "SLC",brklist,resloc="images/")


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
                   Xrange=c(676:720),Yrange=c(1591:1650),nametag = "LV",brklist,resloc="images/")

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
                   Xrange=c(361:381),Yrange=c(1141:1180),nametag = "Reno",brklist,resloc="images/")

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
                   Xrange=c(1026:1038),Yrange=c(1578:1585),nametag = "Page",brklist,resloc="images/")

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
                   Xrange=c(891:990),Yrange=c(1911:1990),nametag = "PX",brklist,resloc="images/")

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
                   Xrange=c(3051:3095),Yrange=c(1001:1045),nametag = "CH",brklist,resloc="images/")

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
                   Xrange=c(2976:3035),Yrange=c(2351:2380),nametag = "NOLA",brklist,resloc="images/")

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
                   Xrange=c(4171:4250),Yrange=c(851:910),nametag = "NYC",brklist,resloc="images/")

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
                   Xrange=c(91:160),Yrange=c(1261:1380),nametag = "SF",brklist,resloc="images/")



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
                   Xrange=c(1:4587),Yrange=c(1:2889),nametag = "USA",brklist,resloc="images/")



