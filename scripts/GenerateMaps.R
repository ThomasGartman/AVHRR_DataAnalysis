source("scripts/MapCreator.R")

########################################
#Read in Data
########################################
#Coordinates
xMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_X_CoordinateMatrix.csv"), header = FALSE)
yMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Y_CoordinateMatrix.csv"), header = FALSE)

#Predictor 1 - Time Averaged NDVI
temporalAverageNDVIMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv"), header = FALSE)
temporalAverageNDVIMatrix1990 <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.csv"), header = FALSE)

NDVIbreaks <- seq(from = min(temporalAverageNDVIMatrix, na.rm = TRUE), to = max(temporalAverageNDVIMatrix, na.rm = TRUE), length.out = 32 + 1)

#Predictor 2 - Population
landscanMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.csv"), header = FALSE)

#Predictor 3 - Agriculture
agricultureNLCDMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.csv"), header = FALSE)
agbreaks <- seq(from = min(agricultureNLCDMatrix, na.rm = TRUE), to = max(agricultureNLCDMatrix, na.rm = TRUE), length.out = 32 + 1)

#Predictor 4 - Development
developmentNLCDMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.csv"), header = FALSE)
devbreaks <- seq(from = min(developmentNLCDMatrix, na.rm = TRUE), to = max(developmentNLCDMatrix, na.rm = TRUE), length.out = 32 + 1)

#Predictor 5 - Elevation
elevationMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.csv"), header = FALSE)
elevationbreaks <- seq(from = min(elevationMatrix, na.rm = TRUE), to = max(elevationMatrix, na.rm = TRUE), length.out = 32 + 1)

#Predictor 6 - Change in Elevation
slopeMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.csv"), header = FALSE)
slopebreaks <- seq(from = min(slopeMatrix, na.rm = TRUE), to = max(slopeMatrix, na.rm = TRUE), length.out = 32 + 1)

#Our transformed synchrony variable as the observed variable
synchronyMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Synchrony1990to2018USA.csv"), header = FALSE)

synchronybreaks <- seq(from = min(0, na.rm = TRUE), to = max(synchronyMatrix, na.rm = TRUE), length.out = 32 + 1)

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

#Make the Maps
MapCreator(landscanMatrixGC, "images/GC_Landscan_Population_2003and2004.png", "GC Landscan Population Average 2003 and 2004", "Population", 2975, 2350, 32)
MapCreator(temporalAverageNDVIMatrixGC, "images/GC_NDVI_TemporalAverage_1989to2018.png", "GC NDVI Temporal Average 1989 to 2018", "Average NDVI", 2975, 2350, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixGC, "images/GC_NLCD_Agriculture_Average_2001and2006.png", "GC NLCD Agricultural Average 2001 and 2006", "Percent Ag", 2975, 2350, 32, agbreaks)
MapCreator(synchronyMatrixGC, "images/GC_Synchrony1989to2018.png", "GC Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 2975, 2350, 32, synchronybreaks)
MapCreator(developmentMatrixGC, "images/GC_NLCD_DevelopmentIndex_Average_2001and2006.png", "GC NLCD Development Index Average 2001 and 2006", "Index", 2975, 2350, 32)
MapCreator(elevationMatrixGC, "images/GC_Elevation.png", "GC Elevation Map", "Meters", 2975, 2350, 32, elevationbreaks)
MapCreator(slopeMatrixGC, "images/GC_Slope.png", "GC Standard Deviation Elevation Map", "Meters", 2975, 2350, 32, slopebreaks)

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

#Make the Maps
MapCreator(landscanMatrixNOLA, "images/NOLA_Landscan_Population_2003and2004.png", "NOLA Landscan Population Average 2003 and 2004", "Population", 2975, 2350, 32)
MapCreator(temporalAverageNDVIMatrixNOLA, "images/NOLA_NDVI_TemporalAverage_1989to2018.png", "NOLA NDVI Temporal Average 1989 to 2018", "Average NDVI", 2975, 2350, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixNOLA, "images/NOLA_NLCD_Agriculture_Average_2001and2006.png", "NOLA NLCD Agricultural Average 2001 and 2006", "Percent Ag", 2975, 2350, 32, agbreaks)
MapCreator(synchronyMatrixNOLA, "images/NOLA_Synchrony1989to2018.png", "NOLA Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 2975, 2350, 32, synchronybreaks)
MapCreator(developmentMatrixNOLA, "images/NOLA_NLCD_DevelopmentIndex_Average_2001and2006.png", "NOLA NLCD Development Index Average 2001 and 2006", "Index", 2975, 2350, 32)
MapCreator(elevationMatrixNOLA, "images/NOLA_Elevation.png", "NOLA Elevation Map", "Meters", 2975, 2350, 32, elevationbreaks)
MapCreator(slopeMatrixNOLA, "images/NOLA_Slope.png", "NOLA Standard Deviation Elevation Map", "Meters", 2975, 2350, 32, slopebreaks)

########################################
# San Francisco Bay Area
########################################
landscanMatrixSF <- landscanMatrix[91:160, 1261:1380]
temporalAverageNDVIMatrixSF <- temporalAverageNDVIMatrix[91:160, 1261:1380]
agricultureNLCDMatrixSF <-agricultureNLCDMatrix[91:160, 1261:1380]
synchronyMatrixSF <- synchronyMatrix[91:160, 1261:1380]

#Make the Maps
MapCreator(landscanMatrixSF, "images/SF_Landscan_Population_2003and2004.png", "SF Landscan Population Average 2003 and 2004", "Population", 90, 1260, 32)
MapCreator(temporalAverageNDVIMatrixSF, "images/SF_NDVI_TemporalAverage_1989to2018.png", "SF NDVI Temporal Average 1989 to 2018", "Average NDVI", 90, 1260, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixSF, "images/SF_NLCD_Agriculture_Average_2001and2006.png", "SF NLCD Agricultural Average 2001 and 2006", "Percent Ag", 90, 1260, 32, agbreaks)
MapCreator(synchronyMatrixSF, "images/SF_Synchrony1989to2018.png", "SF Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 90, 1260, 32, synchronybreaks)

########################################
# Central Valley
########################################
landscanMatrixCV <- landscanMatrix[151:400, 1001:1700]
temporalAverageNDVIMatrixCV <- temporalAverageNDVIMatrix[151:400, 1001:1700]
agricultureNLCDMatrixCV <-agricultureNLCDMatrix[151:400, 1001:1700]
synchronyMatrixCV <- synchronyMatrix[151:400, 1001:1700]

MapCreator(landscanMatrixCV, "images/CV_Landscan_Population_2003and2004.png", "CV Landscan Population Average 2003 and 2004", "Population", 150, 1000, 32)
MapCreator(temporalAverageNDVIMatrixCV, "images/CV_NDVI_TemporalAverage_1989to2018.png", "CV NDVI Temporal Average 1989 to 2018", "Average NDVI", 150, 1000, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixCV, "images/CV_NLCD_Agriculture_Average_2001and2006.png", "CV NLCD Agricultural Average 2001 and 2006", "Percent Ag", 150, 1000, 32, agbreaks)
MapCreator(synchronyMatrixCV, "images/CV_Synchrony1989to2018.png", "CV Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 150, 1000, 32, synchronybreaks)

########################################
# Salt Lake City
########################################
landscanMatrixSLC <- landscanMatrix[1031:1075, 1146:1180]
temporalAverageNDVIMatrixSLC <- temporalAverageNDVIMatrix[1031:1075, 1146:1180]
agricultureNLCDMatrixSLC <-agricultureNLCDMatrix[1031:1075, 1146:1180]
synchronyMatrixSLC <- synchronyMatrix[1031:1075, 1146:1180]

MapCreator(landscanMatrixSLC, "images/SLC_Landscan_Population_2003and2004.png", "SLC Landscan Population Average 2003 and 2004", "Population", 1030, 1145, 32)
MapCreator(temporalAverageNDVIMatrixSLC, "images/SLC_NDVI_TemporalAverage_1989to2018.png", "SLC NDVI Temporal Average 1989 to 2018", "Average NDVI", 1030, 1145, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixSLC, "images/SLC_NLCD_Agriculture_Average_2001and2006.png", "SLC NLCD Agricultural Average 2001 and 2006", "Percent Ag", 1030, 1145, 32, agbreaks)
MapCreator(synchronyMatrixSLC, "images/SLC_Synchrony1989to2018.png", "SLC Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 1030, 1145, 32, synchronybreaks)

########################################
# St. Louis, MO
########################################
landscanMatrixSTL <- landscanMatrix[2851:2931, 1386:1435]
temporalAverageNDVIMatrixSTL <- temporalAverageNDVIMatrix[2851:2931, 1386:1435]
agricultureNLCDMatrixSTL <-agricultureNLCDMatrix[2851:2931, 1386:1435]
synchronyMatrixSTL <- synchronyMatrix[2851:2931, 1386:1435]

MapCreator(landscanMatrixSTL, "images/STL_Landscan_Population_2003and2004.png", "STL Landscan Population Average 2003 and 2004", "Population", 2850, 1385, 32)
MapCreator(temporalAverageNDVIMatrixSTL, "images/STL_NDVI_TemporalAverage_1989to2018.png", "STL NDVI Temporal Average 1989 to 2018", "Average NDVI", 2850, 1385, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixSTL, "images/STL_NLCD_Agriculture_Average_2001and2006.png", "STL NLCD Agricultural Average 2001 and 2006", "Percent Ag", 2850, 1385, 32, agbreaks)
MapCreator(synchronyMatrixSTL, "images/STL_Synchrony1989to2018.png", "STL Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 2850, 1385, 32, synchronybreaks)

########################################
# Las Vegas
########################################
landscanMatrixLV <- landscanMatrix[676:720, 1591:1650]
temporalAverageNDVIMatrixLV <- temporalAverageNDVIMatrix1990[676:720, 1591:1650]
agricultureNLCDMatrixLV <-agricultureNLCDMatrix[676:720, 1591:1650]
synchronyMatrixLV <- synchronyMatrix[676:720, 1591:1650]

MapCreator(landscanMatrixLV, "images/LV_Landscan_Population_2003and2004.png", "LV Landscan Population Average 2003 and 2004", "Population", 675, 1590, 32)
MapCreator(temporalAverageNDVIMatrixLV, "images/LV_NDVI_TemporalAverage_1990to2018.png", "LV NDVI Temporal Average 1990 to 2018", "Average NDVI", 675, 1590, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixLV, "images/LV_NLCD_Agriculture_Average_2001and2006.png", "LV NLCD Agricultural Average 2001 and 2006", "Percent Ag", 675, 1590, 32, agbreaks)
MapCreator(synchronyMatrixLV, "images/LV_Synchrony1990to2018.png", "LV Synchrony 1990 to 2018, Pearson, r = 5", "Synchrony", 675, 1950, 32, synchronybreaks)

########################################
# Reno
########################################
landscanMatrixReno <- landscanMatrix[361:381, 1141:1180]
temporalAverageNDVIMatrixReno <- temporalAverageNDVIMatrix1990[361:381, 1141:1180]
agricultureNLCDMatrixReno <-agricultureNLCDMatrix[361:381, 1141:1180]
synchronyMatrixReno <- synchronyMatrix[361:381, 1141:1180]

MapCreator(landscanMatrixReno, "images/Reno_Landscan_Population_2003and2004.png", "Reno Landscan Population Average 2003 and 2004", "Population", 360, 1140, 32)
MapCreator(temporalAverageNDVIMatrixReno, "images/Reno_NDVI_TemporalAverage_1990to2018.png", "Reno NDVI Temporal Average 1990 to 2018", "Average NDVI", 360, 1140, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixReno, "images/Reno_NLCD_Agriculture_Average_2001and2006.png", "Reno NLCD Agricultural Average 2001 and 2006", "Percent Ag", 360, 1140, 32, agbreaks)
MapCreator(synchronyMatrixReno, "images/Reno_Synchrony1990to2018.png", "Reno Synchrony 1990 to 2018, Pearson, r = 5", "Synchrony", 360, 1140, 32, synchronybreaks)

########################################
# Page
########################################
landscanMatrixPage <- landscanMatrix[1026:1038, 1578:1585]
temporalAverageNDVIMatrixPage <- temporalAverageNDVIMatrix1990[1026:1038, 1578:1585]
agricultureNLCDMatrixPage <-agricultureNLCDMatrix[1026:1038, 1578:1585]
synchronyMatrixPage <- synchronyMatrix[1028:1035, 1578:1585]

MapCreator(landscanMatrixPage, "images/Page_Landscan_Population_2003and2004.png", "Page Landscan Population Average 2003 and 2004", "Population", 1025, 1577, 32)
MapCreator(temporalAverageNDVIMatrixPage, "images/Page_NDVI_TemporalAverage_1990to2018.png", "Page NDVI Temporal Average 1990 to 2018", "Average NDVI", 1025, 1577, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixPage, "images/Page_NLCD_Agriculture_Average_2001and2006.png", "Page NLCD Agricultural Average 2001 and 2006", "Percent Ag", 1025, 1577, 32, agbreaks)
MapCreator(synchronyMatrixPage, "images/Page_Synchrony1990to2018.png", "Page Synchrony 1990 to 2018, Pearson, r = 5", "Synchrony", 1025, 1577, 32, synchronybreaks)

########################################
# Pheonix
########################################
landscanMatrixPX <- landscanMatrix[891:990, 1911:1990]
temporalAverageNDVIMatrixPX <- temporalAverageNDVIMatrix1990[891:990, 1911:1990]
agricultureNLCDMatrixPX <-agricultureNLCDMatrix[891:990, 1911:1990]
synchronyMatrixPX <- synchronyMatrix[891:990, 1911:1990]

MapCreator(landscanMatrixPX, "images/PX_Landscan_Population_2003and2004.png", "PX Landscan Population Average 2003 and 2004", "Population", 890, 1910, 32)
MapCreator(temporalAverageNDVIMatrixPX, "images/PX_NDVI_TemporalAverage_1990to2018.png", "PX NDVI Temporal Average 1990 to 2018", "Average NDVI", 890, 1910, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixPX, "images/PX_NLCD_Agriculture_Average_2001and2006.png", "PX NLCD Agricultural Average 2001 and 2006", "Percent Ag", 890, 1910, 32, agbreaks)
MapCreator(synchronyMatrixPX, "images/PX_Synchrony1990to2018.png", "PX Synchrony 1990 to 2018, Pearson, r = 5", "Synchrony", 890, 1910, 32, synchronybreaks)

########################################
# New York City
########################################
landscanMatrixNYC <- landscanMatrix[4171:4250, 851:910]
temporalAverageNDVIMatrixNYC <- temporalAverageNDVIMatrix[4171:4250, 851:910]
agricultureNLCDMatrixNYC <-agricultureNLCDMatrix[4171:4250, 851:910]
synchronyMatrixNYC <- synchronyMatrix[4171:4250, 851:910]

MapCreator(landscanMatrixNYC, "images/NYC_Landscan_Population_2003and2004.png", "NYC Landscan Population Average 2003 and 2004", "Population", 4170, 850, 32)
MapCreator(temporalAverageNDVIMatrixNYC, "images/NYC_NDVI_TemporalAverage_1989to2018.png", "NYC NDVI Temporal Average 1989 to 2018", "Average NDVI", 4170, 850, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixNYC, "images/NYC_NLCD_Agriculture_Average_2001and2006.png", "NYC NLCD Agricultural Average 2001 and 2006", "Percent Ag", 4170, 850, 32, agbreaks)
MapCreator(synchronyMatrixNYC, "images/NYC_Synchrony1989to2018.png", "NYC Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 4170, 850, 32, synchronybreaks)

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

MapCreator(landscanMatrixCH, "images/CH_Landscan_Population_2003and2004.png", "CH Landscan Population Average 2003 and 2004", "Population", 3050, 1000, 32)
MapCreator(temporalAverageNDVIMatrixCH, "images/CH_NDVI_TemporalAverage_1989to2018.png", "CH NDVI Temporal Average 1989 to 2018", "Average NDVI", 3050, 1000, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixCH, "images/CH_NLCD_Agriculture_Average_2001and2006.png", "CH NLCD Agricultural Average 2001 and 2006", "Percent Ag", 3050, 1000, 32, agbreaks)
MapCreator(synchronyMatrixCH, "images/CH_Synchrony1989to2018.png", "CH Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 3050, 1000, 32, synchronybreaks)
MapCreator(developmentNLCDMatrixCH, "images/CH_NLCD_DevelopmentIndex_Average_2001and2006.png", "CH NLCD Development Index Average 2001 and 2006", "Index", 2975, 2350, 32, devbreaks)
MapCreator(elevationMatrixCH, "images/CH_Elevation.png", "CH Elevation Map", "Meters", 2975, 2350, 32, elevationbreaks)
MapCreator(slopeMatrixCH, "images/CH_Slope.png", "CH Standard Deviation Elevation Map", "Meters", 2975, 2350, 32, slopebreaks)

########################################
# Charleston
########################################
landscanMatrixCL <- landscanMatrix[3601:3650, 1301:1330]
temporalAverageNDVIMatrixCL <- temporalAverageNDVIMatrix[3601:3650, 1301:1330]
agricultureNLCDMatrixCL <-agricultureNLCDMatrix[3601:3650, 1301:1330]
synchronyMatrixCL <- synchronyMatrix[3601:3650, 1301:1330]

MapCreator(landscanMatrixCL, "images/CL_Landscan_Population_2003and2004.png", "CL Landscan Population Average 2003 and 2004", "Population", 3600, 1300, 32)
MapCreator(temporalAverageNDVIMatrixCL, "images/CL_NDVI_TemporalAverage_1989to2018.png", "CL NDVI Temporal Average 1989 to 2018", "Average NDVI", 3600, 1300, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixCL, "images/CL_NLCD_Agriculture_Average_2001and2006.png", "CL NLCD Agricultural Average 2001 and 2006", "Percent Ag", 3600, 1300, 32, agbreaks)
MapCreator(synchronyMatrixCL, "images/CL_Synchrony1989to2018.png", "CL Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 3600, 1300, 32, synchronybreaks)

########################################
# Minneapolis
########################################
landscanMatrixMN <- landscanMatrix[2551:2610, 701:770]
temporalAverageNDVIMatrixMN <- temporalAverageNDVIMatrix[2551:2610, 701:770]
agricultureNLCDMatrixMN <-agricultureNLCDMatrix[2551:2610, 701:770]
synchronyMatrixMN <- synchronyMatrix[2551:2610, 701:770]

MapCreator(landscanMatrixMN, "images/MN_Landscan_Population_2003and2004.png", "MN Landscan Population Average 2003 and 2004", "Population", 2550, 700, 32)
MapCreator(temporalAverageNDVIMatrixMN, "images/MN_NDVI_TemporalAverage_1989to2018.png", "MN NDVI Temporal Average 1989 to 2018", "Average NDVI", 2550, 700, 32, NDVIbreaks)
MapCreator(agricultureNLCDMatrixMN, "images/MN_NLCD_Agriculture_Average_2001and2006.png", "MN NLCD Agricultural Average 2001 and 2006", "Percent Ag", 2550, 700, 32, agbreaks)
MapCreator(synchronyMatrixMN, "images/MN_Synchrony1989to2018.png", "MN Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 2550, 700, 32, synchronybreaks)

########################################
# United States of America
########################################
MapCreator(landscanMatrix, "images/USA_Landscan_Population_2003and2004.png", "USA Landscan Population Average 2003 and 2004", "Population", 0, 0, 32)
MapCreator(temporalAverageNDVIMatrix, "images/USA_NDVI_TemporalAverage_1989to2018.png", "USA NDVI Temporal Average 1989 to 2018", "Average NDVI", 0, 0, 32)
MapCreator(agricultureNLCDMatrix, "images/USA_NLCD_Agriculture_Average_2001and2006.png", "USA NLCD Agricultural Average 2001 and 2006", "Percent Ag", 0, 0, 32)
MapCreator(synchronyMatrix, "images/USA_Synchrony1989to2018.png", "USA Synchrony 1989 to 2018, Pearson, r = 5", "Synchrony", 0, 0, 32)
MapCreator(developmentNLCDMatrix, "images/USA_NLCD_DevelopmentIndex_Average_2001and2006.png", "USA NLCD Development Index Average 2001 and 2006", "Index", 0, 0, 32)
MapCreator(elevationMatrix, "images/USA_Elevation.png", "USA Elevation Map", "Meters", 0, 0, 32)
MapCreator(slopeMatrix, "images/USA_Slope.png", "USA Standard Deviation Elevation Map", "Meters", 0, 0, 32)
