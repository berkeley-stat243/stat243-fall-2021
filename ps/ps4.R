## @knitr problem2

load('ps4prob2.Rda') # should have A, n, K

ll <- function(Theta, A) {
  sum.ind <- which(A==1, arr.ind=T)
  logLik <- sum(log(Theta[sum.ind])) - sum(Theta)
  return(logLik)
}

oneUpdate <- function(A, n, K, theta.old, thresh = 0.1) { 
  theta.old1 <- theta.old
  Theta.old <- theta.old %*% t(theta.old)
  L.old <- ll(Theta.old, A)
  q <- array(0, dim = c(n, n, K))
  
  for (i in 1:n) {
    for (j in 1:n) {
      for (z in 1:K) {
        if (theta.old[i, z]*theta.old[j, z] == 0){
          q[i, j, z] <- 0
        } else {
          q[i, j, z] <- theta.old[i, z]*theta.old[j, z] /
            Theta.old[i, j]
        }
      }
    }
  }
  theta.new <- theta.old
  for (z in 1:K) {
    theta.new[,z] <- rowSums(A*q[,,z])/sqrt(sum(A*q[,,z]))
  }
  Theta.new <- theta.new %*% t(theta.new)
  L.new <- ll(Theta.new, A)
      converge.check <- abs(L.new - L.old) < thresh
  theta.new <- theta.new/rowSums(theta.new)
  return(list(theta = theta.new, loglik = L.new,
              converged = converge.check)) 
}

# initialize the parameters at random starting values
temp <- matrix(runif(n*K), n, K)
theta.init <- temp/rowSums(temp)

# do single update
out <- oneUpdate(A, n, K, theta.init)


## @knitr problem4-part3

gc() 
tmp <- list()
x <- rnorm(1e7)
tmp[[1]] <- x
tmp[[2]] <- x
.Internal(inspect(tmp))
object.size(tmp)
gc()

## @knitr problem4-part4

n <- 10
myList <- list()
for(i in 1:n) {
    myList[[i]] <- rnorm(20)
}


## @knitr problem5-part1

x <- rnorm(10)
scaler_constructor <- function(input){
	data <- input
	g <- function(param) return(param * data) 
	return(g)
}
scaler <- scaler_constructor(x)
data <- 100
scaler(3)
x <- 100
scaler(3)

## @knitr problem5-part2

x <- rnorm(10)
scaler_constructor <- function(data){
	g <- function(param) return(param * data) 
	return(g)
}
scaler <- scaler_constructor(x)
rm(x)
data <- 100
scaler(3)
