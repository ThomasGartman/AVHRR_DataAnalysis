# So, in data/csvFiles/ I have total 56 csv files that I got from Thomas
# They are:
#         NDVI (1989 to 2018)         = 30
#         Landscan_pop (2000 to 2017) = 18 
#         Lat, Long                   = 2
#         Agriculture (2001, 2006)    = 2
#         Development (2001, 2006)    = 2
#         Elevation (mean, sd)        = 2

# first read a csv file for NDVI 2000 
ndvi2000<-read.csv("./data/csvFiles/AVHRR_NDVI_WaterRemoved_2000.csv",header = F)
class(ndvi2000)
head(ndvi2000[500,500:505]) # has NA to remove water body
dim(ndvi2000) #2889 4587 NDVI data is in comperable to lat lon format

# ok, now you need such data frames for all available years to store into an array
# so, look for scripts/CSVInput.R - this script is called into the master data generator file: AVHRRDataGenerator.R

# Running AVHRRDataGenerator.R by parts: completed upto detrending

#----------------------NOTES: what I learned from Thomas--------------------------------------------------

# Raw NDVI data for year 1989 have some problem in the dessert region: plot to check it
#     therefore, detrending starts from 1990.

# Landscan pop data averaging over 2003, 2004 because it is just at the middle in 2000 to 2006

# Thomas guessed chicago has anomaly for 2010 but when he carried out analysis for detrended chicago data 
#     excluding 2010, still it is not solved - chicago is weird for unknown reason!

#-------------------------------------------------------------------------------------------------------

# I have edited the bugs in Thomas code: Check completed for AVHRRDataGenerator.R

# two Qs I need to get answers:

# 1. Why do we need logit transform? log(x/1-x), where x is in between [0,1] ?
# normally distributed epsilon in linear regression makes response variable y (=m*x +b +epsilon) spread 
# outside [0,1]

# 2. For temporal averaging, Thomas chose raw NDVI (1990 - 2018), why you don't choose detrended ones?
# mean(detrended ts)=0

# when running Pearson synchrony mat for 1990-2018:
# 50 such warnings() came like:
# In cor(dataArray[i, j, years], dataArray[k, m, years],  ... : the standard deviation is zero
# why? Because for 50 such pixels the values are same throughout the years.

#-------------------------------------------------------------------------------------------------------------

# I am not sure about Dan's idea of making array with normalize ranking before to feed into ta_pscor function.

# If we are going to be use that idea then 
# I need :
# All pixels within 5 radius have same position index for NA's [1:29] for years, because we will omit NA's pairwise

# Now second issue: how to omit na? before ranking or after ranking?
# see the rank documentation for argument "na.last"for controlling the treatment of NAs. 
# If TRUE(default), missing values in the data are put last; 
# if FALSE, they are put first; if NA, they are removed; if "keep" they are kept with rank NA.

# I would prefer na.last = "keep" and then use na.omit = T within my ta_pscor function

#--------------------------------------------------------------------------------------------------
# To locate which cell index give you std deviation zero for timeseries

z<-readRDS("./data/csvFiles/NDVIdetrendedDataArray1990to2018.RDS")

zm<-apply(z, c(1,2), mean)

#z1<-z[301:303,301:303,1]

#z2<-zm[301:303,301:303]

#indm<-which(z2 < 1e-8,arr.ind=T)

indmat<-which(z[,,1]==zm, arr.ind = T)

nrow(indmat) #675

badmat<-zm
badmat[!indmat]<-NA

xx<-zm[indmat]

xxt<-as.data.frame(table(xx))
xxt


z[1094,240,]


