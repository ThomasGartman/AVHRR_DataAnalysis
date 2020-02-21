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
require("sjmisc")

########################################
# Functions Called
########################################
source("scripts/VectorizeMatrices.R")
source("scripts/ModelScene.R")
source("scripts/SpatialMatrixSignificance.R")
source("scripts/SpatiallyCorrectedModels.R")

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
transformedMatrixPearson <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongUSA1990to2018.csv"), header = FALSE)
transformedMatrixSpearman <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongUSA1990to2018Spearman.csv"), header = FALSE)

drivers <- list(NDVItempAveMatrixLong, LandscanPopulation, NLCDAgriculture, developmentNLCDMatrix, elevationMatrix, slopeMatrix)
########################################
# Linear OLS Models
########################################
CLLinearModel <- ModelScene(transformedMatrixPearson[3601:3650, 1301:1330], NDVItempAveMatrixLong[3601:3650, 1301:1330], LandscanPopulation[3601:3650, 1301:1330], NLCDAgriculture[3601:3650, 1301:1330])
STLLinearModel <- ModelScene(transformedMatrixPearson[2851:2931, 1386:1435], NDVItempAveMatrixLong[2851:2931, 1386:1435], LandscanPopulation[2851:2931, 1386:1435], NLCDAgriculture[2851:2931, 1386:1435])
MNLinearModel <- ModelScene(transformedMatrixPearson[2551:2610, 701:770], NDVItempAveMatrixLong[2551:2610, 701:770], LandscanPopulation[2551:2610, 701:770], NLCDAgriculture[2551:2610, 701:770])
SLCLinearModel <- ModelScene(transformedMatrixPearson[1031:1075, 1146:1180], NDVItempAveMatrixLong[1031:1075, 1146:1180], LandscanPopulation[1031:1075, 1146:1180], NLCDAgriculture[1031:1075, 1146:1180])
LVLinearModel <- ModelScene(transformedMatrixPearson[676:720, 1591:1650], NDVItempAveMatrixLong[676:720, 1591:1650], LandscanPopulation[676:720, 1591:1650], NLCDAgriculture[676:720, 1591:1650])
PageLinearModel <- ModelScene(transformedMatrixPearson[1028:1035, 1578:1585], NDVItempAveMatrixLong[1028:1035, 1578:1585], LandscanPopulation[1028:1035, 1578:1585], NLCDAgriculture[1028:1035, 1578:1585])
PXLinearModel <- ModelScene(transformedMatrixPearson[891:990, 1911:1990], NDVItempAveMatrixLong[891:990, 1911:1990], LandscanPopulation[891:990, 1911:1990], NLCDAgriculture[891:990, 1911:1990])
RenoLinearModel <- ModelScene(transformedMatrixPearson[361:381, 1141:1180], NDVItempAveMatrixLong[361:381, 1141:1180], LandscanPopulation[361:381, 1141:1180], NLCDAgriculture[361:381, 1141:1180])
CHLinearModel <- ModelScene(transformedMatrixPearson[3051:3095, 1001:1045], NDVItempAveMatrixLong[3051:3095, 1001:1045], LandscanPopulation[3051:3095, 1001:1045], NLCDAgriculture[3051:3095, 1001:1045])
NOLALinearModel <- ModelScene(transformedMatrixPearson[2976:3035, 2351:2380], NDVItempAveMatrixLong[2976:3035, 2351:2380], LandscanPopulation[2976:3035, 2351:2380], NLCDAgriculture[2976:3035, 2351:2380])
NYCLinearModel <- ModelScene(transformedMatrixPearson[4171:4250, 851:910], NDVItempAveMatrixLong[4171:4250, 851:910], LandscanPopulation[4171:4250, 851:910], NLCDAgriculture[4171:4250, 851:910])
SFLinearModel <- ModelScene(transformedMatrixPearson[91:160, 1261:1380], NDVItempAveMatrixLong[91:160, 1261:1380], LandscanPopulation[91:160, 1261:1380], NLCDAgriculture[91:160, 1261:1380])

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

CharlestonPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 3601:3650, 1301:1330)
Charleston_PearsonCorrelation <- CharlestonPearson[[1]]
Charleston_PearsonPValue <- CharlestonPearson[[2]]

CharlestonSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 3601:3650, 1301:1330)
Charleston_SpearmanCorrelation <- CharlestonSpearman[[1]]
Charleston_SpearmanPValue <- CharlestonSpearman[[2]]

ChicagoPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 3051:3095, 1001:1045)
Chicago_PearsonCorrelation <- ChicagoPearson[[1]]
Chicago_PearsonPValue <- ChicagoPearson[[2]]

ChicagoSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 3051:3095, 1001:1045)
Chicago_SpearmanCorrelation <- ChicagoSpearman[[1]]
Chicago_SpearmanPValue <- ChicagoSpearman[[2]]

LasVegasPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 676:720, 1591:1610)
LasVegas_PearsonCorrelation <- LasVegasPearson[[1]]
LasVegas_PearsonPValue <- LasVegasPearson[[2]]

LasVegasSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 676:720, 1591:1610)
LasVegas_SpearmanCorrelation <- LasVegasSpearman[[1]]
LasVegas_SpearmanPValue <- LasVegasSpearman[[2]]

MinneapolisPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 2551:2610, 701:770)
Minneapolis_PearsonCorrelation <- MinneapolisPearson[[1]]
Minneapolis_PearsonPValue <- MinneapolisPearson[[2]]

MinneapolisSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 2551:2610, 701:770)
Minneapolis_SpearmanCorrelation <- MinneapolisSpearman[[1]]
Minneapolis_SpearmanPValue <- MinneapolisSpearman[[2]]

NewOrleansPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 2976:3035, 2351:2380)
NewOrleans_PearsonCorrelation <- NewOrleansPearson[[1]]
NewOrleans_PearsonPValue <- NewOrleansPearson[[2]]

NewOrleansSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 2976:3035, 2351:2380)
NewOrleans_SpearmanCorrelation <- NewOrleansSpearman[[1]]
NewOrleans_SpearmanPValue <- NewOrleansSpearman[[2]]

NewYorkPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 4171:4250, 851:910)
NewYork_PearsonCorrelation <- NewYorkPearson[[1]]
NewYork_PearsonPValue <- NewYorkPearson[[2]]

NewYorkSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 4171:4250, 851:910)
NewYork_SpearmanCorrelation <- NewYorkSpearman[[1]]
NewYork_SpearmanPValue <- NewYorkSpearman[[2]]

PagePearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 1028:1035, 1578:1585)
Page_PearsonCorrelation <- PagePearson[[1]]
Page_PearsonPValue <- PagePearson[[2]]

PageSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 1028:1035, 1578:1585)
Page_SpearmanCorrelation <- PageSpearman[[1]]
Page_SpearmanPValue <- PageSpearman[[2]]

PhoenixPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 891:990, 1911:1990)
Phoenix_PearsonCorrelation <- PhoenixPearson[[1]]
Phoenix_PearsonPValue <- PhoenixPearson[[2]]

PhoenixSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 891:990, 1911:1990)
Phoenix_SpearmanCorrelation <- PhoenixSpearman[[1]]
Phoenix_SpearmanPValue <- PhoenixSpearman[[2]]

RenoPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 361:381, 1141:1180)
Reno_PearsonCorrelation <- RenoPearson[[1]]
Reno_PearsonPValue <- RenoPearson[[2]]

RenoSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 361:381, 1141:1180)
Reno_SpearmanCorrelation <- RenoSpearman[[1]]
Reno_SpearmanPValue <- RenoSpearman[[2]]

SaltLakeCityPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 2851:2931, 1386:1435)
SaltLakeCity_PearsonCorrelation <- SaltLakeCityPearson[[1]]
SaltLakeCity_PearsonPValue <- SaltLakeCityPearson[[2]]

SaltLakeCitySpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 2851:2931, 1386:1435)
SaltLakeCity_SpearmanCorrelation <- SaltLakeCitySpearman[[1]]
SaltLakeCity_SpearmanPValue <- SaltLakeCitySpearman[[2]]

SaintLouisPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 1031:1075, 1146:1180)
SaintLouis_PearsonCorrelation <- SaintLouisPearson[[1]]
SaintLouis_PearsonPValue <- SaintLouisPearson[[2]]

SaintLouisSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 1031:1075, 1146:1180)
SaintLouis_SpearmanCorrelation <- SaintLouisSpearman[[1]]
SaintLouis_SpearmanPValue <- SaintLouisSpearman[[2]]

SanFranciscoPearson <- SpatiallyCorrectedModels(transformedMatrixPearson, drivers, xMatrix, yMatrix, 91:160, 1261:1380)
SanFrancisco_PearsonCorrelation <- SanFranciscoPearson[[1]]
SanFrancisco_PearsonPValue <- SanFranciscoPearson[[2]]

SanFranciscoSpearman <- SpatiallyCorrectedModels(transformedMatrixSpearman, drivers, xMatrix, yMatrix, 91:160, 1261:1380)
SanFrancisco_SpearmanCorrelation <- SanFranciscoSpearman[[1]]
SanFrancisco_SpearmanPValue <- SanFranciscoSpearman[[2]]

PearsonDataframe <- rotate_df(data.frame(Categories, Charleston_PearsonCorrelation, Charleston_PearsonPValue, 
                                         Chicago_PearsonCorrelation, Chicago_PearsonPValue, LasVegas_PearsonCorrelation, LasVegas_PearsonPValue, 
                                         Minneapolis_PearsonCorrelation, Minneapolis_PearsonPValue, NewOrleans_PearsonCorrelation, NewOrleans_PearsonPValue, 
                                         NewYork_PearsonCorrelation, NewYork_PearsonPValue, Page_PearsonCorrelation, Page_PearsonPValue, 
                                         Phoenix_PearsonCorrelation, Phoenix_PearsonPValue, Reno_PearsonCorrelation, Reno_PearsonPValue, 
                                         SaltLakeCity_PearsonCorrelation, SaltLakeCity_PearsonPValue, SanFrancisco_PearsonCorrelation, SanFrancisco_PearsonPValue,
                                         SaintLouis_PearsonCorrelation, SaintLouis_PearsonPValue))

SpearmanDataframe <- rotate_df(data.frame(Categories, Charleston_SpearmanCorrelation, Charleston_SpearmanPValue, 
                                         Chicago_SpearmanCorrelation, Chicago_SpearmanPValue, LasVegas_SpearmanCorrelation, LasVegas_SpearmanPValue, 
                                         Minneapolis_SpearmanCorrelation, Minneapolis_SpearmanPValue, NewOrleans_SpearmanCorrelation, NewOrleans_SpearmanPValue, 
                                         NewYork_SpearmanCorrelation, NewYork_SpearmanPValue, Page_SpearmanCorrelation, Page_SpearmanPValue, 
                                         Phoenix_SpearmanCorrelation, Phoenix_SpearmanPValue, Reno_SpearmanCorrelation, Reno_SpearmanPValue, 
                                         SaltLakeCity_SpearmanCorrelation, SaltLakeCity_SpearmanPValue, SanFrancisco_SpearmanCorrelation, SanFrancisco_SpearmanPValue,
                                         SaintLouis_SpearmanCorrelation, SaintLouis_SpearmanPValue))

write.csv(PearsonDataframe, "data/csvFiles/AVHRR_PearsonCorrelationData.csv", row.names=TRUE)
write.csv(SpearmanDataframe, "data/csvFiles/AVHRR_SpearmanCorrelationData.csv", row.names=TRUE)

