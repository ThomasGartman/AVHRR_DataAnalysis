#' This is version 0.1.0 for the statistics required for the AVHRR project
#'
#' Namely this function will need to accomplish or manage:
#'
#'	1. Read in appropriate data files into the correct matrix shape.
#'	2. Vectorize all matrices.
#'	3. Internally check to ensure all vectors have consistant NAs, then remove them (keep track of what was removed)
#'	4. Begin constructing models
AVHRRStatistics <- function()
{
	########################################
	# Functions Called
	########################################
	source("scripts/CSVInput.R")

	########################################
	#Read in Data
	########################################
	#Predictor 1 - Population
	Landscan2002Matrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_Population_WaterRemoved_2002.csv"))
	Landscan2017Matrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Landscan_Population_WaterRemoved_2017.csv"))

	#Predictor 2 - Time Averaged NDVI
	if(file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix1.csv"))
  	{
    	  NDVItempAveMatrix1 <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrix1.csv", header = FALSE))
  	}
	else
	{
	  stop("Error: AHRR_NDVItempAveMatrix1.csv does not exist.")
	}
 	if(file.exists("data/csvFiles/AVHRR_NDVItempAveMatrix2.csv"))
  	{
    	  NDVItempAveMatrix2 <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrix2.csv", header = FALSE))
  	}
	else
	{
	  stop("Error: AVHRR_NDVItempAveMatrix2.csv does not exist.")
	}
  	if(file.exists("data/csvFiles/AVHRR_NDVItempAeMatrixLong.csv"))
  	{
    	  NDVItempAveMatrixLong <- as.matrix(read.csv("data/csvFiles/AVHRR_NDVItempAveMatrixLong.csv", header = FALSE))
  	}
	else
	{
	  stop("Error: AVHRR_NDVItempAveMatrixLong.csv does not exist.")
	}

        #Logit Transformed Synchrony Values - Our Observed Variable
	if(file.exists("data/csvFiles/AVHRR_Transformed1NOLA.csv"))
        {
          transformed1NOLAMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed1NOLA.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed1NOLA.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_Transformed2NOLA.csv"))
        {
          transformed2NOLAMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed2NOLA.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed2NOLA.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_TransformedLongNOLA.csv"))
        {
          transformedLongNOLAMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongNOLA.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_TransformedLongNOLA.csv not found.")
        }

	#Transformed Synchrony Values - the observed variable
	#NOLA
	if(file.exists("data/csvFiles/AVHRR_Transformed1NOLA.csv"))
	{
	  transformed1NOLAMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed1NOLA.csv", header=FALSE))
	}
	else
	{
	  stop("Error: AVHRR_Transformed1NOLA.csv not found.")
	}
	if(file.exists("data/csvFiles/AVHRR_Transformed2NOLA.csv"))
        {
          transformed2NOLAMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed2NOLA.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed2NOLA.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_TransformedLongNOLA.csv"))
        {
          transformedLongNOLAMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongNOLA.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_TransformedLongNOLA.csv not found.")
        }

        #Everglades
        if(file.exists("data/csvFiles/AVHRR_Transformed1Everglades.csv"))
        {       
          transformed1EvergladesMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed1Everglades.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed1Everglades.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_Transformed1Everglades.csv"))
        {
          transformed2EvergladesMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed2Everglades.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed2Everglades.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_TransformedLongEverglades.csv"))
        {
          transformedLongEvergladesMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongEverglades.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_TransformedLongEverglades.csv not found.")
        }

        #Central Valley (CV)
        if(file.exists("data/csvFiles/AVHRR_Transformed1CV.csv"))
        {       
          transformed1CVMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed1CV.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed1CV.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_Transformed2CV.csv"))
        {
          transformed2CVMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_Transformed2CV.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_Transformed2CV.csv not found.")
        }
        if(file.exists("data/csvFiles/AVHRR_TransformedLongCV.csv"))
        {
          transformedLongCVMatrix <- as.matrix(read.csv("data/csvFiles/AVHRR_TransformedLongCV.csv", header=FALSE))
        }
        else
        {
          stop("Error: AVHRR_TransformedLongCV.csv not found.")
        }

}
