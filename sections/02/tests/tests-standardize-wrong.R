# load the source code of the functions to be tested
source("../functions.R")

# tests for the standardize function
test_that("standardize works with normal input", {
  x <- c(1, 2, 3)
  z <- (x - mean(x)) / sd(x)

  expect_equal(standardizeWrong(x), z)
  expect_length(standardizeWrong(x), length(x))
  expect_type(standardizeWrong(x), 'double')
})


test_that("standardize works with missing values", {
  y <- c(1, 2, NA)
  z1 <- (y - mean(y, na.rm = FALSE)) / sd(y, na.rm = FALSE)
  z2 <- (y - mean(y, na.rm = TRUE)) / sd(y, na.rm = TRUE)

  expect_equal(standardizeWrong(y), z1)
  expect_length(standardizeWrong(y), length(y))
  expect_equal(standardizeWrong(y, na.rm = TRUE), z2)
  expect_length(standardizeWrong(y, na.rm = TRUE), length(y))
  expect_type(standardizeWrong(y), 'double')
})


test_that("standardize handles logical vector", {
  w <- c(TRUE, FALSE, TRUE)
  z <- (w - mean(w)) / sd(w)

  expect_equal(standardizeWrong(w), z)
  expect_length(standardizeWrong(w), length(w))
  expect_type(standardizeWrong(w), 'double')
})
