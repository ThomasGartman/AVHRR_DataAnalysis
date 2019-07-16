source("../../scripts/LogitSynchronyTransform.R")

test_that("Test exception: Are values Greater than 0?", {
  vecS <- runif(1000, 0, 1)
  matS <- matrix(runif(1000, 0, 1), nrow = 10, ncol = 10)
  arrS <- array(runif(1000, 0, 1), dim = c(2, 5, 10))
  datframeS <- data.frame(runif(1000, 0, 1))
  vecF <- c(.2, .3, .6, -2, -.3)
  matF <- matrix(runif(1000, -100, 0), nrow = 10, ncol = 10)
  arrF <- array(runif(1000, -12312, 0), dim = c(2, 5, 10))
  datframeF <- data.frame(runif(1000, -123, 0))
  
  expect_error(LogitSynchronyTransform(vecS), NA)
  expect_error(LogitSynchronyTransform(matS), NA)
  expect_error(LogitSynchronyTransform(arrS), NA)
  expect_error(LogitSynchronyTransform(datframeS), NA)
  expect_error(LogitSynchronyTransform(vecF), "Logit Synchrony Transform Error: Some values equal to or less than 0.")
  expect_error(LogitSynchronyTransform(matF), "Logit Synchrony Transform Error: Some values equal to or less than 0.")
  expect_error(LogitSynchronyTransform(arrF), "Logit Synchrony Transform Error: Some values equal to or less than 0.")
  expect_error(LogitSynchronyTransform(datframeF), "Logit Synchrony Transform Error: Some values equal to or less than 0.")
})

test_that("Test exception: Are values Less than 1?", {
  vecS <- runif(1000, 0, 1)
  matS <- matrix(runif(1000, 0, 1), nrow = 10, ncol = 10)
  arrS <- array(runif(1000, 0, 1), dim = c(2, 5, 10))
  datframeS <- data.frame(runif(1000, 0, 1))
  vecF <- c(.2, .3, .6, 2, .3)
  matF <- matrix(runif(1000, 1, 100), nrow = 10, ncol = 10)
  arrF <- array(runif(1000, 1, 1546), dim = c(2, 5, 10))
  datframeF <- data.frame(runif(1000, 1, 1123))
  
  expect_error(LogitSynchronyTransform(vecS), NA)
  expect_error(LogitSynchronyTransform(matS), NA)
  expect_error(LogitSynchronyTransform(arrS), NA)
  expect_error(LogitSynchronyTransform(datframeS), NA)
  expect_error(LogitSynchronyTransform(vecF), "Logit Synchrony Transform Error: Some values equal to or greater than 1.")
  expect_error(LogitSynchronyTransform(matF), "Logit Synchrony Transform Error: Some values equal to or greater than 1.")
  expect_error(LogitSynchronyTransform(arrF), "Logit Synchrony Transform Error: Some values equal to or greater than 1.")
  expect_error(LogitSynchronyTransform(datframeF), "Logit Synchrony Transform Error: Some values equal to or greater than 1.")
})

test_that("Test return value: Are the values correct?",{
  vec <- (1 + runif(1000, 0, 1))/2
  mat <- (1 + matrix(runif(1000, 0, 1), nrow = 10, ncol = 10))/2
  arr <- (1 + array(runif(1000, 0, 1), dim = c(2, 5, 10)))/2
  datframe <- (1 + data.frame(runif(1000, 0, 1)))/2
                
  expect_equal(LogitSynchronyTransform(vec), log(vec/(1-vec)))
  expect_equal(LogitSynchronyTransform(mat), log(mat/(1-mat)))
  expect_equal(LogitSynchronyTransform(arr), log(arr/(1-arr)))
  expect_equal(LogitSynchronyTransform(datframe), log(datframe/(1-datframe)))
})