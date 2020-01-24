#' This script carries the statistics required for the AVHRR project
#'
#' Namely this function will need to accomplish or manage:
#'
#'	1. Read in appropriate data files into the correct matrix shape.
#'	2. Vectorize all matrices.
#'	3. Internally check to ensure all vectors have consistant NAs, then remove them (keep track of what was removed)
#'	4. Begin constructing models
require("stargazer")
require("fmsb")
########################################
# Functions Called
########################################
source("scripts/VectorizeMatrices.R")
source("scripts/ModelScene.R")
source("scripts/SpatialMatrixSignficance.R")

########################################
#Read in Data
########################################
#Coordinates
xMatrix <- t(as.matrix(read.csv("data/csvFiles/AVHRR_X_CoordinateMatrix.csv"), header = FALSE))
yMatrix <- t(as.matrix(read.csv("data/csvFiles/AVHRR_Y_CoordinateMatrix.csv"), header = FALSE))

#Predictor 1 - Time Averaged NDVI
NDVItempAveMatrixLong <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv"), header = FALSE)

#Predictor 2 - Population
LandscanPopulation <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_Population_Average_2003to2004.csv"))

#Predictor 3 - Agriculture
NLCDAgriculture <- as.matrix(read.csv("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.csv"))

#Predictor 4 - Development
developmentNLCDMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.csv"), header = FALSE)

#Predictor 5 - Elevation
elevationMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.csv"), header = FALSE)

#Predictor 6 - Change in Elevation
slopeMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.csv"), header = FALSE)

#Our transformed synchrony variable as the observed variable
transformedMatrixLong <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongUSA1990to2018.csv"), header = FALSE)

########################################
# Linear OLS Models
########################################
CLLinearModel <- ModelScene(transformedMatrixLong[3601:3650, 1301:1330], NDVItempAveMatrixLong[3601:3650, 1301:1330], LandscanPopulation[3601:3650, 1301:1330], NLCDAgriculture[3601:3650, 1301:1330])
STLLinearModel <- ModelScene(transformedMatrixLong[2851:2931, 1386:1435], NDVItempAveMatrixLong[2851:2931, 1386:1435], LandscanPopulation[2851:2931, 1386:1435], NLCDAgriculture[2851:2931, 1386:1435])
MNLinearModel <- ModelScene(transformedMatrixLong[2551:2610, 701:770], NDVItempAveMatrixLong[2551:2610, 701:770], LandscanPopulation[2551:2610, 701:770], NLCDAgriculture[2551:2610, 701:770])
SLCLinearModel <- ModelScene(transformedMatrixLong[1031:1075, 1146:1180], NDVItempAveMatrixLong[1031:1075, 1146:1180], LandscanPopulation[1031:1075, 1146:1180], NLCDAgriculture[1031:1075, 1146:1180])
LVLinearModel <- ModelScene(transformedMatrixLong[676:720, 1591:1650], NDVItempAveMatrixLong[676:720, 1591:1650], LandscanPopulation[676:720, 1591:1650], NLCDAgriculture[676:720, 1591:1650])
PageLinearModel <- ModelScene(transformedMatrixLong[1028:1035, 1578:1585], NDVItempAveMatrixLong[1028:1035, 1578:1585], LandscanPopulation[1028:1035, 1578:1585], NLCDAgriculture[1028:1035, 1578:1585])
PXLinearModel <- ModelScene(transformedMatrixLong[891:990, 1911:1990], NDVItempAveMatrixLong[891:990, 1911:1990], LandscanPopulation[891:990, 1911:1990], NLCDAgriculture[891:990, 1911:1990])
RenoLinearModel <- ModelScene(transformedMatrixLong[361:381, 1141:1180], NDVItempAveMatrixLong[361:381, 1141:1180], LandscanPopulation[361:381, 1141:1180], NLCDAgriculture[361:381, 1141:1180])
CHLinearModel <- ModelScene(transformedMatrixLong[3051:3095, 1001:1045], NDVItempAveMatrixLong[3051:3095, 1001:1045], LandscanPopulation[3051:3095, 1001:1045], NLCDAgriculture[3051:3095, 1001:1045])
NOLALinearModel <- ModelScene(transformedMatrixLong[2976:3035, 2351:2380], NDVItempAveMatrixLong[2976:3035, 2351:2380], LandscanPopulation[2976:3035, 2351:2380], NLCDAgriculture[2976:3035, 2351:2380])
NYCLinearModel <- ModelScene(transformedMatrixLong[4171:4250, 851:910], NDVItempAveMatrixLong[4171:4250, 851:910], LandscanPopulation[4171:4250, 851:910], NLCDAgriculture[4171:4250, 851:910])
SFLinearModel <- ModelScene(transformedMatrixLong[91:160, 1261:1380], NDVItempAveMatrixLong[91:160, 1261:1380], LandscanPopulation[91:160, 1261:1380], NLCDAgriculture[91:160, 1261:1380])

VIFInterior <- as.vector(c(VIF(CLLinearModel), VIF(STLLinearModel), VIF(MNLinearModel), VIF(SLCLinearModel)))
VIFDesert <- as.vector(c(VIF(LVLinearModel), VIF(PageLinearModel), VIF(PXLinearModel), VIF(RenoLinearModel)))
VIFCoastal <- as.vector(c(VIF(CHLinearModel), VIF(NOLALinearModel), VIF(NYCLinearModel), VIF(SFLinearModel)))

stargazer(CLLinearModel, STLLinearModel, MNLinearModel, SLCLinearModel, 
          title = "Linear Models for Interior Cities", align = TRUE,
          column.sep.width = "-5pt", omit.stat = "f",
          column.labels = c("Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"),
          covariate.labels=c("NDVI", "Population", "Agriculture"),
          dep.var.labels = "Logit Transformed Synchrony")
stargazer(VIFInterior, title = "VIF for Interior Cities",  summary = FALSE)
stargazer(LVLinearModel, PageLinearModel, PXLinearModel, RenoLinearModel, 
          title = "Linear Models for Desert Cities", align = TRUE,
          column.sep.width = "-5pt", omit.stat = "f",
          column.labels = c("Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"),
          covariate.labels=c("NDVI", "Population", "Agriculture"),
          dep.var.labels = "Logit Transformed Synchrony")
stargazer(VIFDesert, title = "VIF for Desert Cities", summary = FALSE)
stargazer(CHLinearModel, NOLALinearModel, NYCLinearModel, SFLinearModel,
          title = "Linear Models for Coastal Cities", align = TRUE,
          column.sep.width = "-5pt", omit.stat = "f",
          column.labels = c("Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"),
          covariate.labels=c("NDVI", "Population", "Agriculture"),
          dep.var.labels = "Logit Transformed Synchrony")
stargazer(VIFInterior, title = "VIF for Coastal Cities", summary = FALSE)

##########################################
# Spatially Corrected Models 
##########################################
Categories <- c("Max Temporal Average NDVI", "Landscan Population", "NLCD Percent Agriculture", "NLCD Development Index", "Elevation", "Slope")

CLCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[3601:3650, 1301:1330], NDVItempAveMatrixLong[3601:3650, 1301:1330], xMatrix[3601:3650, 1301:1330], yMatrix[3601:3650, 1301:1330])
CLCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[3601:3650, 1301:1330], LandscanPopulation[3601:3650, 1301:1330], xMatrix[3601:3650, 1301:1330], yMatrix[3601:3650, 1301:1330])
CLCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[3601:3650, 1301:1330], NLCDAgriculture[3601:3650, 1301:1330], xMatrix[3601:3650, 1301:1330], yMatrix[3601:3650, 1301:1330])
CLCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[3601:3650, 1301:1330], developmentNLCDMatrix[3601:3650, 1301:1330], xMatrix[3601:3650, 1301:1330], yMatrix[3601:3650, 1301:1330]) 
CLCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[3601:3650, 1301:1330], elevationMatrix[3601:3650, 1301:1330], xMatrix[3601:3650, 1301:1330], yMatrix[3601:3650, 1301:1330])
CLCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[3601:3650, 1301:1330], slopeMatrix[3601:3650, 1301:1330], xMatrix[3601:3650, 1301:1330], yMatrix[3601:3650, 1301:1330])
Charleston_Correlation <- c(CLCorrNDVI[[1]], CLCorrPop[[1]], CLCorrAg[[1]], CLCorrDe[[1]], CLCorrEle[[1]], CLCorrSp[[1]])
Charleston_PValue <- c(CLCorrNDVI[[2]], CLCorrPop[[2]], CLCorrAg[[2]], CLCorrDe[[2]], CLCorrEle[[2]], CLCorrSp[[2]])

STLCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[2851:2931, 1386:1435], NDVItempAveMatrixLong[2851:2931, 1386:1435], xMatrix[2851:2931, 1386:1435], yMatrix[2851:2931, 1386:1435])
STLCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[2851:2931, 1386:1435], LandscanPopulation[2851:2931, 1386:1435], xMatrix[2851:2931, 1386:1435], yMatrix[2851:2931, 1386:1435])
STLCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[2851:2931, 1386:1435], NLCDAgriculture[2851:2931, 1386:1435], xMatrix[2851:2931, 1386:1435], yMatrix[2851:2931, 1386:1435])
STLCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[2851:2931, 1386:1435], developmentNLCDMatrix[2851:2931, 1386:1435], xMatrix[2851:2931, 1386:1435], yMatrix[2851:2931, 1386:1435]) 
STLCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[2851:2931, 1386:1435], elevationMatrix[2851:2931, 1386:1435], xMatrix[2851:2931, 1386:1435], yMatrix[2851:2931, 1386:1435])
STLCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[2851:2931, 1386:1435], slopeMatrix[2851:2931, 1386:1435], xMatrix[2851:2931, 1386:1435], yMatrix[2851:2931, 1386:1435])
StLouis_Correlation <- c(STLCorrNDVI[[1]], STLCorrPop[[1]], STLCorrAg[[1]], STLCorrDe[[1]], STLCorrEle[[1]], STLCorrSp[[1]])
StLouis_PValue <- c(STLCorrNDVI[[2]], STLCorrPop[[2]], STLCorrAg[[2]], STLCorrDe[[2]], STLCorrEle[[2]], STLCorrSp[[2]])

MNCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[2551:2610, 701:770], NDVItempAveMatrixLong[2551:2610, 701:770], xMatrix[2551:2610, 701:770], yMatrix[2551:2610, 701:770])
MNCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[2551:2610, 701:770], LandscanPopulation[2551:2610, 701:770], xMatrix[2551:2610, 701:770], yMatrix[2551:2610, 701:770])
MNCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[2551:2610, 701:770], NLCDAgriculture[2551:2610, 701:770], xMatrix[2551:2610, 701:770], yMatrix[2551:2610, 701:770])
MNCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[2551:2610, 701:770], developmentNLCDMatrix[2551:2610, 701:770], xMatrix[2551:2610, 701:770], yMatrix[2551:2610, 701:770]) 
MNCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[2551:2610, 701:770], elevationMatrix[2551:2610, 701:770], xMatrix[2551:2610, 701:770], yMatrix[2551:2610, 701:770])
MNCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[2551:2610, 701:770], slopeMatrix[2551:2610, 701:770], xMatrix[2551:2610, 701:770], yMatrix[2551:2610, 701:770])
Minneapolis_Correlation <- c(MNCorrNDVI[[1]], MNCorrPop[[1]], MNCorrAg[[1]], MNCorrDe[[1]], MNCorrEle[[1]], MNCorrSp[[1]])
Minneapolis_PValue <- c(MNCorrNDVI[[2]], MNCorrPop[[2]], MNCorrAg[[2]], MNCorrDe[[2]], MNCorrEle[[2]], MNCorrSp[[2]])

SLCCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[1031:1075, 1146:1180], NDVItempAveMatrixLong[1031:1075, 1146:1180], xMatrix[1031:1075, 1146:1180], yMatrix[1031:1075, 1146:1180])
SLCCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[1031:1075, 1146:1180], LandscanPopulation[1031:1075, 1146:1180], xMatrix[1031:1075, 1146:1180], yMatrix[1031:1075, 1146:1180])
SLCCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[1031:1075, 1146:1180], NLCDAgriculture[1031:1075, 1146:1180], xMatrix[1031:1075, 1146:1180], yMatrix[1031:1075, 1146:1180])
SLCCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[1031:1075, 1146:1180], developmentNLCDMatrix[1031:1075, 1146:1180], xMatrix[1031:1075, 1146:1180], yMatrix[1031:1075, 1146:1180]) 
SLCCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[1031:1075, 1146:1180], elevationMatrix[1031:1075, 1146:1180], xMatrix[1031:1075, 1146:1180], yMatrix[1031:1075, 1146:1180])
SLCCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[1031:1075, 1146:1180], slopeMatrix[1031:1075, 1146:1180], xMatrix[1031:1075, 1146:1180], yMatrix[1031:1075, 1146:1180])
SaltLakeCity_Correlation <- c(SLCCorrNDVI[[1]], SLCCorrPop[[1]], SLCCorrAg[[1]], SLCCorrDe[[1]], SLCCorrEle[[1]], SLCCorrSp[[1]])
SaltLakeCity_PValue <- c(SLCCorrNDVI[[2]], SLCCorrPop[[2]], SLCCorrAg[[2]], SLCCorrDe[[2]], SLCCorrEle[[2]], SLCCorrSp[[2]])

LVCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[676:720, 1591:1610], NDVItempAveMatrixLong[676:720, 1591:1610], xMatrix[676:720, 1591:1610], yMatrix[676:720, 1591:1610])
LVCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[676:720, 1591:1610], LandscanPopulation[676:720, 1591:1610], xMatrix[676:720, 1591:1610], yMatrix[676:720, 1591:1610])
LVCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[676:720, 1591:1610], NLCDAgriculture[676:720, 1591:1610], xMatrix[676:720, 1591:1610], yMatrix[676:720, 1591:1610])
LVCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[676:720, 1591:1610], developmentNLCDMatrix[676:720, 1591:1610], xMatrix[676:720, 1591:1610], yMatrix[676:720, 1591:1610]) 
LVCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[676:720, 1591:1610], elevationMatrix[676:720, 1591:1610], xMatrix[676:720, 1591:1610], yMatrix[676:720, 1591:1610])
LVCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[676:720, 1591:1610], slopeMatrix[676:720, 1591:1610], xMatrix[676:720, 1591:1610], yMatrix[676:720, 1591:1610])
LasVegas_Correlation <- c(LVCorrNDVI[[1]], LVCorrPop[[1]], LVCorrAg[[1]], LVCorrDe[[1]], LVCorrEle[[1]], LVCorrSp[[1]])
LasVegas_PValue <- c(LVCorrNDVI[[2]], LVCorrPop[[2]], LVCorrAg[[2]], LVCorrDe[[2]], LVCorrEle[[2]], LVCorrSp[[2]])

PageCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[1028:1035, 1578:1585], NDVItempAveMatrixLong[1028:1035, 1578:1585], xMatrix[1028:1035, 1578:1585], yMatrix[1028:1035, 1578:1585])
PageCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[1028:1035, 1578:1585], LandscanPopulation[1028:1035, 1578:1585], xMatrix[1028:1035, 1578:1585], yMatrix[1028:1035, 1578:1585])
PageCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[1028:1035, 1578:1585], NLCDAgriculture[1028:1035, 1578:1585], xMatrix[1028:1035, 1578:1585], yMatrix[1028:1035, 1578:1585])
PageCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[1028:1035, 1578:1585], developmentNLCDMatrix[1028:1035, 1578:1585], xMatrix[1028:1035, 1578:1585], yMatrix[1028:1035, 1578:1585]) 
PageCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[1028:1035, 1578:1585], elevationMatrix[1028:1035, 1578:1585], xMatrix[1028:1035, 1578:1585], yMatrix[1028:1035, 1578:1585])
PageCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[1028:1035, 1578:1585], slopeMatrix[1028:1035, 1578:1585], xMatrix[1028:1035, 1578:1585], yMatrix[1028:1035, 1578:1585])
Page_Correlation <- c(PageCorrNDVI[[1]], PageCorrPop[[1]], PageCorrAg[[1]], PageCorrDe[[1]], PageCorrEle[[1]], PageCorrSp[[1]])
Page_PValue <- c(PageCorrNDVI[[2]], PageCorrPop[[2]], PageCorrAg[[2]], PageCorrDe[[2]], PageCorrEle[[2]], PageCorrSp[[2]])

PXCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[891:990, 1911:1990], NDVItempAveMatrixLong[891:990, 1911:1990], xMatrix[891:990, 1911:1990], yMatrix[891:990, 1911:1990])
PXCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[891:990, 1911:1990], LandscanPopulation[891:990, 1911:1990], xMatrix[891:990, 1911:1990], yMatrix[891:990, 1911:1990])
PXCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[891:990, 1911:1990], NLCDAgriculture[891:990, 1911:1990], xMatrix[891:990, 1911:1990], yMatrix[891:990, 1911:1990])
PXCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[891:990, 1911:1990], developmentNLCDMatrix[891:990, 1911:1990], xMatrix[891:990, 1911:1990], yMatrix[891:990, 1911:1990]) 
PXCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[891:990, 1911:1990], elevationMatrix[891:990, 1911:1990], xMatrix[891:990, 1911:1990], yMatrix[891:990, 1911:1990])
PXCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[891:990, 1911:1990], slopeMatrix[891:990, 1911:1990], xMatrix[891:990, 1911:1990], yMatrix[891:990, 1911:1990])
Phoenix_Correlation <- c(PXCorrNDVI[[1]], PXCorrPop[[1]], PXCorrAg[[1]], PXCorrDe[[1]], PXCorrEle[[1]], PXCorrSp[[1]])
Phoenix_PValue <- c(PXCorrNDVI[[2]], PXCorrPop[[2]], PXCorrAg[[2]], PXCorrDe[[2]], PXCorrEle[[2]], PXCorrSp[[2]])

RenoCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[361:381, 1141:1180], NDVItempAveMatrixLong[361:381, 1141:1180], xMatrix[361:381, 1141:1180], yMatrix[361:381, 1141:1180])
RenoCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[361:381, 1141:1180], LandscanPopulation[361:381, 1141:1180], xMatrix[361:381, 1141:1180], yMatrix[361:381, 1141:1180])
RenoCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[361:381, 1141:1180], NLCDAgriculture[361:381, 1141:1180], xMatrix[361:381, 1141:1180], yMatrix[361:381, 1141:1180])
RenoCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[361:381, 1141:1180], developmentNLCDMatrix[361:381, 1141:1180], xMatrix[361:381, 1141:1180], yMatrix[361:381, 1141:1180]) 
RenoCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[361:381, 1141:1180], elevationMatrix[361:381, 1141:1180], xMatrix[361:381, 1141:1180], yMatrix[361:381, 1141:1180])
RenoCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[361:381, 1141:1180], slopeMatrix[361:381, 1141:1180], xMatrix[361:381, 1141:1180], yMatrix[361:381, 1141:1180])
Reno_Correlation <- c(RenoCorrNDVI[[1]], RenoCorrPop[[1]], RenoCorrAg[[1]], RenoCorrDe[[1]], RenoCorrEle[[1]], RenoCorrSp[[1]])
Reno_PValue <- c(RenoCorrNDVI[[2]], RenoCorrPop[[2]], RenoCorrAg[[2]], RenoCorrDe[[2]], RenoCorrEle[[2]], RenoCorrSp[[2]])

CHCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[3051:3095, 1001:1045], NDVItempAveMatrixLong[3051:3095, 1001:1045], xMatrix[3051:3095, 1001:1045], yMatrix[3051:3095, 1001:1045])
CHCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[3051:3095, 1001:1045], LandscanPopulation[3051:3095, 1001:1045], xMatrix[3051:3095, 1001:1045], yMatrix[3051:3095, 1001:1045])
CHCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[3051:3095, 1001:1045], NLCDAgriculture[3051:3095, 1001:1045], xMatrix[3051:3095, 1001:1045], yMatrix[3051:3095, 1001:1045])
CHCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[3051:3095, 1001:1045], developmentNLCDMatrix[3051:3095, 1001:1045], xMatrix[3051:3095, 1001:1045], yMatrix[3051:3095, 1001:1045]) 
CHCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[3051:3095, 1001:1045], elevationMatrix[3051:3095, 1001:1045], xMatrix[3051:3095, 1001:1045], yMatrix[3051:3095, 1001:1045])
CHCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[3051:3095, 1001:1045], slopeMatrix[3051:3095, 1001:1045], xMatrix[3051:3095, 1001:1045], yMatrix[3051:3095, 1001:1045])
Chicago_Correlation <- c(CHCorrNDVI[[1]], CHCorrPop[[1]], CHCorrAg[[1]], CHCorrDe[[1]], CHCorrEle[[1]], CHCorrSp[[1]])
Chicago_PValue <- c(CHCorrNDVI[[2]], CHCorrPop[[2]], CHCorrAg[[2]], CHCorrDe[[2]], CHCorrEle[[2]], CHCorrSp[[2]])

NOLACorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[2976:3035, 2351:2380], NDVItempAveMatrixLong[2976:3035, 2351:2380], xMatrix[2976:3035, 2351:2380], yMatrix[2976:3035, 2351:2380])
NOLACorrPop <- SpatialMatrixSignificance(transformedMatrixLong[2976:3035, 2351:2380], LandscanPopulation[2976:3035, 2351:2380], xMatrix[2976:3035, 2351:2380], yMatrix[2976:3035, 2351:2380])
NOLACorrAg <- SpatialMatrixSignificance(transformedMatrixLong[2976:3035, 2351:2380], NLCDAgriculture[2976:3035, 2351:2380], xMatrix[2976:3035, 2351:2380], yMatrix[2976:3035, 2351:2380])
NOLACorrDe <- SpatialMatrixSignificance(transformedMatrixLong[2976:3035, 2351:2380], developmentNLCDMatrix[2976:3035, 2351:2380], xMatrix[2976:3035, 2351:2380], yMatrix[2976:3035, 2351:2380]) 
NOLACorrEle <-SpatialMatrixSignificance(transformedMatrixLong[2976:3035, 2351:2380], elevationMatrix[2976:3035, 2351:2380], xMatrix[2976:3035, 2351:2380], yMatrix[2976:3035, 2351:2380])
NOLACorrSp <- SpatialMatrixSignificance(transformedMatrixLong[2976:3035, 2351:2380], slopeMatrix[2976:3035, 2351:2380], xMatrix[2976:3035, 2351:2380], yMatrix[2976:3035, 2351:2380])
NewOrleans_Correlation <- c(NOLACorrNDVI[[1]], NOLACorrPop[[1]], NOLACorrAg[[1]], NOLACorrDe[[1]], NOLACorrEle[[1]], NOLACorrSp[[1]])
NewOrleans_PValue <- c(NOLACorrNDVI[[2]], NOLACorrPop[[2]], NOLACorrAg[[2]], NOLACorrDe[[2]], NOLACorrEle[[2]], NOLACorrSp[[2]])

NYCCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[4171:4250, 851:910], NDVItempAveMatrixLong[4171:4250, 851:910], xMatrix[4171:4250, 851:910], yMatrix[4171:4250, 851:910])
NYCCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[4171:4250, 851:910], LandscanPopulation[4171:4250, 851:910], xMatrix[4171:4250, 851:910], yMatrix[4171:4250, 851:910])
NYCCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[4171:4250, 851:910], NLCDAgriculture[4171:4250, 851:910], xMatrix[4171:4250, 851:910], yMatrix[4171:4250, 851:910])
NYCCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[4171:4250, 851:910], developmentNLCDMatrix[4171:4250, 851:910], xMatrix[4171:4250, 851:910], yMatrix[4171:4250, 851:910]) 
NYCCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[4171:4250, 851:910], elevationMatrix[4171:4250, 851:910], xMatrix[4171:4250, 851:910], yMatrix[4171:4250, 851:910])
NYCCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[4171:4250, 851:910], slopeMatrix[4171:4250, 851:910], xMatrix[4171:4250, 851:910], yMatrix[4171:4250, 851:910])
NYCCorrVec <- c("New York City", NYCCorrNDVI[[1]], NYCCorrPop[[1]], NYCCorrAg[[1]], NYCCorrDe[[1]], NYCCorrEle[[1]], NYCCorrSp[[1]])
NewYorSTLity_Correlation <- c(NYCCorrNDVI[[1]], NYCCorrPop[[1]], NYCCorrAg[[1]], NYCCorrDe[[1]], NYCCorrEle[[1]], NYCCorrSp[[1]])
NewYorSTLity_PValue <- c(NYCCorrNDVI[[2]], NYCCorrPop[[2]], NYCCorrAg[[2]], NYCCorrDe[[2]], NYCCorrEle[[2]], NYCCorrSp[[2]])

SFCorrNDVI <- SpatialMatrixSignificance(transformedMatrixLong[91:160, 1261:1380], NDVItempAveMatrixLong[91:160, 1261:1380], xMatrix[91:160, 1261:1380], yMatrix[91:160, 1261:1380])
SFCorrPop <- SpatialMatrixSignificance(transformedMatrixLong[91:160, 1261:1380], LandscanPopulation[91:160, 1261:1380], xMatrix[91:160, 1261:1380], yMatrix[91:160, 1261:1380])
SFCorrAg <- SpatialMatrixSignificance(transformedMatrixLong[91:160, 1261:1380], NLCDAgriculture[91:160, 1261:1380], xMatrix[91:160, 1261:1380], yMatrix[91:160, 1261:1380])
SFCorrDe <- SpatialMatrixSignificance(transformedMatrixLong[91:160, 1261:1380], developmentNLCDMatrix[91:160, 1261:1380], xMatrix[91:160, 1261:1380], yMatrix[91:160, 1261:1380]) 
SFCorrEle <-SpatialMatrixSignificance(transformedMatrixLong[91:160, 1261:1380], elevationMatrix[91:160, 1261:1380], xMatrix[91:160, 1261:1380], yMatrix[91:160, 1261:1380])
SFCorrSp <- SpatialMatrixSignificance(transformedMatrixLong[91:160, 1261:1380], slopeMatrix[91:160, 1261:1380], xMatrix[91:160, 1261:1380], yMatrix[91:160, 1261:1380])
SanFrancisco_Correlation <- c(SFCorrNDVI[[1]], SFCorrPop[[1]], SFCorrAg[[1]], SFCorrDe[[1]], SFCorrEle[[1]], SFCorrSp[[1]])
SanFrancisco_PValue <- c(SFCorrNDVI[[2]], SFCorrPop[[2]], SFCorrAg[[2]], SFCorrDe[[2]], SFCorrEle[[2]], SFCorrSp[[2]])

corrDataframe <- data.frame(Categories, Charleston_Correlation, Charleston_PValue, StLouis_Correlation, StLouis_PValue, Minneapolis_Correlation, Minneapolis_PValue,
                              SaltLakeCity_Correlation, SaltLakeCity_PValue, LasVegas_Correlation, LasVegas_PValue, Page_Correlation, Page_PValue, Phoenix_Correlation, Phoenix_PValue, 
                            Reno_Correlation, Reno_PValue, Chicago_Correlation, Chicago_PValue, NewOrleans_Correlation, NewOrleans_PValue, NewYorSTLity_Correlation, NewYorSTLity_PValue,
                            SanFrancisco_Correlation, SanFrancisco_PValue)
write.csv(corrDataframe, "data/csvFiles/AVHRR_CityCorrelationData.csv", row.names=FALSE)
#print(paste("Charleston: ", CLCorrNDVI, ", ", CLCorrPop, ", ", CLCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Kansas City: ", STLCorrNDVI, ", ", STLCorrPop, ",", STLCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Minneapolis: ", MNCorrNDVI, ", ", MNCorrPop, ",", MNCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Salt Lake City: ", SLCCorrNDVI, ", ", SLCCorrPop, ",", SLCCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Las Vegas: ", LVCorrNDVI, ", ", LVCorrPop, ",", LVCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Page: ", PageCorrNDVI, ", ", PageCorrPop, ",", PageCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Phoenix: ", PXCorrNDVI, ", ", PXCorrPop, ",", PXCorrAg, ", ", CLCorrDe, ", ", CLCorrEle, ", ", CLCorrSp, sep = ""))
#print(paste("Reno: ", RenoCorrNDVI, ", ", RenoCorrPop, ",", RenoCorrAg, sep = ""))
#print(paste("Chicago: ", CHCorrNDVI, ", ", CHCorrPop, ",", CHCorrAg, sep = ""))
#print(paste("New Orleans: ", NOLACorrNDVI, ", ", NOLACorrPop, ",", NOLACorrAg, sep = ""))
#print(paste("New York: ", NYCCorrNDVI, ", ", NYCCorrPop, ",", NYCCorrAg, sep = ""))
#print(paste("San Francisco: ", SFCorrNDVI, ", ", SFCorrPop, ",", SFCorrAg, sep = ""))
