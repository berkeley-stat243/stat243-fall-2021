# load data and libraries
library(foreach)
library(doFuture)
library(microbenchmark)
library(doRNG)

# note this code and example is from this website
# https://nceas.github.io/oss-lessons/parallel-computing-in-r/parallel-computing-in-r.html

# get data
data <- iris[which(iris[, 5] != "setosa"), c(1, 5)]
n_boot <- 10000 # number of bootstrapped samples

# set number of cores and register 
nCores <- 3
plan(strategy = multiprocess, workers = nCores)
registerDoFuture()

# do computation 
# parallel
microbenchmark({
  r <- foreach(i = 1:n_boot, .combine = rbind) %dorng% {
    # fit logistic regression on bootstrapped samples and return coefficients
    ind <- sample(100, 100, replace = TRUE)
    result1 <- glm(data[ind, 2] ~ data[ind, 1], family = binomial(logit))
    coefficients(result1)
  }
}, times = 2)

# serial
microbenchmark({
  r <- foreach(i = 1:n_boot, .combine = rbind) %do% {
    ind <- sample(100, 100, replace = TRUE)
    result1 <- glm(data[ind, 2] ~ data[ind, 1], family = binomial(logit))
    coefficients(result1)
  }
}, times = 2)


print("Computation done!")