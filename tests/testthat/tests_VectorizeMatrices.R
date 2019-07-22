source("../../scripts/VectorizeMatrices.R")

test_that("Test Error Checking: Only Matrices allowed.",{
  matrix1 <- matrix(1:30, nrow = 2, ncol = 15)
  matrix2 <- matrix(31:60, nrow = 2, ncol = 15)
  
  vector1 <- 1:30
  array1 <- array(1:30, dim=c(2,15,1))
  datframe1 <- data.frame(1:30)
  expect_error(VectorizeMatrices(matrix1), NA)
  expect_error(VectorizeMatrices(matrix1, matrix2), NA)
  expect_error(VectorizeMatrices(vector1),"Vectorize Matrices Error: Some arguments were not matrices.")
  expect_error(VectorizeMatrices(array1),"Vectorize Matrices Error: Some arguments were not matrices.")
  expect_error(VectorizeMatrices(datframe1),"Vectorize Matrices Error: Some arguments were not matrices.")
  expect_error(VectorizeMatrices(matrix1, vector1),"Vectorize Matrices Error: Some arguments were not matrices.")
  expect_error(VectorizeMatrices(matrix1, array1),"Vectorize Matrices Error: Some arguments were not matrices.")
  expect_error(VectorizeMatrices(matrix1, datframe1),"Vectorize Matrices Error: Some arguments were not matrices.")
})

test_that("Test Error Checking: All Matrices must have the same dimension.", {
  matrix1 <- matrix(1:30, nrow = 5, ncol = 6)
  matrix2 <- matrix(31:60, nrow = 5, ncol = 6)
  matrix3 <- matrix(11:70, nrow = 2, ncol = 15)
  matrix4 <- matrix(1:10, nrow = 2, ncol = 5)
  
  expect_error(VectorizeMatrices(matrix1), NA)
  expect_error(VectorizeMatrices(matrix1, matrix2), NA)
  expect_error(VectorizeMatrices(matrix3), NA)
  expect_error(VectorizeMatrices(matrix1, matrix3),"Vectorize Matrices Error: Some matrices not the same dimension as others.")
  expect_error(VectorizeMatrices(matrix1, matrix2, matrix3, matrix4),"Vectorize Matrices Error: Some matrices not the same dimension as others.")
})

test_that("Test Return Value: Vectorization correct.", {
  matrix1 <- matrix(1:30, nrow = 5, ncol=6)
  matrix2 <- matrix(c(NA, NA, NA, NA), nrow = 2, ncol = 2)
  matrix3 <- matrix(c(1:29, NA), nrow = 5, ncol = 6)
  matrix4 <- matrix(c(1:5, NA, NA, NA, 9:10, 11:15, 16:18, NA, 20), nrow = 2, ncol=10)
  matrix5 <- matrix(c(1:2, NA, NA, NA, 6:10, NA, NA, 13:20), nrow = 2, ncol=10)
  matrix6 <- matrix(c(NA, NA, NA, 4:20), nrow = 2, ncol=10)
  matrix7 <- matrix(c(1:15, NA, NA, NA, 19:20), nrow = 2, ncol=10)
  matrix8 <- matrix(c(1:10, NA, 12:20), nrow=2, ncol=10)
  matrix9 <- matrix(c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, NA, NA, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), nrow=2, ncol=10)
  matrix10 <- matrix(c(Inf, 2:30), nrow = 5, ncol = 6)
  
  expect_equal(VectorizeMatrices(matrix1), list(x<-1:30))
  expect_equal(VectorizeMatrices(matrix2), list(logical(0)))
  expect_equal(VectorizeMatrices(matrix1, matrix3), list(x<-1:29, y<-1:29))
  expect_equal(VectorizeMatrices(matrix4, matrix5, matrix6, matrix7), list(w<-c(9:10,13:15,20),x<-c(9:10,13:15,20),y<-c(9:10,13:15,20),z<-c(9:10,13:15,20)))
  expect_equal(VectorizeMatrices(matrix8, matrix9), list(x<-c(1:10, 12, 15:20), y<-c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE)))
  expect_equal(VectorizeMatrices(matrix3, matrix10), list(x<-c(2:29), y<-c(2:29)))
})