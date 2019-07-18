source("../../scripts/SynchronyMatrixCalculator.R")

capture_output({
  test_that("Test exception: data is an array",{
    dataframe1 <- data.frame(1:10)
    array1 <- array(1:27, dim=c(3,3,3))
    vector1 <- 1:27
    matrix1 <- matrix(1:20, 2, 10)
    years1 <- 1:3
    radius1 <-5
    
    expect_error(SynchronyMatrixCalculator(array1, years1, radius1), NA)
    expect_error(SynchronyMatrixCalculator(vector1, years1, radius1), "Error in SynchronyMatrixCalculator: dataArray must be a 3D array.")
    expect_error(SynchronyMatrixCalculator(dataframe1, years1, radius1), "Error in SynchronyMatrixCalculator: dataArray must be a 3D array.")
    expect_error(SynchronyMatrixCalculator(matrix1, years1, radius1), "Error in SynchronyMatrixCalculator: dataArray must be a 3D array.")
  })
  
  test_that("Test exception: years is a numeric vector",{
    array2 <- array(1:36, dim=c(3,3,4))
    years2 <- 1:4
    radius2 <- 2
    years2F1 <- c(TRUE, FALSE, TRUE, FALSE)
    years2F2 <- c('a', 'b', 'c', 'd')
    years2F3 <- c("This", "is", "a", "test")
    years2F4 <- data.frame(1:4)
    years2F5 <- matrix(1:4, 2, 2)
    
    expect_error(SynchronyMatrixCalculator(array2, years2, radius2), NA)
    expect_error(SynchronyMatrixCalculator(array2, years2F1, radius2), "Error in SynchronyMatrixCalculator: years must be a numeric vector")
    expect_error(SynchronyMatrixCalculator(array2, years2F2, radius2), "Error in SynchronyMatrixCalculator: years must be a numeric vector")
    expect_error(SynchronyMatrixCalculator(array2, years2F3, radius2), "Error in SynchronyMatrixCalculator: years must be a numeric vector")
    expect_error(SynchronyMatrixCalculator(array2, years2F4, radius2), "Error in SynchronyMatrixCalculator: years must be a numeric vector")
    expect_error(SynchronyMatrixCalculator(array2, years2F5, radius2), "Error in SynchronyMatrixCalculator: years must be a numeric vector")
  })
  
  test_that("Test exception: year range must start before 1",{
    array3 <- array(1:27, dim=c(3,3,3))
    radius3 <- 3
    years3 <- 1:3
    years3F1 <- seq(-10, -8, 1)
    years3F2 <- seq(-1, -1, 1)
    years3F3 <- seq(0, 2, 1)
    
    expect_error(SynchronyMatrixCalculator(array3, years3, radius3), NA)
    expect_error(SynchronyMatrixCalculator(array3, years3F1, radius3), "Error in SynchronyMatrixCalculator: Year range starts before 1.")
    expect_error(SynchronyMatrixCalculator(array3, years3F2, radius3), "Error in SynchronyMatrixCalculator: Year range starts before 1.")
    expect_error(SynchronyMatrixCalculator(array3, years3F3, radius3), "Error in SynchronyMatrixCalculator: Year range starts before 1.")
  })
  
  test_that("Test exception: year range must end before or on array range",{
    array4 <- array(1:27, dim=c(3,3,3))
    radius4 <- 1
    years4S <- 1:3
    years4F <- 1:4
    
    expect_error(SynchronyMatrixCalculator(array4, years4S, radius4), NA)
    expect_error(SynchronyMatrixCalculator(array4, years4F, radius4), "Error in SynchronyMatrixCalculator: Year range ends after array ends.")
  })
  
  test_that("Test exception: radius must be a number",{
    array5 <- array(1:27, dim=c(3,3,3))
    years5 <- 1:3
    radius5 <- 2
    radius5F1 <- c(TRUE, FALSE, TRUE, FALSE)
    radius5F2 <- c('a', 'b', 'c', 'd')
    radius5F3 <- c("This", "is", "a", "test")
    radius5F4 <- data.frame(1:4)
    radius5F5 <- matrix(1:4, 2, 2)
    
    expect_error(SynchronyMatrixCalculator(array5, years5, radius5), NA)
    expect_error(SynchronyMatrixCalculator(array5, years5, radius5F1), "Error in SynchronyMatrixCalculator: radius must be a numeric value.")
    expect_error(SynchronyMatrixCalculator(array5, years5, radius5F2), "Error in SynchronyMatrixCalculator: radius must be a numeric value.")
    expect_error(SynchronyMatrixCalculator(array5, years5, radius5F3), "Error in SynchronyMatrixCalculator: radius must be a numeric value.")
    expect_error(SynchronyMatrixCalculator(array5, years5, radius5F4), "Error in SynchronyMatrixCalculator: radius must be a numeric value.")
    expect_error(SynchronyMatrixCalculator(array5, years5, radius5F5), "Error in SynchronyMatrixCalculator: radius must be a numeric value.")
  })
  
  test_that("Test exception: radius must be a positive number",{
    array6 <- array(1:27, dim=c(3,3,3))
    years6 <- 1:3
    radius6 <- 2
    radius6F1 <- -5
    radius6F2 <- 0

    
    expect_error(SynchronyMatrixCalculator(array6, years6, radius6), NA)
    expect_error(SynchronyMatrixCalculator(array6, years6, radius6F1), "Error in SynchronyMatrixCalculator: radius must be a positive number.")
    expect_error(SynchronyMatrixCalculator(array6, years6, radius6F2), "Error in SynchronyMatrixCalculator: radius must be a positive number.")
  })
  
  test_that("Test exception: coorelation test must be 'pearson', 'kendall', or 'spearman'.",{
    array7 <- array(1:27, dim=c(3,3,3))
    years7 <- 1:2
    radius7 <- 1
    coorTest7S1 <- "pearson"
    coorTest7S2 <- 'pearson'
    coorTest7S3 <- "kendall"
    coorTest7S4 <- 'kendall'
    coorTest7S5 <- "spearman"
    coorTest7S6 <- 'spearman'
    coorTest7F1 <- "coor"
    coorTest7F2 <- TRUE
    coorTest7F3 <- data.frame(1:10)
    
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7S1), NA)
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7S2), NA)
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7S3), NA)
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7S4), NA)
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7S5), NA)
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7S6), NA)
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7F1), "Error in SynchronyMatrixCalculator: coorelation test must be exactly 'pearson', 'kendall', or 'spearman'.")
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7F2), "Error in SynchronyMatrixCalculator: coorelation test must be exactly 'pearson', 'kendall', or 'spearman'.")
    expect_error(SynchronyMatrixCalculator(array7, years7, radius7, coorTest7F3), "Error in SynchronyMatrixCalculator: coorelation test must be exactly 'pearson', 'kendall', or 'spearman'.")
  })
  
  test_that("Test return value: All synchrony values must be between -1 or 1.",{
    array8 <- array(runif(1000, -1, 1), dim<-c(10,10,10))
    years8 <- 1:5
    radius8 <- 3
    coorTest8 <- "pearson"
    
    expect_false(any(SynchronyMatrixCalculator(array8, years8, radius8, coorTest8) < -1 || SynchronyMatrixCalculator(array8, years8, radius8, coorTest8) > 1, na.rm = TRUE))
  })
  
  test_that("Test return value: Synchrony Calculation using Pearson coorelation.", {
    array9 <- array(runif(27, -1, 1), dim<-c(3,3,3))
    years9 <- 1:3
    radius9 <- 2
    coorTest9 <- "pearson"
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[1,1], 
                 (cor(array9[1,1,years9], array9[2,1,years9]) + cor(array9[1,1,years9], array9[3,1,years9]) + cor(array9[1,1,years9], array9[1,2,years9]) 
                  + cor(array9[1,1,years9], array9[2,2,years9]) + cor(array9[1,1,years9], array9[1,3,years9]))/(5))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[2,1], 
                 (cor(array9[2,1,years9], array9[1,1,years9]) + cor(array9[2,1,years9], array9[3,1,years9]) + cor(array9[2,1,years9], array9[1,2,years9]) 
                  + cor(array9[2,1,years9], array9[2,2,years9]) + cor(array9[2,1,years9], array9[3,2,years9])+ cor(array9[2,1,years9], array9[2,3,years9]))/(6))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[3,1], 
                 (cor(array9[3,1,years9], array9[2,1,years9]) + cor(array9[3,1,years9], array9[1,1,years9]) + cor(array9[3,1,years9], array9[3,2,years9]) 
                  + cor(array9[3,1,years9], array9[2,2,years9]) + cor(array9[3,1,years9], array9[3,3,years9]))/(5))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[1,2], 
                 (cor(array9[1,2,years9], array9[1,1,years9]) + cor(array9[1,2,years9], array9[1,3,years9]) + cor(array9[1,2,years9], array9[2,1,years9]) 
                  + cor(array9[1,2,years9], array9[2,2,years9]) + cor(array9[1,2,years9], array9[3,2,years9])+ cor(array9[1,2,years9], array9[2,3,years9]))/(6))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[2,2], 
                 (cor(array9[2,2,years9], array9[1,1,years9]) + cor(array9[2,2,years9], array9[1,2,years9]) + cor(array9[2,2,years9], array9[1,3,years9]) 
                  + cor(array9[2,2,years9], array9[2,1,years9]) + cor(array9[2,2,years9], array9[2,3,years9]) + cor(array9[2,2,years9], array9[3,1,years9]) 
                  + cor(array9[2,2,years9], array9[3,2,years9]) + cor(array9[2,2,years9], array9[3,3,years9]))/(8))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[3,2], 
                 (cor(array9[3,2,years9], array9[3,1,years9]) + cor(array9[3,2,years9], array9[3,3,years9]) + cor(array9[3,2,years9], array9[2,1,years9]) 
                  + cor(array9[3,2,years9], array9[2,2,years9]) + cor(array9[3,2,years9], array9[2,3,years9])+ cor(array9[3,2,years9], array9[1,2,years9]))/(6))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[1,3], 
                 (cor(array9[1,3,years9], array9[1,2,years9]) + cor(array9[1,3,years9], array9[1,1,years9]) + cor(array9[1,3,years9], array9[2,3,years9]) 
                  + cor(array9[1,3,years9], array9[3,3,years9]) + cor(array9[1,3,years9], array9[2,2,years9]))/(5))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[2,3], 
                 (cor(array9[2,3,years9], array9[1,3,years9]) + cor(array9[2,3,years9], array9[3,3,years9]) + cor(array9[2,3,years9], array9[1,2,years9]) 
                  + cor(array9[2,3,years9], array9[2,2,years9]) + cor(array9[2,3,years9], array9[3,2,years9])+ cor(array9[2,3,years9], array9[2,1,years9]))/(6))
    
    expect_equal(SynchronyMatrixCalculator(array9, years9, radius9, coorTest9)[3,3], 
                 (cor(array9[3,3,years9], array9[3,2,years9]) + cor(array9[3,3,years9], array9[3,1,years9]) + cor(array9[3,3,years9], array9[2,3,years9]) 
                  + cor(array9[3,3,years9], array9[1,3,years9]) + cor(array9[3,3,years9], array9[2,2,years9]))/(5))
  })
})