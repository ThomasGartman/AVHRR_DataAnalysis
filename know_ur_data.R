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

zm<-apply(z, c(1,2), var) 

#z<-z[500:510,500:505,]
#zm<-apply(z, c(1,2), var)

# Now, if the variance of cell values throughout the years = 0 then that means 
# those cells have same values throughout the years

indmat<-which(zm==0, arr.ind = T) # these are the indices for which cells have same value 
                                          #  through out the years

nrow(indmat) #622 : so we got 622 cells which have zeros throughout the years
xx<-zm[indmat]
(xxt<-as.data.frame(table(xx)))

#----------- plotting cell values = 0 for all years on map------------------
library(rasterVis)
m<-z[,,1]

# first invert vertically the map
mi<-m[,ncol(m):1]
zmi<-zm[,ncol(zm):1]
badid<-which(zmi==0, arr.ind = T)

col1<-colorRampPalette(brewer.pal(n=9,"YlGn")) 

pdf("./plot_for_same_value_at_cells.pdf",height=5,width=10)
levelplot(mi,margin=F,col.regions=col1,xlab="x-coord",ylab="y-coord",main="detrended NDVI for 1990")+
  layer(panel.points(badid[,1],badid[,2], pch=20, cex=0.3, col='red'))
dev.off()

#mr<-raster(t(m))
#levelplot(m[500:600,500:600],margin=F,col.regions=col1,xlab="x-coord",main="myplot")

# how to mark a point on map
#col1<-colorRampPalette(brewer.pal(n=9,"YlGn")) 
#levelplot(mi,margin=F,col.regions=col1)+
#layer(panel.points(200,400, pch=21, cex=2, colour='black', fill='red'))



###########################################################################

# understand VectorizeMatrices.R using toy example: need to check
xmatrix <- t(readRDS("data/csvFiles/AVHRR_X_CoordinateMatrix.RDS"))
ymatrix <- t(readRDS("data/csvFiles/AVHRR_Y_CoordinateMatrix.RDS"))
xmatrix<-xmatrix[1:5,1:5]
ymatrix<-ymatrix[1:5,1:5]

set.seed(101)
data1<-matrix(runif(25,min=0,max=1),nrow=5)
data2<-matrix(runif(25,min=0,max=1),nrow=5)

data1[1:2,4:5]<-NA
data2[3,5]<-NA
data2[5,5]<-Inf
vectors <- lapply(list(data1, data2, xmatrix, ymatrix), as.vector) # This line will make a list
                                                                   # with the values reading along column 
                                                                   # for each matrix 

alteredVectors <- vectors
length(alteredVectors[[1]]) #25

for(i in 1:length(vectors)){
  alteredVectors[[i]] <- vectors[[i]][!Reduce("|", lapply(vectors, is.na))]
}
length(alteredVectors[[1]]) #20 # so the above code only reports values for the indicies which remain non-NA for 
                                #  every list element in vectors

finalVectors <- alteredVectors
length(finalVectors[[2]]) #20

for(i in 1:length(alteredVectors)){
  finalVectors[[i]] <- alteredVectors[[i]][!Reduce("|", lapply(alteredVectors, is.infinite))] 
}

# so the above code only reports values for the indicies which remain finite for 
#  every list element in vectors

length(finalVectors[[2]]) #19

# ok, code checked!

############################################################################################################

# How to interpret results from OLS model? for example choose coastal cities: chicago and new orleans

# Our model:
#   Response ~ beta0 + beta1 * pred1 + beta2 * pred2 + beta3 * pred3 
#   Response = Pearson NDVI syn mat
#   pred1 = temporal avg 1990-2018 NDVI syn mat
#   pred2 = population from 2004 mat
#   pred3 = Agriculture (avg. for 2001, 2006)

# Table 3 showed 
# chicago, new orleans both have all 4 predictors which had significant p value, i.e., 
#             corresponding coefficients (beta's) were significantly different than zero 
# But for chicago Rsq value was much greater than new orleans.
# That means our model was good in explaining ~68% variance in our data for chicago, but not for new orleans.
# That also means to explain variance in new orleans data there could be some other linear predictors.

# The basic concept is:

# There is no established association/relationship between p-value and R-square. This all depends on the data (i.e.; contextual).
# R-square value tells you how much variation is explained by your model. So 0.1 R-square means 
# that your model explains 10% of variation within the data. The greater R-square 
# the better the model. Whereas p-value tells you about the F statistic hypothesis 
# testing of the "fit of the intercept-only model and your model are equal". So if the p-value 
# is less than the significance level (usually 0.05) then your model fits the data well.

# Thus you have four scenarios:
#1) low R-square and low p-value (p-value <= 0.05)
#2) low R-square and high p-value (p-value > 0.05)
#3) high R-square and low p-value
#4) high R-square and high p-value

# Interpretation:
#1) means that your model doesn't explain much of variation of the data but it is significant (better than not having a model)
#2) means that your model doesn't explain much of variation of the data and it is not significant (worst scenario)
#3) means your model explains a lot of variation within the data and is significant (best scenario)
#4) means that your model explains a lot of variation within the data but is not significant (model is worthless)

################################################################################################################
# Interpret VIF? 
# VIF = 1/(1-Rsq), VIF > 1 means there is multicollinearity, i.e. correlation between your predictors
# Higher VIF = less reliable regression results = indicates what percentage the variance 
#   (i.e. the standard error squared) is inflated for each coefficient

# For example, for new orleans VIF = 1.094, the variance of a particular coefficient is 9.4% bigger 
#                                     than what you would expect if there was no multicollinearity 
# For chicago, VIF was much greater than new orleans.

#############################################################################################################

# My comments:
# For charleston, page, chicago (with higher VIF) may be we should make a model with interaction terms (GAM?)

##############################################################################################################

# Interpret Spatially corrected model-results:







