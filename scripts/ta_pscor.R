# Function to estimate lower and upper tail-association between two vectors via partial Spearman correlation

# NOTE: we assume positive association between two covariates for "lower" and "upper" tail notion, for 
# negatively associated variables those notions are not applicable.

# Arguments
# x, y: two numeric vectors (may contain NA's), but already ranked (using normalize ranking)
# perc_tail: a number in between (0,0.5] describing the percentage of 
#            extreme tail used to estimate association (default value= 0.5)

# Output
# A vector of two numbers: lower tail and upper tail associations, respectively.

ta_pscor<-function(x,y,perc_tail=0.5){
  
  if((is.numeric(x) & is.numeric(y))==F){
    stop("Error in argument specification: x,y should be numeric vectors")
  }
  
  if((perc_tail ==0 | perc_tail >0.5)==T){
    stop("Error in argument specification: perc_tail should be >0 or <=0.5")
  }
  
  mat<-cbind(x,y)
  mat<-na.omit(mat)
  
  if(nrow(mat)==0){
    
    #warning("No data points left after pairwise omitting NA's from x and y", call.=T, immediate. = T)
    lta_pscor<-NA
    uta_pscor<-NA
    return(c(lta_pscor,uta_pscor))
    
  }else{
    
    corVal <- cor(mat[,1], mat[,2], method = 'spearman')
    
    if(is.na(corVal)==T){
      
      # this corVal can be NA if any of mat[,1] or mat[,2] has same value throughout years for a pixel
      # for example, corVal is NA for NDVIdetrendedDataArray1990[397,1055,] and NDVIdetrendedDataArray1990[402,1055,]
      lta_pscor<-NA
      uta_pscor<-NA
      return(c(lta_pscor,uta_pscor))
      
    }else if(corVal<0){ # for negatively correlated timeseries
      
      #warning("Negatively correlated", call.=T, immediate. = T)
      lta_pscor<-NA
      uta_pscor<-NA
      return(c(lta_pscor,uta_pscor))
      
    }else{ # for positively correlated timeseries
      
      vi<-mat[,1]
      vj<-mat[,2]
      
      #get mean and variance
      vi_mean<-mean(vi)
      vj_mean<-mean(vj)
      var_vi<-var(vi)
      var_vj<-var(vj)
      
      #------------ for lower tail: compute the indices of the points between the bounds --------------
      inds<-which(vi+vj>0 & vi+vj<(2*perc_tail)) #(lb=0,ub=perc_tail)
      
      if(length(inds)!=0){ 
        #get the portion of the Spearman
        lta_pscor<-sum((vi[inds]-vi_mean)*(vj[inds]-vj_mean))/((length(vi)-1)*sqrt(var_vi*var_vj))
      }else{
        lta_pscor<-NA # this means no pints found in between the bounds
      }
      
      #---------- for upper tail: compute the indices of the points between the bounds ----------------
      inds<-which(vi+vj>(2*(1-perc_tail)) & vi+vj<2)  #(lb=1-perc_tail,ub=1)
      
      if(length(inds)!=0){ 
        #get the portion of the Spearman
        uta_pscor<-sum((vi[inds]-vi_mean)*(vj[inds]-vj_mean))/((length(vi)-1)*sqrt(var_vi*var_vj))
      }else{
        uta_pscor<-NA # this means no pints found in between the bounds
      }
      
      return(c(lta_pscor,uta_pscor))
      
    }

  }
  
}




