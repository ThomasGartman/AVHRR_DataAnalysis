NLCDDataGenerator <- function(year)
{
  if(year == 2001)
  {
    dataFiles <- list.files(pattern="AVHRR_NLCD_2001*")
    frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
    matrices <- lapply(frames, function(x) t(data.matrix(x)))
    
    #Make an array from the list of matrices
    dataArray <- array(NA, dim=c(4587, 2889, 18))
    dataArray <- lapply(1:16, function(i) as.matrix(matrices[[i]]))
    dataArray
  }
  else if(year == 2006)
  {
    dataFiles <- list.files(pattern="AVHRR_NLCD_2001*")
    frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
    matrices <- lapply(frames, function(x) t(data.matrix(x)))
    
    #Make an array from the list of matrices
    dataArray <- array(NA, dim=c(4587, 2889, 18))
    dataArray <- lapply(1:16, function(i) as.matrix(matrices[[i]]))
    dataArray
  }
  else if(year == 2011)
  {
    dataFiles <- list.files(pattern="AVHRR_NLCD_2001*")
    frames <- lapply(dataFiles, function(x) {read.csv(file=x, header=FALSE)})
    matrices <- lapply(frames, function(x) t(data.matrix(x)))
    
    #Make an array from the list of matrices
    dataArray <- array(NA, dim=c(4587, 2889, 18))
    dataArray <- lapply(1:16, function(i) as.matrix(matrices[[i]]))
    dataArray
  }
  else
  {
    print("Incorrect year.")
  }
}