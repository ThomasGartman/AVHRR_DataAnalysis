NAtoNaN <- function()
{
  #Convert all files Na into NaN
  fileNames <- Sys.glob("data/csvFiles/*.csv")
  
  for(fileName in fileNames)
  {
    print(fileName)
    if(!grepl("NaN", fileName, fixed = TRUE) && 
       !file.exists(paste(substr(fileName, 1, nchar(fileName)-4), "NaN.csv", sep="")))
    {  
      data <- t(read.csv(fileName, sep = ",", skip = 0))
  
      data[is.na(data)] <- -100
    
      write.csv(data, paste(substr(fileName, 1, nchar(fileName)-4), "NaN.csv", sep=""), row.names = FALSE)
    }
  }
  return()
}