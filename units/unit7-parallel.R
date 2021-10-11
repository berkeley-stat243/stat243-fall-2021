############################################################
### Demo code for Unit 7 of Stat243, "Parallel processing"
### Chris Paciorek, October 2021
############################################################

##########################################################
# 5: Illustrating the principles in specific case studies
##########################################################

### 5.1 Scenario 1: one model fit

## @knitr ranger

args(ranger::ranger)

## @knitr R-linalg

library(RhpcBLASctl)
x <- matrix(rnorm(5000^2), 5000)

blas_set_num_threads(4)
system.time({
   x <- crossprod(x)
   U <- chol(x)
})

##   user  system elapsed 
##  8.316   2.260   2.692 

blas_set_num_threads(1)
system.time({
   x <- crossprod(x)
   U <- chol(x)
})

##   user  system elapsed 
##  6.360   0.036   6.399 

## @knitr

### 5.2 Scenario 2: three different prediction methods

## @knitr basic-future

library(future)
ntasks <- 3
plan(multisession, workers = ntasks)

n <- 10000000
system.time({
	fut_p <- future(mean(rnorm(n)), seed = TRUE)
	fut_q <- future(mean(rgamma(n, shape = 1)), seed = TRUE)
	fut_s <- future(mean(rt(n, df = 3)), seed = TRUE)
        p <- value(fut_p)
        q <- value(fut_q)
        s <- value(fut_s)
})

system.time({
	p <- mean(rnorm(n))
	q <- mean(rgamma(n, shape = 1))
	s <- mean(rt(n, df = 3))
})

## @knitr

### 5.3 Scenario 3: cross-validation

## @knitr rf-example

library(randomForest)

cvFit <- function(foldIdx, folds, Y, X, loadLib = FALSE) {
    if(loadLib)
        library(randomForest)
    out <- randomForest(y = Y[folds != foldIdx],
                        x = X[folds != foldIdx, ],
                        xtest = X[folds == foldIdx, ])
    return(out$test$predicted)
}

set.seed(23432)
## training set
n <- 1000
p <- 50
X <- matrix(rnorm(n*p), nrow = n, ncol = p)
colnames(X) <- paste("X", 1:p, sep="")
X <- data.frame(X)
Y <- X[, 1] + sqrt(abs(X[, 2] * X[, 3])) + X[, 2] - X[, 3] + rnorm(n)
nFolds <- 10
folds <- sample(rep(seq_len(nFolds), each = n/nFolds), replace = FALSE)

## @knitr foreach

library(doFuture)
library(doRNG)
nCores <- 2
plan(multisession, workers = nCores)
registerDoFuture()

## Use of %dorng% from doRNG relates to parallel random number generation.
## We'll see more in Unit 10 (Simulation)
## If not using random number generation, people usually use %dopar%.

result <- foreach(i = seq_len(nFolds)) %dorng% {
	cat('Starting ', i, 'th job.\n', sep = '')
	output <- cvFit(i, folds, Y, X)
	cat('Finishing ', i, 'th job.\n', sep = '')
	output # this will become part of the out object
}

length(list)
result[[1]][1:5]

## @knitr future_lapply

library(future.apply)
nCores <- 2
plan(multisession, workers = nCores)

input <- seq_len(nFolds)
input

system.time(
	res <- future_sapply(input, cvFit, folds, Y, X, future.seed = TRUE) 
)
system.time(
	res2 <- sapply(input, cvFit, folds, Y, X)
)

## @knitr

### 5.4 Scenario 4: parallelizing over multiple prediction methods

## @knitr parallel-lapply-no-preschedule

library(future.apply)
nCores <- 4
plan(multisession, workers = nCores)

## specifically designed to be slow when have four cores and 
## and use prescheduling, because
## the slow tasks all assigned to one worker
n <- rep(c(1e7, 1e5, 1e5, 1e5), each = 4)


fun <- function(i) {
    cat("working on ", i, "; ")
    set.seed(i)  # probably ok, but not best practice - more in Section 5.7
    mean(lgamma(exp(rnorm(n[i]))))
}

system.time(fun(1))  # 3 sec.
system.time(fun(5))  # .03 sec.

## Static allocation ##

## default - should do static allocation
system.time(
	res <- future_sapply(seq_along(n), fun, future.seed = TRUE)
)
## this is the default: 1 future (4 tasks) per worker
system.time(
    res <- future_sapply(seq_along(n), fun, future.scheduling = 1,
                         future.seed = TRUE)
)
## 4 tasks per chunk, 1 chunk (1 future) per worker
system.time(
    res <- future_sapply(seq_along(n), fun, future.chunk.size = 4,
                         future.seed = TRUE)
)

## Dynamic allocation ## 

## 4 futures (with one task per future) per worker 
system.time(
    res <- future_sapply(seq_along(n), fun, future.scheduling = 4,
                       future.seed = TRUE)
)
## 1 task per chunk, 4 chunks (4 futures) per worker 
system.time(
    res <- future_sapply(seq_along(n), fun, future.chunk.size = 1,
                         future.seed = TRUE)
)


## @knitr doFuture

library(doFuture)
library(doRNG)

## Specify the machines you have access to and
##    number of cores to use on each:
machines = c(rep("beren.berkeley.edu", 1),
    rep("gandalf.berkeley.edu", 1),
    rep("arwen.berkeley.edu", 2))

## On the SCF, Savio and other clusters using the SLURM scheduler,
## you can figure out the machine names and set up the input to
## the 'workers' argument of 'plan' like this:
## machines <- system('srun hostname', intern = TRUE)

plan(cluster, workers = machines)

registerDoFuture()

fun = function(i, n = 1e6)
  out = mean(rnorm(n))

nTasks <- 120

print(system.time(out <- foreach(i = 1:nTasks) %dorng% {
	outSub <- fun(i)
	outSub # this will become part of the out object
}))



## @knitr lapply-multiple-nodes

system.time(
	res <- future_sapply(input, cvFit, folds, Y, X) 
)

## And just to check we are actually using the various machines:
future_sapply(seq_along(workers), function(i) Sys.getenv('HOST'))

## @knitr

### 5.6 Scenario 6: stratified analysis on a large dataset

## @knitr parallel-copy

do_analysis <- function(i) {
    return(mean(x))
}
x <- rnorm(5e7)  # our big "dataset"

options(future.globals.maxSize = 1e9)

plan(multisession, workers = 4) # new processes - copying!
system.time(tmp <- future_sapply(1:100, do_analysis))  # 9 sec.

## even worse if we dynamically allocate the tasks
system.time(tmp <- future_sapply(1:100, do_analysis,
                                 future.chunk.size = 1)) # 23 sec.


## @knitr parallel-nocopy

plan(multicore, workers = 4)  # forks (where supported, not Windows); no copying!
system.time(tmp <- future_sapply(1:100, do_analysis))  # 6.5 sec.


## @knitr

### 5.7 Scenario 7: Simulation study and parallel RNG

## @knitr RNG-apply

library(future.apply)

fun <- function(i) {
    mean(lgamma(exp(rnorm(100))))
}

nCores <- 4
plan(multisession, workers = nCores)

nSims <- 50
res <- future_sapply(seq_len(nSims), fun, future.seed = 1)



