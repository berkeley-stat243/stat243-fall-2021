#' @title Standardize
#' @description Computes z-scores (scores in standard units)
#' @param x numeric vector
#' @param na.rm whether to remove missing values
#' @return vector of standard scores
#' @examples
#'  a <- runif(5)
#'  z <- standardize(a)
#'  mean(z)
#'  sd(z)
standardize <- function(x, na.rm = FALSE) {
  # assertions of the input 
  assert_that(is.vector(x))
  assert_that(is.flag(na.rm))
  
  z <- (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm)
  return(z)
}

#' @title Standardize (incorrect version to show when tests fail)
#' @description Computes z-scores (scores in standard units)
#' @param x numeric vector
#' @param na.rm whether to remove missing values
#' @return vector of standard scores
#' @examples
#'  a <- runif(5)
#'  z <- standardize(a)
#'  mean(z)
#'  sd(z)
standardizeWrong <- function(x, na.rm = FALSE) {
  # assertions on input
  assert_that(is.vector(x))
  assert_that(is.flag(na.rm))
  
  z <- (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm) + 1
  return(z)
}

