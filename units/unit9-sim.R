################################################################
### Demo code for Unit 9 of Stat243, "Simulation"
### Chris Paciorek, October 2021
################################################################

#########################################
# 4: Random number generation
#########################################

### 4.1 Generating random uniforms on a computer

## @knitr linear-cong

n <- 100
a <- 171
m <- 30269
u <- rep(NA, n) 
u[1] <- 7306 
for(i in 2:n)
  u[i] <- (a * u[i-1]) %% m 
u <- u/m
uFromR <- runif(n) 
par(mfrow = c(2,2)) 
plot(1:n, u, type = 'l') 
plot(1:n, uFromR, type = 'l') 
hist(u, nclass = 25) 
hist(uFromR, nclass = 25)

## @knitr Wichmann

RNGkind("Wichmann-Hill")
set.seed(1)
saveSeed <- .Random.seed
uFromR <- runif(10)
a <- c(171, 172, 170)
m <- c(30269, 30307, 30323)
xyz <- matrix(NA, nr = 10, nc = 3)
xyz[1, ] <- (a * saveSeed[2:4]) %% m
for( i in 2:10)
	xyz[i, ] <- (a * xyz[i-1, ]) %% m
for(i in 1:10)
	print(c(uFromR[i],sum(xyz[i, ]/m)%%1))
## we should be able to recover the current value of the seed
xyz[10, ]
.Random.seed[2:4]

## @knitr blank

### 4.3 RNG in R 

## @knitr seed

set.seed(1)
rnorm(10)
set.seed(1)
rnorm(10)

## @knitr seed-save

set.seed(1)
rnorm(5)
savedSeed <- .Random.seed
rnorm(5)
tmp <- sample(1:50, 2000, replace = TRUE)
.Random.seed <- savedSeed
rnorm(5)

## @knitr seed-restore

f <- function(args) {
  oldseed <- .Random.seed
  ## other code 
  .Random.seed <<- oldseed # note global assignment!
}

## @knitr blank

###################################
# 5: Generating random variables
###################################

### 5.1 Multivariate distributions

## @knitr mvnorm

U <- chol(covMat)
crossprod(U, rnorm(nrow(covMat)))

## @knitr blank

### 5.3 Rejection sampling

## generating efficiently from a truncated normal

## suppose we want to generate from X ~ N(1, 2^2) I(x > 4)

mu <- 1; sd <- 2
tau <- 4 # truncation point
samps <- rnorm(10000, mu, sd)
samps <- samps[samps > tau]
length(samps)/10000  # around 640 of 10000
hist(samps)


tauStd <- (tau - mu)/sd  # put trunc. pt on standardized scale
lamStar <- (tauStd + sqrt(tauStd^2+4))/2 # rate of exponential
c <- (1/lamStar)*exp(lamStar^2/2 - lamStar*tauStd)/(sqrt(2*pi)*(1-pnorm(tauStd)))

y <- rexp(2000, rate = lamStar) + tauStd  # + tauStd does the shifting of the exponential
u <- runif(2000)
samps2 <- mu + sd * y[u <= exp(-(y-lamStar)^2/2)]  # mu + sd part reverses the standardization
length(samps2)/2000 # empirical acceptance rate
1/c  # theoretical acceptance rate

## plots here are done on the standardized scale for simplicity
par(mfrow = c(1,3))

## this shows f(x) and c*g(x) on the standardized scale
yvals <- seq(tauStd, 5, len = 100)
plot(yvals, c*dexp(yvals - tauStd, rate = lamStar), type = 'l')
lines(yvals, dnorm(yvals)/(1-pnorm(tauStd)), col = 'red')
legend('topright', lty=c(1,1), col=c('red','black'),
       legend = c('f(x)', 'c*g(x)'))
## exp is a nice envelope

yvals <- seq(5, 10, len = 100)
plot(yvals, c*dexp(yvals - tauStd, rate = lamStar), type = 'l')
lines(yvals, dnorm(yvals)/(1-pnorm(tauStd)), col = 'red')
## in tail, exp is much fatter than normal, but few proposals are in tail anyway

plot(y, u, pch = 16)
points(y[u <= exp(-(y-lamStar)^2/2)], u[u <= exp(-(y-lamStar)^2/2)], col = 'red', pch = 16)  # we accept red points and reject black

### 5.5 Importance sampling


## suppose we want to estimate P(X < -3) for a Cauchy (this is of interest in the case where we don't have the CDF in closed form)
## instead of drawing from a standard Cauchy, let's draw from a Cauchy shifted to be centered at -5

## write out the code below for a single estimate

m <- 1000 # number of samples for each estimator
## standard MC estimator
set.seed(1)
y <- rt(m, df = 1)
## samples for importance sampler
set.seed(1)
x <- rt(m, df = 1) - 5  # i.e sample from g(x) being a Cauchy centered at -5
f <- dt(x, df = 1)  # density of x under f
g <- dt(x + 5, df = 1)  # density of x under g (density of x under a Cauchy centered at -5 is the same as density of x+5 under Cauchy centered at 0)
w <- f/g  # weights

stdEst <- mean(y < (-3))
isEst <- mean((x < (-3))*w) # i.e. (1/m)*sum((x < (-3))*w)

## now let's do a small simulation study of the estimator

nSims <- 100

m <- 1000 # number of samples for each estimator

isEst <- stdEst <- varIS <- varStd <- rep(NA, nSims)
set.seed(1)
for(i in 1:nSims){  # a small simulation study of the approach with m = 1000
  ## note this could be done w/out looping if I were trying to be efficient

  ## samples for MC estimator

  y <- rt(m, df = 1)

  ## samples for importance sampler
  set.seed(1)
  x <- rt(m, df = 1) - 5  # i.e sample from g(x) being a Cauchy centered at -5
  f <- dt(x, df = 1)  # density of x under f
  g <- dt(x + 5, df = 1)  # density of x under g (density of x under a Cauchy centered at -5 is the same as density of x+5 under Cauchy centered at 0)
  w <- f/g  # weights
  
  isEst[i] <- mean((x < (-3))*w)
  stdEst[i] <- mean(y < (-3))
}

mean((isEst - pt(-3, df = 1))^2)  # variance of IS estimator based on entire sim study
mean((stdEst - pt(-3, df = 1))^2)  # variance of standard MC estimator based on entire sim study
## order of magnitude gain in efficiency



############################################
# 4: Design of simulation studies
############################################

# 4.2 Overview

## @knitr tvsnormal

devs <- rnorm(100)
tdevs <- qt(pnorm(devs), df = 1)
plot(devs, tdevs)
abline(0,1)

## @knitr blank

##############################################
# 5: Implementation of simulation studies
##############################################

## @knitr expand.grid

require(fields)
thetaLevels <- c("low", "med", "hi")
n <- c(10, 100, 1000)
tVsNorm <- c("t", "norm")
levels <- expand.grid(thetaLevels, tVsNorm, n)
## example of replicate() -- generate m sets correlated normals
set.seed(1)
genFun <- function(n, theta = 1){
	u <- rnorm(n)
	x <- runif(n)
	Cov <- exp(-rdist(x)/theta)
	U <- chol(Cov)
	return(cbind(x,crossprod(U, u)))
}
m <- 20
simData <- replicate(m, genFun(100, 1))
dim(simData) # 100 observations by {x, y} values by 20 replicates


