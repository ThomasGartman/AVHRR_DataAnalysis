# Purpose: Normalized Ranking for an array, ranking process is done along 3rd dimension of the array

# Args: an array

# Output: An normalized ranked version of the given array

NormalizedRanking<-function(given_array){
  given_array_NormRanked <- array(NA, dim=dim(given_array))
  for(i in 1:dim(given_array)[1]){
    for(j in 1:dim(given_array)[2]){
      myvec<-given_array[i,j,]
      given_array_NormRanked[i,j,]<-rank(myvec)/(sum(is.finite(myvec))+1)
    }
  }
  return(given_array_NormRanked)
}
