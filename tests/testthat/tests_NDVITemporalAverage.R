source("../../scripts/NDVITemporalAverage.R")

test_that("Test exception: is the data array an actual array?", {
  arr <- array(1:100, dim = c(2, 5, 10))
  vec <- 1:100
  datframe <- data.frame(1:100)
  
  expect_error(NDVITemporalAverage(arr), NA)
  expect_error(NDVITemporalAverage(vec), "NDVI Temporal Average Error: Data must be an array.")
  expect_error(NDVITemporalAverage(datframe), "NDVI Temporal Average Error: Data must be an array.")
})

test_that("Test exception: is the data array dimension three?", {
  arr1 <- array(1:100, dim = c(2, 50))
  arr2 <- array(1:100, dim = c(2, 5, 10))
  arr3 <- array(1:100, dim = c(2, 5, 5, 2))
  
  expect_error(NDVITemporalAverage(arr1), "NDVI Temporal Average Error: Data must be of dimension three.")
  expect_error(NDVITemporalAverage(arr2), NA)
  expect_error(NDVITemporalAverage(arr3), "NDVI Temporal Average Error: Data must be of dimension three.")
})

test_that("Test exception: Is the array numeric?", {
  arr1 <- array(1:100, dim = c(2, 5, 10))
  arr2 <- array(c('a', 'b', 'c', 'd', 'e', 'f'), dim=c(2,3,1))
  
  expect_error(NDVITemporalAverage(arr1), NA)
  expect_error(NDVITemporalAverage(arr2), "NDVI Temporal Average Error: Data must be numeric.")
})

test_that("Test return value: Are the values correct?",{
  arr1 <- array(1:100, dim = c(2, 5, 10))
  arr2 <- array(-100:100, dim = c(2, 5, 10))
  
  expect_equal(NDVITemporalAverage(arr1), matrix(c(mean(arr1[1,1,]), mean(arr1[2,1,])
               , mean(arr1[1,2,]) , mean(arr1[2,2,])
               , mean(arr1[1,3,]) , mean(arr1[2,3,])
               , mean(arr1[1,4,]) , mean(arr1[2,4,])
               , mean(arr1[1,5,]) , mean(arr1[2,5,])), ncol = 5, nrow = 2))
  
  expect_equal(NDVITemporalAverage(arr2), matrix(c(mean(arr2[1,1,]) , mean(arr2[2,1,])
               , mean(arr2[1,2,]) , mean(arr2[2,2,])
               , mean(arr2[1,3,]) , mean(arr2[2,3,])
               , mean(arr2[1,4,]) , mean(arr2[2,4,])
               , mean(arr2[1,5,]) , mean(arr2[2,5,])), ncol = 5, nrow = 2))
})