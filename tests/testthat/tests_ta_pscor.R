source("../../scripts/ta_pscor.R")

test_that("test error catching for numeric vectors", {
  x<-c(seq(from=0.1, to= 0.9,by=0.1),NA,"x")
  y<-c(seq(from=0.11, to= 0.91,by=0.1),NA,NA)
  expect_error(ta_pscor(x=x,y=y,perc_tail=0.5), "Error in argument specification: x,y should be numeric vectors")
})

test_that("test error catching for perc_tail", {
  x<-c(seq(from=0.1, to= 0.9,by=0.1),NA)
  y<-c(seq(from=0.11, to= 0.91,by=0.1),NA)
  expect_error(ta_pscor(x=x,y=y,perc_tail=0), "Error in argument specification: perc_tail should be >0 or <=0.5")
  expect_error(ta_pscor(x=x,y=y,perc_tail=0.6), "Error in argument specification: perc_tail should be >0 or <=0.5")
})

test_that("test format and accuracy",{
  
  # ------------- test format of output -----------------------
  
  # generate data showing stronger lower tail association
  set.seed(seed=101)
  x <- rnorm(30,0,1)
  y <- x+ rnorm(30,-1,1)
  
  x<-rank(x)/(length(x)+1)
  y<-rank(y)/(length(y)+1)
  
  # visually check
  #x<-copula::pobs(x)
  #y<-copula::pobs(y)
  #plot(x,y)
  #abline(a=1,b=-1)
  
  ans2 <- ta_pscor(x = x, y = y, perc_tail = 0.5)
  
  expect_is(ans2,"numeric")
  
  expect_gt(ans2[1],ans2[2]) # as lower ta is stonger than upper ta
  
  # ---------------- test accuracy: Spearman correlation = lta_pscor + uta_pscor ------------------------
  target<-cor(x=x,y=y,method="spearman")
  expect_equal(sum(ans2),target) # NOTE: this is true because no data points lie exactly on the bounds 
  
})