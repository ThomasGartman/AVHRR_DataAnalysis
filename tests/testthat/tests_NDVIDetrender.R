#Testing for NDVI Detrender
source("../../scripts/NDVIDetrender.R")

test_that("Test exception: data is an array or vector",{
  dataframe1 <- data.frame(1:10)
  array1 <- array(1:27, dim=c(3,3,3))
  vector1 <- 1:27
  matrix1 <- matrix(1:20, 2, 10)
  years1 <- 1:3
  
  expect_error(NDVIDetrender(array1, years1), NA)
  expect_error(NDVIDetrender(vector1, years1), NA)
  expect_error(NDVIDetrender(dataframe1, years1), "Error in NDVIDetrender: data must be an array or vector.")
  expect_error(NDVIDetrender(matrix1, years1), "Error in NDVIDetrender: data must be an array or vector.")
})

test_that("Test exception: years is a numeric vector",{
  array2 <- array(1:24, dim=c(3,2,4))
  vector2 <- 1:30
  years2 <- 1:4
  years2F1 <- c(TRUE, FALSE, TRUE, FALSE)
  years2F2 <- c('a', 'b', 'c', 'd')
  years2F3 <- c("This", "is", "a", "test")
  years2F4 <- data.frame(1:4)
  years2F5 <- matrix(1:4, 2, 2)
  
  expect_error(NDVIDetrender(array2, years2), NA)
  expect_error(NDVIDetrender(vector2, years2), NA)
  expect_error(NDVIDetrender(array2, years2F1), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(vector2, years2F1), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(array2, years2F2), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(vector2, years2F2), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(array2, years2F3), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(vector2, years2F3), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(array2, years2F4), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(vector2, years2F4), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(array2, years2F5), "Error in NDVIDetrender: years must be a numeric vector")
  expect_error(NDVIDetrender(vector2, years2F5), "Error in NDVIDetrender: years must be a numeric vector")
})

test_that("Test exception: year range must start before 1",{
  array3 <- array(1:27, dim=c(3,3,3))
  vector3 <- 1:27
  years3 <- 1:3
  years3F1 <- seq(-10, -8, 1)
  years3F2 <- seq(-1, -1, 1)
  years3F3 <- seq(0, 2, 1)
  
  expect_error(NDVIDetrender(array3, years3), NA)
  expect_error(NDVIDetrender(vector3, years3), NA)
  expect_error(NDVIDetrender(array3, years3F1), "Error in NDVIDetrender: Year range starts before 1.")
  expect_error(NDVIDetrender(vector3, years3F1), "Error in NDVIDetrender: Year range starts before 1.")
  expect_error(NDVIDetrender(array3, years3F2), "Error in NDVIDetrender: Year range starts before 1.")
  expect_error(NDVIDetrender(vector3, years3F2), "Error in NDVIDetrender: Year range starts before 1.")
  expect_error(NDVIDetrender(array3, years3F3), "Error in NDVIDetrender: Year range starts before 1.")
  expect_error(NDVIDetrender(vector3, years3F3), "Error in NDVIDetrender: Year range starts before 1.")
})

test_that("Test exception: year range must end before or on array range",{
  array4 <- array(1:27, dim=c(3,3,3))
  years4S <- 1:3
  years4F <- 1:4
  
  expect_error(NDVIDetrender(array4, years4S), NA)
  expect_error(NDVIDetrender(array4, years4F), "Error in NDVIDetrender: Year range ends after array ends.")
})

test_that("Test exception: year range must end before or on vector range",{
  vector5 <- 1:10
  years5S <- 1:7
  years5F <- 1:13
  
  expect_error(NDVIDetrender(vector5, years5S), NA)
  expect_error(NDVIDetrender(vector5, years5F), "Error in NDVIDetrender: Year range ends after vector ends.")
})

test_that("Test Return Values: Am I getting the correct value?", {
  array6 <- array(runif(1000, -1, 1), dim=c(10,10,10))
  residuals6 <- array(NA, dim=c(10,10,5))
  array7 <- array(c(NA, runif(999, -1, 1)), dim=c(10,10,10))
  residuals7 <- array(NA, dim=c(10,10,5))
  years6 <- 1:5
  
  for(i in 1:10)
  {
    for(j in 1:10)
    {
      residuals6[i,j,years6] <- as.vector(residuals(lm(array6[i,j,years6] ~ years6)))
      residuals7[i,j,years6] <- as.vector(detrend(array7[i,j,years6]))
    }
  }
  
  expect_equal(NDVIDetrender(array6, years6), residuals6)
  expect_equal(NDVIDetrender(array7, years6), residuals7)
  expect_true(is.na(NDVIDetrender(array7, years6)[1,1,1]))
  expect_equal(sum(is.na(NDVIDetrender(array7, years6))), 1)
})