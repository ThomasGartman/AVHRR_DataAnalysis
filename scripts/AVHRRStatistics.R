#' This script carries the statistics required for the AVHRR project
#'
#' Namely this function will need to accomplish or manage:
#'
#'	1. Read in appropriate data files into the correct matrix shape.
#'	2. Vectorize all matrices.
#'	3. Internally check to ensure all vectors have consistant NAs, then remove them (keep track of what was removed)
#'	4. Begin constructing models

require("fmsb")
require("sjmisc")

########################################
# Functions Called
########################################
source("scripts/VectorizeMatrices.R")
source("scripts/ModelScene.R")
source("scripts/SpatialMatrixSignificance.R")
source("scripts/SpatiallyCorrectedModels.R")

AVHRRStatistics <- function(){
  
  ########################################
  # Read in Data
  ########################################
  
  #Coordinates
  xMatrix <- t(readRDS("data/csvFiles/AVHRR_X_CoordinateMatrix.RDS"))
  yMatrix <- t(readRDS("data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS"))
  
  #Predictor 1 - Time Averaged NDVI
  NDVItempAveMatrixLong <- readRDS("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018.RDS")
  NDVItempAveMatrixNo2010 <- readRDS("data/csvFiles/AVHRR_NDVItempAveMatrix1990to2018No2010.RDS")
  
  #Predictor 2 - Population
  #LandscanPopulation <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_2004.csv")) 
  # possible bug in reading csv: sometimes forget adding header =F in read.csv, dim = 4587 by 2888 (when header =T), 
  #     but 4587 by 2889 (when header =F)
  
  # why only 2004? should not it be avg of (2003,2004)?
  #--------------------------------------------------------------------------------------------------------------------
  # What Thomas replied to me:
  # He wanted to pick the mid-year of 1990 to 2018 range - so choosing 2004 as Jude told him.
  # But he had also plan to check whether choosing 2004 and avg(2003, 2004) would give different results?
  #--------------------------------------------------------------------------------------------------------------------
  
  LandscanPopulationArray <- readRDS("data/csvFiles/landscanArray.RDS")
  LandscanPopulation <- LandscanPopulationArray[,,5] # for 2004 only
 
  #Predictor 3 - Agriculture
  NLCDAgriculture <- readRDS("data/csvFiles/AVHRR_NLCD_Agriculture_Average_2001and2006.RDS")
  
  #Predictor 4 - Development
  developmentNLCDMatrix <- readRDS("data/csvFiles/AVHRR_NLCD_Development_Average_2001and2006.RDS")
  
  #Predictor 5 - Elevation
  elevationMatrix <- readRDS("data/csvFiles/AVHRR_USGS_MeanElevationPrepared.RDS")
  
  #Predictor 6 - Change in Elevation
  slopeMatrix <- readRDS("data/csvFiles/AVHRR_USGS_StandardDeviationPrepared.RDS")
  
  #Our transformed synchrony variable as the observed variable
  transformedMatrixPearson <- readRDS("data/csvFiles/AVHRR_TransformedLongUSA1990to2018.RDS")
  transformedMatrixSpearman <- readRDS("data/csvFiles/AVHRR_TransformedLongUSA1990to2018Spearman.RDS")
  transformedMatrixPearsonNo2010 <- readRDS("data/csvFiles/AVHRR_TransformedLongUSANo2010.RDS")
  transformedMatrixSpearmanNo2010 <- readRDS("data/csvFiles/AVHRR_TransformedLongUSANo2010Spearman.RDS")
  
  drivers <- list(NDVItempAveMatrixLong, LandscanPopulation, NLCDAgriculture, developmentNLCDMatrix, elevationMatrix, slopeMatrix)
  driversNo2010 <- list(NDVItempAveMatrixNo2010, LandscanPopulation, NLCDAgriculture, developmentNLCDMatrix, elevationMatrix, slopeMatrix)
  
  ########################################
  # Linear OLS Models
  ########################################
  
  #--------------- first choose some co-ord range for target zones ------------------
  
  # Interior Cities
  xy_CL <- list(x=c(3601:3650),y=c(1301:1330)) # around Charleston, WV
  xy_STL <- list(x=c(2851:2931),y=c(1386:1435)) # around St. Louis, MO
  xy_MN <- list(x=c(2551:2610),y=c(701:770)) # around Minneapolis, MN
  xy_SLC <- list(x=c(1031:1075),y=c(1146:1180)) # around Salt lake city, UT
  
  # Desert Cities
  xy_LV <- list(x=c(676:720),y=c(1591:1650)) # around Las Vegas, NV
  xy_PG <- list(x=c(1028:1035),y=c(1578:1585)) # around Page, AZ
  xy_PX <- list(x=c(891:990),y=c(1911:1990)) # around Phoenix, AZ
  xy_RN <- list(x=c(361:381),y=c(1141:1180)) # around Reno, NV
  
  # Coastal Cities
  xy_CH <- list(x=c(3051:3095),y=c(1001:1045)) # around Chicago, IL
  xy_NOLA <- list(x=c(2976:3035),y=c(2351:2380)) # around New Orleans, LA
  xy_NYC <- list(x=c(4171:4250),y=c(851:910)) # around New York City, NY
  xy_SF <- list(x=c(91:160),y=c(1261:1380)) # around San Francisco, CA
  
  #--------------- Now, make linear model for the target zones ------------------
  
  # Interior Cities
  CLLinearModel <- ModelScene(transformedMatrixPearson[xy_CL$x, xy_CL$y], NDVItempAveMatrixLong[xy_CL$x, xy_CL$y], 
                              LandscanPopulation[xy_CL$x, xy_CL$y], NLCDAgriculture[xy_CL$x, xy_CL$y])
  STLLinearModel <- ModelScene(transformedMatrixPearson[xy_STL$x, xy_STL$y], NDVItempAveMatrixLong[xy_STL$x, xy_STL$y], 
                               LandscanPopulation[xy_STL$x, xy_STL$y], NLCDAgriculture[xy_STL$x, xy_STL$y])
  MNLinearModel <- ModelScene(transformedMatrixPearson[xy_MN$x, xy_MN$y], NDVItempAveMatrixLong[xy_MN$x, xy_MN$y], 
                              LandscanPopulation[xy_MN$x, xy_MN$y], NLCDAgriculture[xy_MN$x, xy_MN$y])
  SLCLinearModel <- ModelScene(transformedMatrixPearson[xy_SLC$x, xy_SLC$y], NDVItempAveMatrixLong[xy_SLC$x, xy_SLC$y], 
                               LandscanPopulation[xy_SLC$x, xy_SLC$y], NLCDAgriculture[xy_SLC$x, xy_SLC$y])
  
  # Desert Cities
  LVLinearModel <- ModelScene(transformedMatrixPearson[xy_LV$x, xy_LV$y], NDVItempAveMatrixLong[xy_LV$x, xy_LV$y], 
                              LandscanPopulation[xy_LV$x, xy_LV$y], NLCDAgriculture[xy_LV$x, xy_LV$y])
  PageLinearModel <- ModelScene(transformedMatrixPearson[xy_PG$x, xy_PG$y], NDVItempAveMatrixLong[xy_PG$x, xy_PG$y], 
                                LandscanPopulation[xy_PG$x, xy_PG$y], NLCDAgriculture[xy_PG$x, xy_PG$y])
  PXLinearModel <- ModelScene(transformedMatrixPearson[xy_PX$x, xy_PX$y], NDVItempAveMatrixLong[xy_PX$x, xy_PX$y], 
                              LandscanPopulation[xy_PX$x, xy_PX$y], NLCDAgriculture[xy_PX$x, xy_PX$y])
  RenoLinearModel <- ModelScene(transformedMatrixPearson[xy_RN$x, xy_RN$y], NDVItempAveMatrixLong[xy_RN$x, xy_RN$y], 
                                LandscanPopulation[xy_RN$x, xy_RN$y], NLCDAgriculture[xy_RN$x, xy_RN$y])
  
  # Coastal Cities
  CHLinearModel <- ModelScene(transformedMatrixPearson[xy_CH$x, xy_CH$y], NDVItempAveMatrixLong[xy_CH$x, xy_CH$y], 
                              LandscanPopulation[xy_CH$x, xy_CH$y], NLCDAgriculture[xy_CH$x, xy_CH$y])
  NOLALinearModel <- ModelScene(transformedMatrixPearson[xy_NOLA$x, xy_NOLA$y], NDVItempAveMatrixLong[xy_NOLA$x, xy_NOLA$y], 
                                LandscanPopulation[xy_NOLA$x, xy_NOLA$y], NLCDAgriculture[xy_NOLA$x, xy_NOLA$y])
  NYCLinearModel <- ModelScene(transformedMatrixPearson[xy_NYC$x, xy_NYC$y], NDVItempAveMatrixLong[xy_NYC$x, xy_NYC$y], 
                               LandscanPopulation[xy_NYC$x, xy_NYC$y], NLCDAgriculture[xy_NYC$x, xy_NYC$y])
  SFLinearModel <- ModelScene(transformedMatrixPearson[xy_SF$x, xy_SF$y], NDVItempAveMatrixLong[xy_SF$x, xy_SF$y], 
                              LandscanPopulation[xy_SF$x, xy_SF$y], NLCDAgriculture[xy_SF$x, xy_SF$y])
  
  #---------------- Now, calculate VIF (variation inflation factor to detect multi-collinearity) ----------------------------
  
  VIFInterior <- as.vector(c(VIF(CLLinearModel), VIF(STLLinearModel), VIF(MNLinearModel), VIF(SLCLinearModel)))
  VIFDesert <- as.vector(c(VIF(LVLinearModel), VIF(PageLinearModel), VIF(PXLinearModel), VIF(RenoLinearModel)))
  VIFCoastal <- as.vector(c(VIF(CHLinearModel), VIF(NOLALinearModel), VIF(NYCLinearModel), VIF(SFLinearModel)))
  
  #-------------------- Now, saving results from the linear model and VIF for all target zone ----------------------------------------
  
  Interior_LinearModel_VIF<-list(Charleston_lm=CLLinearModel,
                             StLouis_lm=STLLinearModel,
                             Minneapolis_lm=MNLinearModel,
                             SaltLakeCity_lm=SLCLinearModel,
                             VIFInterior=VIFInterior)
  
  Desert_LinearModel_VIF<-list(LasVegas_lm=LVLinearModel, 
                               Page_lm=PageLinearModel, 
                               Phoenix_lm=PXLinearModel, 
                               Reno_lm=RenoLinearModel,
                               VIFDesert=VIFDesert)
  
  Coastal_LinearModel_VIF<-list(Chicago_lm=CHLinearModel,
                                NewOrleans_lm=NOLALinearModel, 
                                NewYorkCity_lm=NYCLinearModel, 
                                SanFrancisco_lm=SFLinearModel,
                                VIFCoastal=VIFCoastal)
  
  all_lm_VIF_res<-list(Interior_LinearModel_VIF=Interior_LinearModel_VIF,
                       Desert_LinearModel_VIF=Desert_LinearModel_VIF,
                       Coastal_LinearModel_VIF=Coastal_LinearModel_VIF)
  
  saveRDS(all_lm_VIF_res,"data/csvFiles/all_lm_VIF_res.RDS")
 
  ##########################################
  # Spatially Corrected Models 
  ##########################################
  
  Categories <- c("Max Temporal Average NDVI", "Landscan Population", "NLCD Percent Agriculture", "NLCD Development Index", "Elevation", "Slope")
  
  #----------- Interior Cities: for Pearson and SPearman based correlation matrices --------------
  
  # Charleston, WV
  CharlestonPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                                drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                xrange = xy_CL$x, yrange = xy_CL$y)
  Charleston_PearsonCorrelation <- CharlestonPearson$correlation
  Charleston_PearsonPValue <- CharlestonPearson$pvalue
  
  CharlestonSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                                 drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                 xrange = xy_CL$x, yrange = xy_CL$y)
  Charleston_SpearmanCorrelation <- CharlestonSpearman$correlation
  Charleston_SpearmanPValue <- CharlestonSpearman$pvalue
  
  # Kansas City, MO 
  SaintLouisPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                                drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                xrange = xy_STL$x, yrange = xy_STL$y)
  SaintLouis_PearsonCorrelation <- SaintLouisPearson$correlation
  SaintLouis_PearsonPValue <- SaintLouisPearson$pvalue
  
  SaintLouisSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                                 drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                 xrange = xy_STL$x, yrange = xy_STL$y)
  SaintLouis_SpearmanCorrelation <- SaintLouisSpearman$correlation
  SaintLouis_SpearmanPValue <- SaintLouisSpearman$pvalue
  
  #Minneapolis, MN 
  MinneapolisPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                                 drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                 xrange = xy_MN$x, yrange = xy_MN$y)
  Minneapolis_PearsonCorrelation <- MinneapolisPearson$correlation
  Minneapolis_PearsonPValue <- MinneapolisPearson$pvalue
  
  MinneapolisSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                                  drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                  xrange = xy_MN$x, yrange = xy_MN$y)
  Minneapolis_SpearmanCorrelation <- MinneapolisSpearman$correlation
  Minneapolis_SpearmanPValue <- MinneapolisSpearman$pvalue
  
  # Salt Lake City, UT
  SaltLakeCityPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                                  drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                  xrange = xy_SLC$x, yrange = xy_SLC$y)
  SaltLakeCity_PearsonCorrelation <- SaltLakeCityPearson$correlation
  SaltLakeCity_PearsonPValue <- SaltLakeCityPearson$pvalue
  
  SaltLakeCitySpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                                   drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                   xrange = xy_SLC$x, yrange = xy_SLC$y)
  SaltLakeCity_SpearmanCorrelation <- SaltLakeCitySpearman$correlation
  SaltLakeCity_SpearmanPValue <- SaltLakeCitySpearman$pvalue
  
  #----------- Desert Cities: for Pearson and SPearman based correlation matrices --------------
  
  # Las Vegas, NV 
  LasVegasPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                              drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                              xrange = xy_LV$x, yrange = xy_LV$y)
  LasVegas_PearsonCorrelation <- LasVegasPearson$correlation
  LasVegas_PearsonPValue <- LasVegasPearson$pvalue
  
  LasVegasSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                               drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                               xrange = xy_LV$x, yrange = xy_LV$y)
  LasVegas_SpearmanCorrelation <- LasVegasSpearman$correlation
  LasVegas_SpearmanPValue <- LasVegasSpearman$pvalue
  
  # Page, AZ 
  PagePearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                          drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                          xrange = xy_PG$x, yrange = xy_PG$y)
  Page_PearsonCorrelation <- PagePearson$correlation
  Page_PearsonPValue <- PagePearson$pvalue
  
  PageSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                           drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                           xrange = xy_PG$x, yrange = xy_PG$y)
  Page_SpearmanCorrelation <- PageSpearman$correlation
  Page_SpearmanPValue <- PageSpearman$pvalue
  
  # Phoenix, AZ 
  PhoenixPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                             drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                             xrange = xy_PX$x, yrange = xy_PX$y)
  Phoenix_PearsonCorrelation <- PhoenixPearson$correlation
  Phoenix_PearsonPValue <- PhoenixPearson$pvalue
  
  PhoenixSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                              drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                              xrange = xy_PX$x, yrange = xy_PX$y)
  Phoenix_SpearmanCorrelation <- PhoenixSpearman$correlation
  Phoenix_SpearmanPValue <- PhoenixSpearman$pvalue
  
  # Reno, NV
  RenoPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                          drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                          xrange = xy_RN$x, yrange = xy_RN$y)
  Reno_PearsonCorrelation <- RenoPearson$correlation
  Reno_PearsonPValue <- RenoPearson$pvalue
  
  RenoSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                           drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                           xrange = xy_RN$x, yrange = xy_RN$y)
  Reno_SpearmanCorrelation <- RenoSpearman$correlation
  Reno_SpearmanPValue <- RenoSpearman$pvalue
  
  #----------- Coastal Cities: for Pearson and SPearman based correlation matrices --------------
  
  # Chicago, IL 
  ChicagoPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                             drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                             xrange = xy_CH$x, yrange = xy_CH$y)
  Chicago_PearsonCorrelation <- ChicagoPearson$correlation
  Chicago_PearsonPValue <- ChicagoPearson$pvalue
  
  ChicagoSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                              drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                              xrange = xy_CH$x, yrange = xy_CH$y)
  Chicago_SpearmanCorrelation <- ChicagoSpearman$correlation
  Chicago_SpearmanPValue <- ChicagoSpearman$pvalue
  
  # New Orleans, LA
  NewOrleansPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                                drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                xrange = xy_NOLA$x, yrange = xy_NOLA$y)
  NewOrleans_PearsonCorrelation <- NewOrleansPearson$correlation
  NewOrleans_PearsonPValue <- NewOrleansPearson$pvalue
  
  NewOrleansSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                                 drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                 xrange = xy_NOLA$x, yrange = xy_NOLA$y)
  NewOrleans_SpearmanCorrelation <- NewOrleansSpearman$correlation
  NewOrleans_SpearmanPValue <- NewOrleansSpearman$pvalue
  
  # New York City, NY 
  NewYorkPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                             drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                             xrange = xy_NYC$x, yrange = xy_NYC$y)
  NewYork_PearsonCorrelation <- NewYorkPearson$correlation
  NewYork_PearsonPValue <- NewYorkPearson$pvalue
  
  NewYorkSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                              drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                              xrange = xy_NYC$x, yrange = xy_NYC$y)
  NewYork_SpearmanCorrelation <- NewYorkSpearman$correlation
  NewYork_SpearmanPValue <- NewYorkSpearman$pvalue
  
  #San Francisco, CA
  SanFranciscoPearson <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearson, 
                                                  drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                  xrange = xy_SF$x, yrange = xy_SF$y)
  SanFrancisco_PearsonCorrelation <- SanFranciscoPearson$correlation
  SanFrancisco_PearsonPValue <- SanFranciscoPearson$pvalue
  
  SanFranciscoSpearman <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearman, 
                                                   drivers = drivers, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                   xrange = xy_SF$x, yrange = xy_SF$y)
  SanFrancisco_SpearmanCorrelation <- SanFranciscoSpearman$correlation
  SanFrancisco_SpearmanPValue <- SanFranciscoSpearman$pvalue
  
  # saving results in a data frame
  PearsonDataframe_cor <- data.frame(
                                 # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
                                 Charleston_PearsonCorrelation, SaintLouis_PearsonCorrelation, 
                                 Minneapolis_PearsonCorrelation, SaltLakeCity_PearsonCorrelation, 
                                 # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
                                 LasVegas_PearsonCorrelation, Page_PearsonCorrelation, 
                                 Phoenix_PearsonCorrelation,  Reno_PearsonCorrelation, 
                                 # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
                                 Chicago_PearsonCorrelation,  NewOrleans_PearsonCorrelation, 
                                 NewYork_PearsonCorrelation,  SanFrancisco_PearsonCorrelation 
                                 )
  
  PearsonDataframe_pval <- data.frame(
    # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
    Charleston_PearsonPValue, SaintLouis_PearsonPValue,
    Minneapolis_PearsonPValue, SaltLakeCity_PearsonPValue,
    # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
    LasVegas_PearsonPValue, Page_PearsonPValue, 
    Phoenix_PearsonPValue, Reno_PearsonPValue, 
    # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
    Chicago_PearsonPValue, NewOrleans_PearsonPValue, 
    NewYork_PearsonPValue, SanFrancisco_PearsonPValue
  )
  
  row.names(PearsonDataframe_cor) <-  row.names(PearsonDataframe_pval) <- Categories
  PearsonDataframe_cor<-rotate_df(PearsonDataframe_cor)
  PearsonDataframe_pval<-rotate_df(PearsonDataframe_pval)
  
  PearsonDataframe<-list(PearsonDataframe_cor=PearsonDataframe_cor,
                         PearsonDataframe_pval=PearsonDataframe_pval)
  
  SpearmanDataframe_cor <- data.frame(
                                  # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
                                  Charleston_SpearmanCorrelation, SaintLouis_SpearmanCorrelation, 
                                  Minneapolis_SpearmanCorrelation, SaltLakeCity_SpearmanCorrelation, 
                                  # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
                                  LasVegas_SpearmanCorrelation, Page_SpearmanCorrelation, 
                                  Phoenix_SpearmanCorrelation,  Reno_SpearmanCorrelation, 
                                  # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
                                  Chicago_SpearmanCorrelation, NewOrleans_SpearmanCorrelation, 
                                  NewYork_SpearmanCorrelation, SanFrancisco_SpearmanCorrelation 
                                  )
  
  SpearmanDataframe_pval <- data.frame(
    # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
     Charleston_SpearmanPValue, SaintLouis_SpearmanPValue,
     Minneapolis_SpearmanPValue, SaltLakeCity_SpearmanPValue,
    # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
     LasVegas_SpearmanPValue, Page_SpearmanPValue, 
     Phoenix_SpearmanPValue, Reno_SpearmanPValue, 
    # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
     Chicago_SpearmanPValue,  NewOrleans_SpearmanPValue, 
     NewYork_SpearmanPValue, SanFrancisco_SpearmanPValue
  )
  
  row.names(SpearmanDataframe_cor) <- row.names(SpearmanDataframe_pval) <- Categories
  SpearmanDataframe_cor<-rotate_df(SpearmanDataframe_cor)
  SpearmanDataframe_pval<-rotate_df(SpearmanDataframe_pval)
  
  SpearmanDataframe<-list(SpearmanDataframe_cor=SpearmanDataframe_cor,
                          SpearmanDataframe_pval=SpearmanDataframe_pval)
  
  saveRDS(PearsonDataframe, "data/csvFiles/AVHRR_PearsonCorrelationData.RDS") # A list of two dataframes
  saveRDS(SpearmanDataframe, "data/csvFiles/AVHRR_SpearmanCorrelationData.RDS") # A list of two dataframes
  
  ######################################################################
  # Spatially Corrected Models but excluding 2010
  ######################################################################
  
  #----------- Interior Cities: for Pearson and SPearman based correlation matrices, excluding 2010 --------------
  
  # Charleston, WV
  CharlestonPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                xrange = xy_CL$x, yrange = xy_CL$y)
  Charleston_PearsonNo2010Correlation <- CharlestonPearsonNo2010$correlation
  Charleston_PearsonNo2010PValue <- CharlestonPearsonNo2010$pvalue
  
  CharlestonSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                       drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                       xrange = xy_CL$x, yrange = xy_CL$y)
  Charleston_SpearmanNo2010Correlation <- CharlestonSpearmanNo2010$correlation
  Charleston_SpearmanNo2010PValue <- CharlestonSpearmanNo2010$pvalue
  
  # Kansas City, MO 
  SaintLouisPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                      drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                      xrange = xy_STL$x, yrange = xy_STL$y)
  SaintLouis_PearsonNo2010Correlation <- SaintLouisPearsonNo2010$correlation
  SaintLouis_PearsonNo2010PValue <- SaintLouisPearsonNo2010$pvalue
  
  SaintLouisSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                       drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                       xrange = xy_STL$x, yrange = xy_STL$y)
  SaintLouis_SpearmanNo2010Correlation <- SaintLouisSpearmanNo2010$correlation
  SaintLouis_SpearmanNo2010PValue <- SaintLouisSpearmanNo2010$pvalue
  
  #Minneapolis, MN 
  MinneapolisPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                       drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                       xrange = xy_MN$x, yrange = xy_MN$y)
  Minneapolis_PearsonNo2010Correlation <- MinneapolisPearsonNo2010$correlation
  Minneapolis_PearsonNo2010PValue <- MinneapolisPearsonNo2010$pvalue
  
  MinneapolisSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                        drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                        xrange = xy_MN$x, yrange = xy_MN$y)
  Minneapolis_SpearmanNo2010Correlation <- MinneapolisSpearmanNo2010$correlation
  Minneapolis_SpearmanNo2010PValue <- MinneapolisSpearmanNo2010$pvalue
  
  # Salt Lake City, UT
  SaltLakeCityPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                        drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                        xrange = xy_SLC$x, yrange = xy_SLC$y)
  SaltLakeCity_PearsonNo2010Correlation <- SaltLakeCityPearsonNo2010$correlation
  SaltLakeCity_PearsonNo2010PValue <- SaltLakeCityPearsonNo2010$pvalue
  
  SaltLakeCitySpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                         drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                         xrange = xy_SLC$x, yrange = xy_SLC$y)
  SaltLakeCity_SpearmanNo2010Correlation <- SaltLakeCitySpearmanNo2010$correlation
  SaltLakeCity_SpearmanNo2010PValue <- SaltLakeCitySpearmanNo2010$pvalue
  
  #----------- Desert Cities: for Pearson and SPearman based correlation matrices, excluding 2010 --------------
  
  # Las Vegas, NV 
  LasVegasPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                    drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                    xrange = xy_LV$x, yrange = xy_LV$y)
  LasVegas_PearsonNo2010Correlation <- LasVegasPearsonNo2010$correlation
  LasVegas_PearsonNo2010PValue <- LasVegasPearsonNo2010$pvalue
  
  LasVegasSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                     drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                     xrange = xy_LV$x, yrange = xy_LV$y)
  LasVegas_SpearmanNo2010Correlation <- LasVegasSpearmanNo2010$correlation
  LasVegas_SpearmanNo2010PValue <- LasVegasSpearmanNo2010$pvalue
  
  # Page, AZ  
  PagePearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                xrange = xy_PG$x, yrange = xy_PG$y)
  Page_PearsonNo2010Correlation <- PagePearsonNo2010$correlation
  Page_PearsonNo2010PValue <- PagePearsonNo2010$pvalue
  
  PageSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                 drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                 xrange = xy_PG$x, yrange = xy_PG$y)
  Page_SpearmanNo2010Correlation <- PageSpearmanNo2010$correlation
  Page_SpearmanNo2010PValue <- PageSpearmanNo2010$pvalue
  
  # Phoenix, AZ 
  PhoenixPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                   drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                   xrange = xy_PX$x, yrange = xy_PX$y)
  Phoenix_PearsonNo2010Correlation <- PhoenixPearsonNo2010$correlation
  Phoenix_PearsonNo2010PValue <- PhoenixPearsonNo2010$pvalue
  
  PhoenixSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                    drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                    xrange = xy_PX$x, yrange = xy_PX$y)
  Phoenix_SpearmanNo2010Correlation <- PhoenixSpearmanNo2010$correlation
  Phoenix_SpearmanNo2010PValue <- PhoenixSpearmanNo2010$pvalue
  
  # Reno, NV
  RenoPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                xrange = xy_RN$x, yrange = xy_RN$y)
  Reno_PearsonNo2010Correlation <- RenoPearsonNo2010$correlation
  Reno_PearsonNo2010PValue <- RenoPearsonNo2010$pvalue
  
  RenoSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                 drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                 xrange = xy_RN$x, yrange = xy_RN$y)
  Reno_SpearmanNo2010Correlation <- RenoSpearmanNo2010$correlation
  Reno_SpearmanNo2010PValue <- RenoSpearmanNo2010$pvalue
  
  #----------- Coastal Cities: for Pearson and SPearman based correlation matrices, excluding 2010 --------------
  
  # Chicago, IL 
  ChicagoPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                   drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                   xrange = xy_CH$x, yrange = xy_CH$y)
  Chicago_PearsonNo2010Correlation <- ChicagoPearsonNo2010$correlation
  Chicago_PearsonNo2010PValue <- ChicagoPearsonNo2010$pvalue
  
  ChicagoSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                    drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                    xrange = xy_CH$x, yrange = xy_CH$y)
  Chicago_SpearmanNo2010Correlation <- ChicagoSpearmanNo2010$correlation
  Chicago_SpearmanNo2010PValue <- ChicagoSpearmanNo2010$pvalue
  
  # New Orleans, LA 
  NewOrleansPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                      drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                      xrange = xy_NOLA$x, yrange = xy_NOLA$y)
  NewOrleans_PearsonNo2010Correlation <- NewOrleansPearsonNo2010$correlation
  NewOrleans_PearsonNo2010PValue <- NewOrleansPearsonNo2010$pvalue
  
  NewOrleansSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                       drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                       xrange = xy_NOLA$x, yrange = xy_NOLA$y)
  NewOrleans_SpearmanNo2010Correlation <- NewOrleansSpearmanNo2010$correlation
  NewOrleans_SpearmanNo2010PValue <- NewOrleansSpearmanNo2010$pvalue
  
  # New York City, NY
  NewYorkPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                   drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                   xrange = xy_NYC$x, yrange = xy_NYC$y)
  NewYork_PearsonNo2010Correlation <- NewYorkPearsonNo2010$correlation
  NewYork_PearsonNo2010PValue <- NewYorkPearsonNo2010$pvalue
  
  NewYorkSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                    drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                    xrange = xy_NYC$x, yrange = xy_NYC$y)
  NewYork_SpearmanNo2010Correlation <- NewYorkSpearmanNo2010$correlation
  NewYork_SpearmanNo2010PValue <- NewYorkSpearmanNo2010$pvalue
  
  # San Francisco, CA 
  SanFranciscoPearsonNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixPearsonNo2010, 
                                                        drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                        xrange = xy_SF$x, yrange = xy_SF$y)
  SanFrancisco_PearsonNo2010Correlation <- SanFranciscoPearsonNo2010$correlation
  SanFrancisco_PearsonNo2010PValue <- SanFranciscoPearsonNo2010$pvalue
  
  SanFranciscoSpearmanNo2010 <- SpatiallyCorrectedModels(transformedMatrix = transformedMatrixSpearmanNo2010, 
                                                         drivers = driversNo2010, xMatrix = xMatrix, yMatrix = yMatrix, 
                                                         xrange = xy_SF$x, yrange = xy_SF$y)
  SanFrancisco_SpearmanNo2010Correlation <- SanFranciscoSpearmanNo2010$correlation
  SanFrancisco_SpearmanNo2010PValue <- SanFranciscoSpearmanNo2010$pvalue
  
  
  # saving results in a data frame
  PearsonNo2010Dataframe_cor <- data.frame(
    # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
    Charleston_PearsonNo2010Correlation, SaintLouis_PearsonNo2010Correlation, 
    Minneapolis_PearsonNo2010Correlation, SaltLakeCity_PearsonNo2010Correlation, 
    # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
    LasVegas_PearsonNo2010Correlation, Page_PearsonNo2010Correlation, 
    Phoenix_PearsonNo2010Correlation,  Reno_PearsonNo2010Correlation, 
    # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
    Chicago_PearsonNo2010Correlation, NewOrleans_PearsonNo2010Correlation, 
    NewYork_PearsonNo2010Correlation, SanFrancisco_PearsonNo2010Correlation
  )
  
  PearsonNo2010Dataframe_pval <- data.frame(
    # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
    Charleston_PearsonNo2010PValue, SaintLouis_PearsonNo2010PValue,
    Minneapolis_PearsonNo2010PValue, SaltLakeCity_PearsonNo2010PValue,
    # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
    LasVegas_PearsonNo2010PValue, Page_PearsonNo2010PValue,
    Phoenix_PearsonNo2010PValue, Reno_PearsonNo2010PValue, 
    # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
    Chicago_PearsonNo2010PValue, NewOrleans_PearsonNo2010PValue, 
    NewYork_PearsonNo2010PValue, SanFrancisco_PearsonNo2010PValue
  )
  
  row.names(PearsonNo2010Dataframe_cor) <-  row.names(PearsonNo2010Dataframe_pval) <- Categories
  PearsonNo2010Dataframe_cor<-rotate_df(PearsonNo2010Dataframe_cor)
  PearsonNo2010Dataframe_pval<-rotate_df(PearsonNo2010Dataframe_pval)
  
  PearsonNo2010Dataframe<-list(PearsonNo2010Dataframe_cor=PearsonNo2010Dataframe_cor,
                         PearsonNo2010Dataframe_pval=PearsonNo2010Dataframe_pval)
  
  SpearmanNo2010Dataframe_cor <- data.frame(
    # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
    Charleston_SpearmanNo2010Correlation, SaintLouis_SpearmanNo2010Correlation, 
    Minneapolis_SpearmanNo2010Correlation, SaltLakeCity_SpearmanNo2010Correlation, 
    # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
    LasVegas_SpearmanNo2010Correlation, Page_SpearmanNo2010Correlation, 
    Phoenix_SpearmanNo2010Correlation, Reno_SpearmanNo2010Correlation, 
    # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
    Chicago_SpearmanNo2010Correlation, NewOrleans_SpearmanNo2010Correlation, 
    NewYork_SpearmanNo2010Correlation, SanFrancisco_SpearmanNo2010Correlation
  )
  
  SpearmanNo2010Dataframe_pval <- data.frame(
    # Interior cities: "Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"
    Charleston_SpearmanNo2010PValue, SaintLouis_SpearmanNo2010PValue,
    Minneapolis_SpearmanNo2010PValue, SaltLakeCity_SpearmanNo2010PValue,
    # Desert cities: "Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"
    LasVegas_SpearmanNo2010PValue, Page_SpearmanNo2010PValue, 
    Phoenix_SpearmanNo2010PValue, Reno_SpearmanNo2010PValue, 
    # Coastal cities: "Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"
    Chicago_SpearmanNo2010PValue, NewOrleans_SpearmanNo2010PValue, 
    NewYork_SpearmanNo2010PValue, SanFrancisco_SpearmanNo2010PValue
  )
  
  row.names(SpearmanNo2010Dataframe_cor) <- row.names(SpearmanNo2010Dataframe_pval) <- Categories
  SpearmanNo2010Dataframe_cor<-rotate_df(SpearmanNo2010Dataframe_cor)
  SpearmanNo2010Dataframe_pval<-rotate_df(SpearmanNo2010Dataframe_pval)
  
  SpearmanNo2010Dataframe<-list(SpearmanNo2010Dataframe_cor=SpearmanNo2010Dataframe_cor,
                          SpearmanNo2010Dataframe_pval=SpearmanNo2010Dataframe_pval)
  
  saveRDS(PearsonNo2010Dataframe, "data/csvFiles/AVHRR_PearsonNo2010CorrelationData.RDS") # A list of two dataframes
  saveRDS(SpearmanNo2010Dataframe, "data/csvFiles/AVHRR_SpearmanNo2010CorrelationData.RDS") # A list of two dataframes
  
}
