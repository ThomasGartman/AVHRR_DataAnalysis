source("scripts/MapCreator.R")

########################################
#Read in Data
########################################
#Coordinates
xMatrix <- readRDS("data/csvFiles/AVHRR_X_CoordinateMatrix.RDS")
yMatrix <- readRDS("data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS")

#Predictor 1 - Time Averaged NDVI

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

#Predictor 2 - Population
landscanMatrix <- readRDS("data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.RDS")

# Q for Thomas: landscanpop matrix used in spatially corrected model in AVHRRStatistics was only for 2004,
# should not be the above matrix only for 2004, not the avg. of 2003 and 2004?

#Predictor 3 - Agriculture
agricultureNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.RDS")
agbreaks <- seq(from = min(agricultureNLCDMatrix, na.rm = TRUE), 
                to = max(agricultureNLCDMatrix, na.rm = TRUE), 
                length.out = 32 + 1)

#Predictor 4 - Development
developmentNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.RDS")
devbreaks <- seq(from = min(developmentNLCDMatrix, na.rm = TRUE), 
                 to = max(developmentNLCDMatrix, na.rm = TRUE), 
                 length.out = 32 + 1)

#Predictor 5 - Elevation
elevationMatrix <- readRDS("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.RDS")
elevationbreaks <- seq(from = min(elevationMatrix, na.rm = TRUE), 
                       to = max(elevationMatrix, na.rm = TRUE), 
                       length.out = 32 + 1)

#Predictor 6 - Change in Elevation
slopeMatrix <- readRDS("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.RDS")
slopebreaks <- seq(from = min(slopeMatrix, na.rm = TRUE), 
                   to = max(slopeMatrix, na.rm = TRUE), 
                   length.out = 32 + 1)

#Our transformed synchrony variable as the observed variable
synchronyMatrix <-readRDS("data/csvFiles/AVHRR_Synchrony1990to2018USA.RDS")

#synchronybreaks <- seq(from = min(0, na.rm = TRUE), to=max(synchronyMatrix, na.rm = TRUE), length.out = 32 + 1)

# Q for Thomas: the range for the given syn mat is range(synchronyMatrix,na.rm=T) = -0.3698671  1.0000000, but it reads as 0 to 1.
# So, should we first transform from [-1,1] to a [0,1] scale? and if we do that then do that transformation should be applied on predictors too?

synchronybreaks <- seq(from = 0, 
                       to=1, 
                       length.out = 32 + 1)

########################################
# Garden City, KS
########################################
landscanMatrixGC <- landscanMatrix[1926:2025, 1486:1585]
temporalAverageNDVIMatrixGC <- temporalAverageNDVIMatrix[1926:2025, 1486:1585]
agricultureNLCDMatrixGC <-agricultureNLCDMatrix[1926:2025, 1486:1585]
synchronyMatrixGC <- synchronyMatrix[1926:2025, 1486:1585]
developmentMatrixGC <- developmentNLCDMatrix[1926:2025, 1486:1585]
elevationMatrixGC <- elevationMatrix[1926:2025, 1486:1585]
slopeMatrixGC <- slopeMatrix[1926:2025, 1486:1585]

MapCreator(data = landscanMatrixGC, fileName = "images/GC_Landscan_Population_2003and2004.png", 
           title = "GC Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset=1925,  yOffset = 1485, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixGC, "images/GC_NDVI_TemporalAverage_1989to2018.png", 
           "GC NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 1925, 1485, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixGC, "images/GC_NLCD_Agriculture_Average_2001and2006.png", 
           "GC NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 1925, 1485, 32, agbreaks)
MapCreator(synchronyMatrixGC, "images/GC_Synchrony1989to2018.png", 
           "GC Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 1925, 1485, 32, synchronybreaks)
MapCreator(developmentMatrixGC, "images/GC_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "GC NLCD Development Index Average 2001 and 2006", 
           "Index", 1925, 1485, 32, devbreaks)
MapCreator(elevationMatrixGC, "images/GC_Elevation.png", 
           "GC Elevation Map", 
           "Meters", 1925, 1485, 32, elevationbreaks)
MapCreator(slopeMatrixGC, "images/GC_Slope.png", 
           "GC Standard Deviation Elevation Map", 
           "Meters",1925, 1485, 32, slopebreaks)

########################################
# New Orleans
########################################
landscanMatrixNOLA <- landscanMatrix[2976:3035, 2351:2380]
temporalAverageNDVIMatrixNOLA <- temporalAverageNDVIMatrix[2976:3035, 2351:2380]
agricultureNLCDMatrixNOLA <-agricultureNLCDMatrix[2976:3035, 2351:2380]
synchronyMatrixNOLA <- synchronyMatrix[2976:3035, 2351:2380]
developmentMatrixNOLA <- developmentNLCDMatrix[2976:3035, 2351:2380]
elevationMatrixNOLA <- elevationMatrix[2976:3035, 2351:2380]
slopeMatrixNOLA <- slopeMatrix[2976:3035, 2351:2380]

MapCreator(data = landscanMatrixNOLA, fileName = "images/NOLA_Landscan_Population_2003and2004.png", 
           title = "NOLA Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 2975, yOffset = 2350, numColors = 32, breaks=NULL)
MapCreator(temporalAverageNDVIMatrixNOLA, "images/NOLA_NDVI_TemporalAverage_1989to2018.png", 
           "NOLA NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 2975, 2350, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixNOLA, "images/NOLA_NLCD_Agriculture_Average_2001and2006.png", 
           "NOLA NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 2975, 2350, 32, agbreaks)
MapCreator(synchronyMatrixNOLA, "images/NOLA_Synchrony1989to2018.png", 
           "NOLA Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 2975, 2350, 32, synchronybreaks)
MapCreator(developmentMatrixNOLA, "images/NOLA_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "NOLA NLCD Development Index Average 2001 and 2006", 
           "Index", 2975, 2350, 32, devbreaks)
MapCreator(elevationMatrixNOLA, "images/NOLA_Elevation.png", 
           "NOLA Elevation Map", 
           "Meters", 2975, 2350, 32, elevationbreaks)
MapCreator(slopeMatrixNOLA, "images/NOLA_Slope.png", 
           "NOLA Standard Deviation Elevation Map", 
           "Meters", 2975, 2350, 32, slopebreaks)

########################################
# San Francisco Bay Area
########################################
landscanMatrixSF <- landscanMatrix[91:160, 1261:1380]
temporalAverageNDVIMatrixSF <- temporalAverageNDVIMatrix[91:160, 1261:1380]
agricultureNLCDMatrixSF <-agricultureNLCDMatrix[91:160, 1261:1380]
synchronyMatrixSF <- synchronyMatrix[91:160, 1261:1380]
developmentMatrixSF <- developmentNLCDMatrix[91:160, 1261:1380]
elevationMatrixSF <- elevationMatrix[91:160, 1261:1380]
slopeMatrixSF <- slopeMatrix[91:160, 1261:1380]

MapCreator(data = landscanMatrixSF, fileName = "images/SF_Landscan_Population_2003and2004.png", 
           title = "SF Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 90, yOffset = 1260, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixSF, "images/SF_NDVI_TemporalAverage_1989to2018.png", 
           "SF NDVI Temporal Average 1989 to 2018", "Average NDVI", 90, 1260, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixSF, "images/SF_NLCD_Agriculture_Average_2001and2006.png", 
           "SF NLCD Agricultural Average 2001 and 2006", "Percent Ag", 90, 1260, 32, agbreaks)
MapCreator(synchronyMatrixSF, "images/SF_Synchrony1989to2018.png", 
           "SF Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 90, 1260, 32, synchronybreaks)
MapCreator(developmentMatrixSF, "images/SF_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "SF NLCD Development Index Average 2001 and 2006", 
           "Index", 90, 1260, 32, devbreaks)
MapCreator(elevationMatrixSF, "images/SF_Elevation.png", 
           "SF Elevation Map", 
           "Meters", 90, 1260, 32, elevationbreaks)
MapCreator(slopeMatrixSF, "images/SF_Slope.png", 
           "SF Standard Deviation Elevation Map", 
           "Meters", 90, 1260, 32, slopebreaks)

########################################
# Central Valley
########################################
landscanMatrixCV <- landscanMatrix[151:400, 1001:1700]
temporalAverageNDVIMatrixCV <- temporalAverageNDVIMatrix[151:400, 1001:1700]
agricultureNLCDMatrixCV <-agricultureNLCDMatrix[151:400, 1001:1700]
synchronyMatrixCV <- synchronyMatrix[151:400, 1001:1700]
developmentMatrixCV <- developmentNLCDMatrix[151:400, 1001:1700]
elevationMatrixCV <- elevationMatrix[151:400, 1001:1700]
slopeMatrixCV <- slopeMatrix[151:400, 1001:1700]

MapCreator(data = landscanMatrixCV, fileName = "images/CV_Landscan_Population_2003and2004.png", 
           title = "CV Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 150, yOffset = 1000, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixCV, "images/CV_NDVI_TemporalAverage_1989to2018.png", 
           "CV NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 150, 1000, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixCV, "images/CV_NLCD_Agriculture_Average_2001and2006.png", 
           "CV NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 150, 1000, 32, agbreaks)
MapCreator(synchronyMatrixCV, "images/CV_Synchrony1989to2018.png", 
           "CV Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 150, 1000, 32, synchronybreaks)
MapCreator(developmentMatrixCV, "images/CV_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "CV NLCD Development Index Average 2001 and 2006", 
           "Index", 150, 1000, 32, devbreaks)
MapCreator(elevationMatrixCV, "images/CV_Elevation.png", 
           "CV Elevation Map", 
           "Meters", 150, 1000, 32, elevationbreaks)
MapCreator(slopeMatrixCV, "images/CV_Slope.png", 
           "CV Standard Deviation Elevation Map", 
           "Meters", 150, 1000, 32, slopebreaks)

########################################
# Salt Lake City
########################################
landscanMatrixSLC <- landscanMatrix[1031:1075, 1146:1180]
temporalAverageNDVIMatrixSLC <- temporalAverageNDVIMatrix[1031:1075, 1146:1180]
agricultureNLCDMatrixSLC <-agricultureNLCDMatrix[1031:1075, 1146:1180]
synchronyMatrixSLC <- synchronyMatrix[1031:1075, 1146:1180]
developmentMatrixSLC <- developmentNLCDMatrix[1031:1075, 1146:1180]
elevationMatrixSLC <- elevationMatrix[1031:1075, 1146:1180]
slopeMatrixSLC <- slopeMatrix[1031:1075, 1146:1180]

MapCreator(data = landscanMatrixSLC, fileName = "images/SLC_Landscan_Population_2003and2004.png", 
           title = "SLC Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 1030, yOffset = 1145, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixSLC, "images/SLC_NDVI_TemporalAverage_1989to2018.png", 
           "SLC NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 1030, 1145, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixSLC, "images/SLC_NLCD_Agriculture_Average_2001and2006.png", 
           "SLC NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 1030, 1145, 32, agbreaks)
MapCreator(synchronyMatrixSLC, "images/SLC_Synchrony1989to2018.png", 
           "SLC Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 1030, 1145, 32, synchronybreaks)
MapCreator(developmentMatrixSLC, "images/SLC_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "SLC NLCD Development Index Average 2001 and 2006", 
           "Index", 1030, 1145, 32, devbreaks)
MapCreator(elevationMatrixSLC, "images/SLC_Elevation.png", 
           "SLC Elevation Map", 
           "Meters", 1030, 1145, 32, elevationbreaks)
MapCreator(slopeMatrixSLC, "images/SLC_Slope.png", 
           "SLC Standard Deviation Elevation Map", 
           "Meters", 1030, 1145, 32, slopebreaks)

########################################
# St. Louis, MO
########################################
landscanMatrixSTL <- landscanMatrix[2851:2931, 1386:1435]
temporalAverageNDVIMatrixSTL <- temporalAverageNDVIMatrix[2851:2931, 1386:1435]
agricultureNLCDMatrixSTL <-agricultureNLCDMatrix[2851:2931, 1386:1435]
synchronyMatrixSTL <- synchronyMatrix[2851:2931, 1386:1435]
developmentMatrixSTL <- developmentNLCDMatrix[2851:2931, 1386:1435]
elevationMatrixSTL <- elevationMatrix[2851:2931, 1386:1435]
slopeMatrixSTL <- slopeMatrix[2851:2931, 1386:1435]

MapCreator(data = landscanMatrixSTL, fileName = "images/STL_Landscan_Population_2003and2004.png", 
           title = "STL Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 2850, yOffset = 1385, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixSTL, "images/STL_NDVI_TemporalAverage_1989to2018.png", 
           "STL NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 2850, 1385, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixSTL, "images/STL_NLCD_Agriculture_Average_2001and2006.png", 
           "STL NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 2850, 1385, 32, agbreaks)
MapCreator(synchronyMatrixSTL, "images/STL_Synchrony1989to2018.png", 
           "STL Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 2850, 1385, 32, synchronybreaks)
MapCreator(developmentMatrixSTL, "images/STL_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "STL NLCD Development Index Average 2001 and 2006", 
           "Index", 2850, 1385, 32, devbreaks)
MapCreator(elevationMatrixSTL, "images/STL_Elevation.png", 
           "STL Elevation Map", 
           "Meters", 2850, 1385, 32, elevationbreaks)
MapCreator(slopeMatrixSTL, "images/STL_Slope.png", 
           "STL Standard Deviation Elevation Map", 
           "Meters", 2850, 1385, 32, slopebreaks)

########################################
# Las Vegas
########################################
landscanMatrixLV <- landscanMatrix[676:720, 1591:1650]
temporalAverageNDVIMatrixLV <- temporalAverageNDVIMatrix1990[676:720, 1591:1650]
agricultureNLCDMatrixLV <-agricultureNLCDMatrix[676:720, 1591:1650]
synchronyMatrixLV <- synchronyMatrix[676:720, 1591:1650]
developmentMatrixLV <- developmentNLCDMatrix[676:720, 1591:1650]
elevationMatrixLV <- elevationMatrix[676:720, 1591:1650]
slopeMatrixLV <- slopeMatrix[676:720, 1591:1650]

MapCreator(data = landscanMatrixLV, fileName = "images/LV_Landscan_Population_2003and2004.png", 
           title = "LV Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 675, yOffset = 1590, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixLV, "images/LV_NDVI_TemporalAverage_1990to2018.png", 
           "LV NDVI Temporal Average 1990 to 2018", 
           "Average NDVI", 675, 1590, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixLV, "images/LV_NLCD_Agriculture_Average_2001and2006.png", 
           "LV NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 675, 1590, 32, agbreaks)
MapCreator(synchronyMatrixLV, "images/LV_Synchrony1990to2018.png", 
           "LV Synchrony 1990 to 2018, Pearson, r = 5", 
           "Synchrony", 675, 1590, 32, synchronybreaks)
MapCreator(developmentMatrixLV, "images/LV_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "LV NLCD Development Index Average 2001 and 2006", 
           "Index", 675, 1590, 32, devbreaks)
MapCreator(elevationMatrixLV, "images/LV_Elevation.png", 
           "LV Elevation Map", 
           "Meters", 675, 1590, 32, elevationbreaks)
MapCreator(slopeMatrixLV, "images/LV_Slope.png", 
           "LV Standard Deviation Elevation Map", 
           "Meters", 675, 1590, 32, slopebreaks)

########################################
# Reno
########################################
landscanMatrixReno <- landscanMatrix[361:381, 1141:1180]
temporalAverageNDVIMatrixReno <- temporalAverageNDVIMatrix1990[361:381, 1141:1180]
agricultureNLCDMatrixReno <-agricultureNLCDMatrix[361:381, 1141:1180]
synchronyMatrixReno <- synchronyMatrix[361:381, 1141:1180]
developmentMatrixReno <- developmentNLCDMatrix[361:381, 1141:1180]
elevationMatrixReno <- elevationMatrix[361:381, 1141:1180]
slopeMatrixReno <- slopeMatrix[361:381, 1141:1180]

MapCreator(data = landscanMatrixReno, fileName = "images/Reno_Landscan_Population_2003and2004.png", 
           title = "Reno Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 360, yOffset = 1140, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixReno, "images/Reno_NDVI_TemporalAverage_1990to2018.png", 
           "Reno NDVI Temporal Average 1990 to 2018", 
           "Average NDVI", 360, 1140, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixReno, "images/Reno_NLCD_Agriculture_Average_2001and2006.png", 
           "Reno NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 360, 1140, 32, agbreaks)
MapCreator(synchronyMatrixReno, "images/Reno_Synchrony1990to2018.png", 
           "Reno Synchrony 1990 to 2018, Pearson, r = 5", 
           "Synchrony", 360, 1140, 32, synchronybreaks)
MapCreator(developmentMatrixReno, "images/Reno_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "Reno NLCD Development Index Average 2001 and 2006", 
           "Index", 360, 1140, 32, devbreaks)
MapCreator(elevationMatrixReno, "images/Reno_Elevation.png", 
           "Reno Elevation Map", 
           "Meters", 360, 1140, 32, elevationbreaks)
MapCreator(slopeMatrixReno, "images/Reno_Slope.png", 
           "Reno Standard Deviation Elevation Map", 
           "Meters", 360, 1140, 32, slopebreaks)

########################################
# Page
########################################
landscanMatrixPage <- landscanMatrix[1026:1038, 1578:1585]
temporalAverageNDVIMatrixPage <- temporalAverageNDVIMatrix1990[1026:1038, 1578:1585]
agricultureNLCDMatrixPage <-agricultureNLCDMatrix[1026:1038, 1578:1585]
synchronyMatrixPage <- synchronyMatrix[1026:1035, 1578:1585]
developmentMatrixPage <- developmentNLCDMatrix[1026:1035, 1578:1585]
elevationMatrixPage <- elevationMatrix[1026:1035, 1578:1585]
slopeMatrixPage <- slopeMatrix[1026:1035, 1578:1585]

MapCreator(data = landscanMatrixPage, fileName = "images/Page_Landscan_Population_2003and2004.png", 
           title = "Page Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 1025, yOffset = 1577, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixPage, "images/Page_NDVI_TemporalAverage_1990to2018.png", 
           "Page NDVI Temporal Average 1990 to 2018", 
           "Average NDVI", 1025, 1577, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixPage, "images/Page_NLCD_Agriculture_Average_2001and2006.png", 
           "Page NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 1025, 1577, 32, agbreaks)
MapCreator(synchronyMatrixPage, "images/Page_Synchrony1990to2018.png", 
           "Page Synchrony 1990 to 2018, Pearson, r = 5", 
           "Synchrony", 1025, 1577, 32, synchronybreaks)
MapCreator(developmentMatrixPage, "images/Page_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "Page NLCD Development Index Average 2001 and 2006", 
           "Index", 1025, 1577, 32, devbreaks)
MapCreator(elevationMatrixPage, "images/Page_Elevation.png", 
           "Page Elevation Map", 
           "Meters", 1025, 1577, 32, elevationbreaks)
MapCreator(slopeMatrixPage, "images/Page_Slope.png", 
           "Page Standard Deviation Elevation Map", 
           "Meters", 1025, 1577, 32, slopebreaks)


########################################
# Pheonix
########################################
landscanMatrixPX <- landscanMatrix[891:990, 1911:1990]
temporalAverageNDVIMatrixPX <- temporalAverageNDVIMatrix1990[891:990, 1911:1990]
agricultureNLCDMatrixPX <-agricultureNLCDMatrix[891:990, 1911:1990]
synchronyMatrixPX <- synchronyMatrix[891:990, 1911:1990]
developmentMatrixPX <- developmentNLCDMatrix[891:990, 1911:1990]
elevationMatrixPX <- elevationMatrix[891:990, 1911:1990]
slopeMatrixPX <- slopeMatrix[891:990, 1911:1990]

MapCreator(data = landscanMatrixPX, fileName = "images/PX_Landscan_Population_2003and2004.png", 
           title = "PX Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 890, yOffset = 1910, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixPX, "images/PX_NDVI_TemporalAverage_1990to2018.png", 
           "PX NDVI Temporal Average 1990 to 2018", 
           "Average NDVI", 890, 1910, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixPX, "images/PX_NLCD_Agriculture_Average_2001and2006.png", 
           "PX NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 890, 1910, 32, agbreaks)
MapCreator(synchronyMatrixPX, "images/PX_Synchrony1990to2018.png", 
           "PX Synchrony 1990 to 2018, Pearson, r = 5", 
           "Synchrony", 890, 1910, 32, synchronybreaks)
MapCreator(developmentMatrixPX, "images/PX_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "PX NLCD Development Index Average 2001 and 2006", 
           "Index", 890, 1910, 32, devbreaks)
MapCreator(elevationMatrixPX, "images/PX_Elevation.png", 
           "PX Elevation Map", 
           "Meters", 890, 1910, 32, elevationbreaks)
MapCreator(slopeMatrixPX, "images/PX_Slope.png", 
           "PX Standard Deviation Elevation Map", 
           "Meters", 890, 1910, 32, slopebreaks)

########################################
# New York City
########################################
landscanMatrixNYC <- landscanMatrix[4171:4250, 851:910]
temporalAverageNDVIMatrixNYC <- temporalAverageNDVIMatrix[4171:4250, 851:910]
agricultureNLCDMatrixNYC <-agricultureNLCDMatrix[4171:4250, 851:910]
synchronyMatrixNYC <- synchronyMatrix[4171:4250, 851:910]
developmentMatrixNYC <- developmentNLCDMatrix[4171:4250, 851:910]
elevationMatrixNYC <- elevationMatrix[4171:4250, 851:910]
slopeMatrixNYC <- slopeMatrix[4171:4250, 851:910]

MapCreator(data = landscanMatrixNYC, fileName = "images/NYC_Landscan_Population_2003and2004.png", 
           title = "NYC Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 4170, yOffset = 850, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixNYC, "images/NYC_NDVI_TemporalAverage_1989to2018.png", 
           "NYC NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 4170, 850, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixNYC, "images/NYC_NLCD_Agriculture_Average_2001and2006.png", 
           "NYC NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 4170, 850, 32, agbreaks)
MapCreator(synchronyMatrixNYC, "images/NYC_Synchrony1989to2018.png", 
           "NYC Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 4170, 850, 32, synchronybreaks)
MapCreator(developmentMatrixNYC, "images/NYC_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "NYC NLCD Development Index Average 2001 and 2006", 
           "Index", 4170, 850, 32, devbreaks)
MapCreator(elevationMatrixNYC, "images/NYC_Elevation.png", 
           "NYC Elevation Map", 
           "Meters", 4170, 850, 32, elevationbreaks)
MapCreator(slopeMatrixNYC, "images/NYC_Slope.png", 
           "NYC Standard Deviation Elevation Map", 
           "Meters", 4170, 850, 32, slopebreaks)

########################################
# Chicago
########################################
landscanMatrixCH <- landscanMatrix[3051:3095, 1001:1045]
temporalAverageNDVIMatrixCH <- temporalAverageNDVIMatrix[3051:3095, 1001:1045]
agricultureNLCDMatrixCH <-agricultureNLCDMatrix[3051:3095, 1001:1045]
synchronyMatrixCH <- synchronyMatrix[3051:3095, 1001:1045]
developmentNLCDMatrixCH <- developmentNLCDMatrix[3051:3095, 1001:1045]
elevationMatrixCH <- elevationMatrix[3051:3095, 1001:1045]
slopeMatrixCH <- slopeMatrix[3051:3095, 1001:1045]

MapCreator(data = landscanMatrixCH, fileName = "images/CH_Landscan_Population_2003and2004.png", 
           title = "CH Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 3050, yOffset = 1000, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixCH, "images/CH_NDVI_TemporalAverage_1989to2018.png", 
           "CH NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 3050, 1000, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixCH, "images/CH_NLCD_Agriculture_Average_2001and2006.png", 
           "CH NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 3050, 1000, 32, agbreaks)
MapCreator(synchronyMatrixCH, "images/CH_Synchrony1989to2018.png", 
           "CH Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 3050, 1000, 32, synchronybreaks)
MapCreator(developmentNLCDMatrixCH, "images/CH_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "CH NLCD Development Index Average 2001 and 2006", 
           "Index", 3050, 1000, 32, devbreaks)
MapCreator(elevationMatrixCH, "images/CH_Elevation.png", 
           "CH Elevation Map", 
           "Meters", 3050, 1000, 32, elevationbreaks)
MapCreator(slopeMatrixCH, "images/CH_Slope.png", 
           "CH Standard Deviation Elevation Map", 
           "Meters", 3050, 1000, 32, slopebreaks)

########################################
# Charleston
########################################
landscanMatrixCL <- landscanMatrix[3601:3650, 1301:1330]
temporalAverageNDVIMatrixCL <- temporalAverageNDVIMatrix[3601:3650, 1301:1330]
agricultureNLCDMatrixCL <-agricultureNLCDMatrix[3601:3650, 1301:1330]
synchronyMatrixCL <- synchronyMatrix[3601:3650, 1301:1330]
developmentNLCDMatrixCL <- developmentNLCDMatrix[3601:3650, 1301:1330]
elevationMatrixCL <- elevationMatrix[3601:3650, 1301:1330]
slopeMatrixCL <- slopeMatrix[3601:3650, 1301:1330]

MapCreator(data = landscanMatrixCL, fileName = "images/CL_Landscan_Population_2003and2004.png", 
           title = "CL Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 3600, yOffset = 1300, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixCL, "images/CL_NDVI_TemporalAverage_1989to2018.png", 
           "CL NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 3600, 1300, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixCL, "images/CL_NLCD_Agriculture_Average_2001and2006.png", 
           "CL NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 3600, 1300, 32, agbreaks)
MapCreator(synchronyMatrixCL, "images/CL_Synchrony1989to2018.png", 
           "CL Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 3600, 1300, 32, synchronybreaks)
MapCreator(developmentNLCDMatrixCL, "images/CL_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "CL NLCD Development Index Average 2001 and 2006", 
           "Index", 3600, 1300, 32, devbreaks)
MapCreator(elevationMatrixCL, "images/CL_Elevation.png", 
           "CL Elevation Map", 
           "Meters", 3600, 1300, 32, elevationbreaks)
MapCreator(slopeMatrixCL, "images/CL_Slope.png", 
           "CL Standard Deviation Elevation Map", 
           "Meters", 3600, 1300, 32, slopebreaks)

########################################
# Minneapolis
########################################
landscanMatrixMN <- landscanMatrix[2551:2610, 701:770]
temporalAverageNDVIMatrixMN <- temporalAverageNDVIMatrix[2551:2610, 701:770]
agricultureNLCDMatrixMN <-agricultureNLCDMatrix[2551:2610, 701:770]
synchronyMatrixMN <- synchronyMatrix[2551:2610, 701:770]
developmentNLCDMatrixMN <- developmentNLCDMatrix[2551:2610, 701:770]
elevationMatrixMN <- elevationMatrix[2551:2610, 701:770]
slopeMatrixMN <- slopeMatrix[2551:2610, 701:770]

MapCreator(data = landscanMatrixMN, fileName = "images/MN_Landscan_Population_2003and2004.png", 
          title = "MN Landscan Population Average 2003 and 2004", 
          legendLabel = "Population", xOffset = 2550, yOffset = 700, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrixMN, "images/MN_NDVI_TemporalAverage_1989to2018.png", 
           "MN NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 2550, 700, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixMN, "images/MN_NLCD_Agriculture_Average_2001and2006.png", 
           "MN NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 2550, 700, 32, agbreaks)
MapCreator(synchronyMatrixMN, "images/MN_Synchrony1989to2018.png", 
           "MN Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 2550, 700, 32, synchronybreaks)
MapCreator(developmentNLCDMatrixMN, "images/MN_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "MN NLCD Development Index Average 2001 and 2006", 
           "Index", 2550, 700, 32, devbreaks)
MapCreator(elevationMatrixMN, "images/MN_Elevation.png", 
           "MN Elevation Map", 
           "Meters", 2550, 700, 32, elevationbreaks)
MapCreator(slopeMatrixMN, "images/MN_Slope.png", 
           "MN Standard Deviation Elevation Map", 
           "Meters", 2550, 700, 32, slopebreaks)

########################################
# United States of America
########################################
MapCreator(data = landscanMatrix, fileName = "images/USA_Landscan_Population_2003and2004.png", 
           title = "USA Landscan Population Average 2003 and 2004", 
           legendLabel = "Population", xOffset = 0, yOffset = 0, numColors = 32, brk = NULL)
MapCreator(temporalAverageNDVIMatrix, "images/USA_NDVI_TemporalAverage_1989to2018.png", 
           "USA NDVI Temporal Average 1989 to 2018", 
           "Average NDVI", 0, 0, 32)
MapCreator(agricultureNLCDMatrix, "images/USA_NLCD_Agriculture_Average_2001and2006.png", 
           "USA NLCD Agricultural Average 2001 and 2006", 
           "Percent Ag", 0, 0, 32)
MapCreator(synchronyMatrix, "images/USA_Synchrony1989to2018.png", 
           "USA Synchrony 1989 to 2018, Pearson, r = 5", 
           "Synchrony", 0, 0, 32)
MapCreator(developmentNLCDMatrix, "images/USA_NLCD_DevelopmentIndex_Average_2001and2006.png", 
           "USA NLCD Development Index Average 2001 and 2006", 
           "Index", 0, 0, 32)
MapCreator(elevationMatrix, "images/USA_Elevation.png", 
           "USA Elevation Map", "Meters", 0, 0, 32)
MapCreator(slopeMatrix, "images/USA_Slope.png", 
           "USA Standard Deviation Elevation Map", "Meters", 0, 0, 32)



