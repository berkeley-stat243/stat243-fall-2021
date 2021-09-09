##################################################
### Demo code for Unit 5 of Stat243, "Programming"
### Chris Paciorek, September 2021
##################################################

#####################################################
# 1: Interacting with the operating system from R
#####################################################


## @knitr system
system("ls -al") 
## knitr/Sweave doesn't seem to show the output of system()
files <- system("ls", intern = TRUE)
files[1:5]


## @knitr file-commands, eval=TRUE
file.exists("unit2-bash.sh")
list.files("../data")


## @knitr list-files
list.files(file.path("..", "data"))


## @knitr sys-info
Sys.info()


## @knitr options
## options()  # this would print out a long list of options
options()[1:5]
options()[c('width', 'digits')]
## options(width = 120)
## often nice to have more characters on screen
options(width = 55)  # for purpose of making pdf of this document
options(max.print = 5000)
options(digits = 3)
a <- 0.123456; b <- 0.1234561
a; b; a == b


## @knitr sessionInfo
sessionInfo()



## @knitr rscript-args, eval=FALSE
args <- commandArgs(TRUE)
## Now args is a character vector containing the arguments.
## Suppose the first argument should be interpreted as a number 
# and the second as a character string and the third as a boolean:
numericArg <- as.numeric(args[1])
charArg <- args[2]
logicalArg <- as.logical(args[3]
cat("First arg is: ", numericArg, "; second is: ", 
   charArg, "; third is: ", logicalArg, ".\n")


## @knitr rscript-run, engine='bash'
./exampleRscript.R 53 blah T
./exampleRscript.R blah 22.5 t
                                           

## @knitr                                           
                                          

#############################################################################
# 3: Text manipulation, string processing and regular expressions (regex)
#############################################################################

### 3.3 Side notes on special characters

## @knitr escape1
tmp <- "Harry said, \"Hi\""
## cat(tmp)   ## prints out without a newline (It's hard to show in the pdf.)
tmp <- "Harry said, \"Hi\".\n"
cat(tmp)
## Harry said, "Hi".

tmp <- c("azar", "foo", "hello\tthere\n")
cat(tmp)
## azar foo hello	there
print(tmp)
## [1] "azar"           "foo"            "hello\tthere\n"
grep("[\tz]", tmp)
## [1] 1 3


## @knitr escape2

## Search for characters that are not 'z'
## (using ^ as regular expression syntax)
grep("[^z]", c("a^2", "93", "zit", "azar", "zzz"))
# [1] 1 2 3 4

## Search for either a '^' (as a regular charcter) or a 'z':
grep("[\\^z]", c("a^2", "93", "zit", "azar", "zzz"))
# [1] 1 2 3 5

## This fails because '\^' is not an escape sequence:
grep("[\^z]", c("a^2", "93", "zit", "azar", "zzz"))
# Error: '\^' is an unrecognized escape in character string starting ""[\^"

## Search for exactly three characters
## (using . as regular expression syntax)
grep("^.{3}$", c("abc", "1234"))
# [1] 1

## Search for a period (as a regular character)
grep("\\.", c("3.9", "27"))
# [1] 1

## This fails because '\.' is not an escape sequence
grep("\.", c("3.9", "27"))
# Error: '\.' is an unrecognized escape in character string starting ""\."

## @knitr escape-challenge
## Suupose we want to use a \ in our string:
cat("hello\nagain")
cat("hello\\nagain")

cat("My Windows path is: C:\\Users\\My Documents.")

## @knitr escape3
## Search for an actual backslash
tmp <- "something \\ other\n"
cat(tmp)
# something \ other

grep("\\\\", tmp)
# [1] 1
grep("\\", tmp)
# Error in grep("\\", tmp) : 
#  invalid regular expression '\', reason 'Trailing backslash'


## @knitr                                           
                                      
#####################################################
# 3: Packages
#####################################################

## @knitr library
library(dplyr)
library(help = dplyr)
## library()  # I don't want to run this on my SCF machine
##  because so many are installed


## @knitr libpaths
.libPaths()
searchpaths()


## @knitr install, eval=FALSE
install.packages('dplyr', lib = '~/Rlibs') # ~/Rlibs needs to exist!


## @knitr install-source, eval=FALSE
install.packages('dplyr_VERSION.tar.gz', repos = NULL, type = 'source')
                                           

## @knitr namespace
search()
## ls(pos = 10) # for the stats package
ls(pos = 10)[1:5] # just show the first few
ls("package:stats")[1:5] # equivalent

                                           
## @knitr
                                          
#############################################################################
# 4: Types, classes, and object-oriented programming
#############################################################################

### 4.1 Types and classes
                                           
## @knitr typeof
devs <- rnorm(5)
class(devs)
typeof(devs)
a <- data.frame(x = 1:2)
class(a)
typeof(a)
is.data.frame(a)
is.matrix(a)
is(a, "matrix")
m <- matrix(1:4, nrow = 2) 
class(m) 
typeof(m)


## @knitr class
bart <- list(firstname = 'Bart', surname = 'Simpson',
             hometown = "Springfield")
class(bart) <- 'personClass'
## it turns out R already has a 'person' class
class(bart)
is.list(bart)
typeof(bart)
typeof(bart$firstname)


## @knitr
                                           
### 4.2 Attributes

## @knitr attr1
x <- rnorm(10 * 365)
attributes(x)
qs <- quantile(x, c(.025, .975))
attributes(qs)
qs
qs[1] + 3

object.size(qs)


## @knitr attr2
names(qs) <- NULL
qs
object.size(qs)

## @knitr attr3
row.names(mtcars)[1:6]
names(mtcars)
attributes(mtcars)
mat <- data.frame(x = 1:2, y = 3:4)
attributes(mat)
row.names(mat) <- c("first", "second")
mat
attributes(mat)
vec <- c(first = 7, second = 1, third = 5)
vec['first']
attributes(vec)


## @knitr                                           

### 4.3 Assignment and coercion                                     


## @knitr assign
mean
x <- 0; y <- 0
out <- mean(x = c(3,7)) # usual way to pass an argument to a function by name
out <- mean(c(3,7))     # or by position
## what does the following do?
out <- mean(x <- c(3,7)) # this is allowable, but confusing
out <- mean(y = c(3,7))  # why doesn't this work?
out <- mean(y <- c(3,7)) # again, allowable, but confusing

## @knitr assign2
## NOT OK, system.time() expects its argument to be a complete R expression:
system.time(out = rnorm(10000)) 
# OK:
system.time(out <- rnorm(10000))


## @knitr assign3
mat <- matrix(c(1, NA, 2, 3), nrow = 2, ncol = 2)
apply(mat, 1, sum.isna <- function(vec) {return(sum(is.na(vec)))})
## What is the side effect of what I have done just above?
apply(mat, 1, sum.isna = function(vec) {return(sum(is.na(vec)))}) # NOPE


## @knitr intL
vals <- c(1, 2, 3)
class(vals)
vals <- 1:3
class(vals)
vals <- c(1L, 2L, 3L)
vals
class(vals)


## @knitr as
as.character(c(1,2,3))
as.numeric(c("1", "2.73"))
as.factor(c("a", "b", "c"))


## @knitr coercion
x <- rnorm(5)
x[3] <- 'hat' # What do you think is going to happen?
indices <- c(1, 2.73)
myVec <- 1:10
myVec[indices]


## @knitr factor-indices
students <- factor(c("basic", "proficient", "advanced",
                     "basic", "advanced", "minimal"))
score <- c(minimal = 3, basic = 1, advanced = 13, proficient = 7)
score["advanced"]
score[students[3]]
score[as.character(students[3])]
                                          
                                           
## @knitr coercion2
n <- 5
df <- data.frame(rep('a', n), rnorm(n), rnorm(n))
apply(df, 1, function(x) x[2] + x[3])
## why does that not work?
apply(df[ , 2:3], 1, function(x) x[1] + x[2])
## let's look at apply() to better understand what is happening


## @knitr
                                           
### 4.4 Object-oriented programming
                                           
### 4.4.1 S3 approach

## @knitr inherit
library(methods)
yb <- sample(c(0, 1), 10, replace = TRUE)
yc <- rnorm(10)
x <- rnorm(10)
mod1 <- lm(yc ~ x)
mod2 <- glm(yb ~ x, family = binomial)
class(mod1)
class(mod2)
is.list(mod1)
names(mod1)
is(mod2, "lm")
methods(class = "lm")


## @knitr s3
yog <- list(firstname = 'Yogi', surname = 'the Bear', age = 20)
class(yog) <- 'bear' 


## @knitr constructor
bear <- function(firstname = NA, surname = NA, age = NA){
	# constructor for 'indiv' class
	obj <- list(firstname = firstname, surname = surname,
                    age = age)
	class(obj) <- 'bear' 
	return(obj)
}
smoke <- bear('Smokey','Bear')


## @knitr s3weird
class(yog) <- "silly"
class(yog) <- "bear"


## @knitr s3methods, eval=FALSE
mod <- lm(yc ~ x)
summary(mod)
gmod <- glm(yb ~ x, family = 'binomial')
summary(gmod)


## @knitr generic
summary
methods(summary)

                                           
## @knitr new-generic
summarize <- function(object, ...) 
	UseMethod("summarize") 


## @knitr class-specific
summarize.bear <- function(object) 
	return(with(object, cat("Bear of age ", age, 
	" whose name is ", firstname, " ", surname, ".\n",
    sep = "")))
summarize(yog)


## @knitr summary, eval=FALSE
out <- summary(mod)
out
print(out)
getS3method(f="print",class="summary.lm")


                                           
## @knitr inherit2
class(yog) <- c('grizzly_bear', 'bear')
summarize(yog) 


## @knitr

### 4.4.2 S4 approach

## @knitr s4
library(methods)
setClass("bear",
	representation(
		name = "character",

		age = "numeric",

		birthday = "Date" 
	)
)
yog <- new("bear", name = 'Yogi', age = 20, 
			birthday = as.Date('91-08-03'))
## next notice the missing age slot
yog <- new("bear", name = 'Yogi', 
	birthday = as.Date('91-08-03')) 
## finally, apparently there's not a default object of class Date
yog <- new("bear", name = 'Yogi', age = 20)
yog
yog@age <- 60


## @knitr s4structured
setValidity("bear",
	function(object) {
		if(!(object@age > 0 && object@age < 130)) 
			return("error: age must be between 0 and 130")
		if(length(grep("[0-9]", object@name))) 
			return("error: name contains digits")
		return(TRUE)
	# what other validity check would make sense given the slots?
	}
)
sam <- new("bear", name = "5z%a", age = 20, 
	birthday = as.Date('91-08-03'))
sam <- new("bear", name = "Z%a B''*", age = 20, 
	birthday = as.Date('91-08-03'))
sam@age <- 150 # so our validity check is not foolproof


## @knitr s4methods
## generic method
setGeneric("isVoter", function(object, ...) {
               standardGeneric("isVoter")
           })
# class-specific method
isVoter.bear <- function(object){
	if(object@age > 17){
		cat(object@name, "is of voting age.\n")
	} else cat(object@name, "is not of voting age.\n")
}
setMethod(isVoter, signature = c("bear"), definition = isVoter.bear)
isVoter(yog)


## @knitr s4inherit
setClass("grizzly_bear",
	representation(
		number_of_people_eaten = "numeric"
	),

	contains = "bear"
)
sam <- new("grizzly_bear", name = "Sam", age = 20, 
   birthday = as.Date('91-08-03'), number_of_people_eaten = 3)
isVoter(sam)
is(sam, "bear")


## @knitr s4tos3
showClass("data.frame")


## @knitr
                                           
### 4.4.3 R6 classes

## @knitr R6class

library(R6)

tsSimClass <- R6Class("tsSimClass",
    ## class for holding time series simulators
    public = list(
        initialize = function(times, mean = 0, corParam = 1){
            library(fields)
            stopifnot(is.numeric(corParam), length(corParam) == 1)
            stopifnot(is.numeric(times))
            private$times <- times
            private$n <- length(times)
            private$mean <- mean
            private$corParam <- corParam
            private$currentU <- FALSE
            private$calcMats()
        },
        
        changeTimes = function(newTimes){
            private$times <- newTimes
            private$calcMats()
        },
        
        getTimes = function(){
            return(private$times)
        },

        print = function(){ # 'print' method
            cat("R6 Object of class 'tsSimClass' with ",
                private$n, " time points.\n", sep = '')
            invisible(self)
        }
    ),

    ## private methods and functions not accessible externally
    private = list(
        calcMats = function() {
            ## calculates correlation matrix and Cholesky factor
            lagMat <- fields::rdist(private$times) # local variable
            corMat <- exp(-lagMat^2 / private$corParam^2)
            private$U <- chol(corMat) # square root matrix
            cat("Done updating correlation matrix and Cholesky factor.\n")
            private$currentU <- TRUE
            invisible(self)
        },
        n = NULL, 
        times = NULL,
        mean = NULL,
        corParam = NULL,
        U = NULL,
        currentU = FALSE
    )
)   

## @knitr R6method
tsSimClass$set("public", "simulate", function() {
    if(!private$currentU)
        private$calcMats()
    ## analogous to mu+sigma*z for generating N(mu, sigma^2)
    return(private$mean + crossprod(private$U, rnorm(private$n)))
})

## @knitr R6use, fig.width=7
master <- tsSimClass$new(1:100, 2, 1)
master
set.seed(1)
## here's a simulated time series
devs <- master$simulate()
plot(master$getTimes(), devs, type = 'l', xlab = 'time',
     ylab = 'process values')
## here's a second simulated time series
devs2 <- master$simulate()
lines(master$getTimes(), devs2, lty = 2)

master2 <- tsSimClass$new(1:100, 2, 3)
set.seed(1)
## here's a simulated time series with a different value of
## the correlation parameter (corParam)
devs <- master2$simulate()
lines(master2$getTimes(), devs, col = 'red')
## That simulated time series is less wiggly because the corParam value
## is larger than before.

mycopy <- master
## 'mycopy' and 'master' are names for the same underlying object
myRealCopy <- master$clone()  # myRealCopy is a true copy and a new object
master$changeTimes(seq(0,1000, length = 100))
master$getTimes()[1:5] # this and 
mycopy$getTimes()[1:5] # this are the same
myRealCopy$getTimes()[1:5] # this is different

                                           
## @knitr R6access, eval=FALSE

## the next line would be dangerous if 'times' were public, since
## changing 'times' should result in changing the correlation matrix and
## changing U.
master$times <- 1:10 


                                           
## @knitr
                                           
#####################################################
# 5: Standard dataset manipulations
#####################################################

### 5.2 Long and wide formats

## @knitr long-wide
long <- data.frame(id = c(1, 1, 2, 2),
                   time = c(1980, 1990, 1980, 1990),
                   value = c(5, 8, 7, 4))
wide <- data.frame(id = c(1, 2),
                   value_1980 = c(5, 7), value_1990 = c(8, 4))
long
wide
                                           

## @knitr dplyr-example

library(dplyr)

cpds <- read.csv(file.path('..', 'data', 'cpds.csv'),
                 stringsAsFactors = FALSE)

cpds2 <- cpds %>% group_by(country) %>%
                  mutate(mean_unemp = mean(unemp))

head(cpds2)

## @knitr dplyr-nse

add_mean <- function(data, group_var, summarize_var) {
    data %>% group_by(group_var) %>%
             mutate(mean_of_var = mean(summarize_var))
}

try(cpds2 <- add_mean(cpds, country, unemp))
try(cpds2 <- add_mean(cpds, 'country', 'unemp'))

## @knitr lm-nse

lm(y ~ x, weights = w, data = mydf)

## @knitr

#####################################################
# 6: Functions, variable scope, and frames
#####################################################

### 6.1 Functions as objects

## @knitr function-object
x <- 3
class(x); typeof(x)

x(2)
x <- function(z) z^2
x(2)
class(x); typeof(x)


## @knitr eval-fun
myFun <- 'mean'; x <- rnorm(10)
eval(as.name(myFun))(x)
                                           

## @knitr fun-as-arg
x <- rnorm(10)

f <- function(fxn, x) {
    fxn(x)
}
f(mean, x)

## lapply/sapply operate similarly
sapply(x, abs)

## @knitr match-fun
f <- function(fxn, x){
	match.fun(fxn)(x) 
}
f("mean", x)
f(mean, x)



## @knitr fun-parts
f1 <- function(x) y <- x^2
f2 <- function(x) {
    y <- x^2
    z <- x^3
    return(list(y, z))
}
class(f1)
body(f2)
typeof(body(f1)); class(body(f1))
typeof(body(f2)); class(body(f2))


## @knitr do-call
myList <- list(a = 1:3, b = 11:13, c = 21:23)
args(rbind)
rbind(myList$a, myList$b, myList$c)
rbind(myList)
do.call(rbind, myList)


## @knitr do-call2
do.call(mean, list(1:10, na.rm = TRUE))


## @knitr
                                           
### 6.2 Inputs

## @knitr args
args(lm)

## @knitr args-req
print(sum)
sum()
print(quantile)
quantile()

## @knitr args-req2

x <- 1
y <- 2
myfun <- function(x) {
    print(y)
    print(x)
}
myfun()

## @knitr dots
pplot <- function(x, y, pch = 16, cex = 0.4, ...) {
	plot(x, y, pch = pch, cex = cex, ...)
}


## @knitr dots-list
myFun <- function(...){
  print(..2) 
  args <- list(...)
  print(args[[2]])
}
myFun(1,3,5,7)


## @knitr dgamma
args(dgamma)


## @knitr funs-as-args
mat <- matrix(1:9, 3)
apply(mat, 1, min)  # apply() uses match.fun()
apply(mat, 2, function(vec) vec - vec[1])
apply(mat, 1, function(vec) vec - vec[1]) 
## explain why the result of the last expression is transposed


## @knitr formals
f <- function(x, y = 2, z = 3 / y) { x + y + z }
args(f)
formals(f)
class(formals(f))


## @knitr match-call
match.call(definition = mean, 
  call = quote(mean(y, na.rm = TRUE))) 
## what do you think quote does? Why is it needed?
                                           
                                           
## @knitr
                                           
### 6.3 Outputs

## @knitr return
f <- function(x) { 
    if(x < 0) {
        return(-x^2)
    } else res <- x^2
}
f(-3)
f(3)


## @knitr invisible
f <- function(x){ invisible(x^2) }
f(3)
a <- f(3)
a


## @knitr return-list
mod <- lm(mpg ~ cyl, data = mtcars)
class(mod)
is.list(mod)
                                           

## @knitr
                                           
### 6.4 Frames and the call stack

## @knitr frames, eval=FALSE
## NOTE: run this chunk outside RStudio as RStudio seems to
##       inject additional frames
sys.nframe()
f <- function() {
	cat('in f: Frame number is ', sys.nframe(),
            '; parent frame number is ', sys.parent(), '.\n', sep = '')
	cat('in f: Frame (i.e., environment) is: ')
	print(sys.frame(sys.nframe()))
	cat('in f: Parent is ')
	print(parent.frame())
	cat('in f: Two frames up is ')
	print(sys.frame(-2))
}
f()
ff <- function() {
	cat('in ff: Frame (i.e., environment) is: ')
	print(sys.frame(sys.nframe()))
	cat('in ff: Parent is ')
	print(parent.frame())	
	f()
}
ff() 


## @knitr frames2, eval=FALSE
## exploring functions that give us information the frames in the stack

## Here's a recursive function, so we'll get a lot of function calls on the stack
g <- function(y) {
    if(y > 0) g(y-1) else gg()
}

## Ultimately, gg() is called, and it prints out info about the call stack
gg <- function() {
    ## this gives us the information from sys.calls(),
    ##   sys.parents() and sys.frames() as one object
    ## Rather than running print(sys.status()),
    ## which would involve adding print() to the call stack,
    ## we'll run sys.status and then print the result out.
    tmp <- sys.status()
    print(tmp)
}

g(3)



                                           
## @knitr
                                           
                                           
### 6.5 Approaches to passing arguments to functions

### 6.5.1 Pass by value vs. pass by reference

## @knitr par, eval=FALSE
f <- function(){
	oldpar <- par()
	par(cex = 2)
	# body of code
	par() <- oldpar
}
                                          


## @knitr
                                           
### 6.5.2 Promises and lazy evaluation

## @knitr lazy-eval, eval=FALSE
f <- function(a, b = d) {
	d <- log(a); 
	return(a*b)
}
f(7)

d <- 100
f(7)
                                           

## @knitr lazy-eval2
f <- function(x) print("hi")
system.time(mean(rnorm(1000000)))
system.time(f(3))
system.time(f(mean(rnorm(1000000)))) 


## @knitr args-eval
z <- 3
x <- 100
f <- function(x, y = x*3) {x+y}
f(z*5)


## @knitr

### 6.6 Variable scope

## @knitr scope-example
f <- function(y) {
  return(x + y)
}
f(3)


## @knitr enclosing, eval=FALSE
x <- 3
f <- function() {x <- x^2; print(x)}
f()
x # what do you expect?
f <- function() { assign('x', x^2, env = .GlobalEnv) } 
## careful: could be dangerous as a variable is changed as a side effect
f()
x
f <- function(x) { x <<- x^2 }
## careful: could be dangerous as a variable is changed as a side effect
f(5)
x

                                           
## @knitr scope, eval=FALSE
x <- 3
f2 <- function() print(x)
f <- function() {
    x <- 7
    f2()
}
f() # what will happen?

x <- 3
f <- function() {
    f2 <- function() { print(x) }
    x <- 7
    f2()
}
f() # what will happen?

x <- 3
f <- function() { 
    f2 <- function() { print(x) }
    f2()
} 
f() # what will happen?

                                           
## @knitr scope-tricky
y <- 100
fun_constructor <- function(){
	y <- 10
	g <- function(x) {
            return(x + y)
        }
	return(g)
}
## fun_constructor() creates functions
myfun <- fun_constructor()
myfun(3)


## @knitr scope-envts
environment(myfun)  # enclosing environment of h()
ls(environment(myfun)) # objects in that environment
fun_constructor <- function(){
	print(environment()) # execution environment of fun_constructor()
	y <- 10
	g <- function(x) x + y
	return(g)
}
myfun <- fun_constructor()
environment(myfun)
myfun(3)
environment(myfun)$y
## advanced: explain this:
environment(myfun)$g

                                           
## @knitr scope-problem
set.seed(1) 
rnorm(1) 
save(.Random.seed, file = 'tmp.Rda') 
rnorm(1)
tmp <- function() { 
  load('tmp.Rda') 
  print(rnorm(1)) 
}
tmp()

## @knitr findGlobals

library(codetools)
f <- function() {
    y <- 3
    print(x + y)
}
findGlobals(f)

                                           
## @knitr
                                           
### 6.7 Environments and the search path

## @knitr search
search()
searchpaths()

                                           
## @knitr nested-env
x <- environment(lm)
while (environmentName(x) != environmentName(emptyenv())) {
	print(environmentName(x))
	x <- parent.env(x) # enclosing env't, NOT parent frame!
}


library(pryr)
x <- environment(lm)
parenvs(x, all = TRUE)  

                                           
## @knitr get
lm <- function() {return(NULL)} # this seems dangerous but isn't
x <- 1:3; y <- rnorm(3); mod <- lm(y ~ x)
mod <- get('lm', pos = 'package:stats')(y ~ x)
mod <- stats::lm(y ~ x) # an alternative
## :: is the namespace resolution operator
rm(lm)
mod <- lm(y ~ x)

## @knitr
                                           
### 6.8 Alternatives to pass by value in R

## @knitr closures
x <- rnorm(10)
scaler_constructor <- function(input){
	data <- input
	g <- function(param) return(param * data) 
	return(g)
}
scaler <- scaler_constructor(x)
rm(x) # to demonstrate we no longer need x
scaler(3)
x <- rnorm(1e7)
scaler <- scaler_constructor(x)
object.size(scaler) # hmmm
object.size(environment(scaler)$data)

library(pryr)
object_size(scaler) # that's better!


## @knitr closure-boot
make_container <- function(n) {
	x <- numeric(n)
	i <- 1
	
	function(value = NULL) {
		if (is.null(value)) {
			return(x)
		} else {
			x[i] <<- value
			i <<- i + 1
		}	 
	}
}
nboot <- 100
bootmeans <- make_container(nboot)
data <- faithful[ , 1] # Old Faithful geyser eruption lengths
for (i in 1:nboot)
	bootmeans(mean(sample(data, length(data),
      replace=TRUE)))
## this will place results in x in the function env't and you can grab it out as
bootmeans()
                                           

## @knitr with
x <- rnorm(10)
myFun2 <- with(list(data = x), function(param) return(param * data))
rm(x)
myFun2(3)
x <- rnorm(1e7)
myFun2 <- with(list(data = x), function(param) return(param * data))
object_size(myFun2)

                                           
## @knitr

### 6.9 Creating and working in an environment
                                           
## @knitr new.env
e <- new.env()
assign('x', 3, envir = e) # same as e$x <- 3
e$x
get('x', envir = e, inherits = FALSE) 
## the FALSE avoids looking for x in the enclosing environments
e$y <- 5
ls(e)
rm('x', envir = e)
parent.env(e)


## @knitr envt-container
myWalk <- new.env(); myWalk$pos = 0
nextStep <- function(walk) walk$pos <- walk$pos +
    sample(c(-1, 1), size = 1)
nextStep(myWalk)

                                           
## @knitr eval-in-env
eval(quote(pos <- pos + sample(c(-1, 1), 1)), envir = myWalk)
evalq(pos <- pos + sample(c(-1, 1), 1), envir = myWalk) 



## @knitr

### 6.10 Operators
                                           
## @knitr operators, tidy=FALSE
a <- 7; b <- 3
# let's think about the following as a mathematical function
#  -- what's the function call?
a + b 
`+`(a, b)


## @knitr pass-operator
x <- 1:3; y <- c(100,200,300)
outer(x, y, `+`)

myList <- list(list(state = 'new york', value = 1:5),
               list(state = 'california', value = 6:10),
               list(state = 'delaware', value = 11:15))

result <- lapply(myList, `[[`, 2)
result
## note that the index "2" is the additional argument to the [[ function
myMat <- sapply(myList, `[[`, 2)
myMat
cbind(myList[[1]][[2]], myList[[2]][[2]])  ## equivalent but doesn't scale


## @knitr define-operator
`%+%` <- function(a, b) paste0(a, b, collapse = '')
"Hi " %+% "there"
                                           

## @knitr operator-args
mat <- matrix(1:4, 2, 2)
mat[ , 1] 
mat[ , 1, drop = FALSE] # what's the difference?

## @knitr class-operators
yog <- list(firstname = 'Yogi', surname = 'the Bear', age = 20)
class(yog) <- 'bear' 

methods(`+`)
`+.bear` <- function(object, incr) {
	object$age <- object$age + incr
	return(object)
}
older_yog <- yog + 15

older_yog


## @knitr
                                           
### 6.11 Unexpected functions and replacement functions

## @knitr all-is-fun, eval = FALSE
if(x > 27){
	print(x)	
} else{
	print("too small") 
}


## @knitr replace-funs, eval = FALSE
diag(mat) <- c(3, 2)
is.na(vec) <- 3
names(df) <- c('var1', 'var2')


## @knitr replace-funs2
mat <- matrix(rnorm(4), 2, 2)
diag(mat) <- c(3, 2)
mat <- `diag<-`(mat, c(10, 21))
base::`diag<-`
                                           

## @knitr create-replace
yog <- list(firstName = 'Yogi', lastName = 'Bear')
`firstName<-` <- function(obj, value){
  obj$firstName <- value
  return(obj)
}
firstName(yog) <- 'Yogisandra'

## @knitr replacement
`age<-` <- function(x, ...) UseMethod("age<-")

`age<-.bear` <- function(object, value){ 
	object$age <- value
	return(object)
}
age(older_yog) <- 60

older_yog
                                     
## @knitr

#####################################################
# 7: Efficiency
#####################################################

### 7.2 Other approaches to speeding up R                  

### 7.2.2 Byte compiling

## @knitr byte
library(compiler); library(rbenchmark)
f <- function(vals){
    x <- as.numeric(NA)
    length(x) <- length(vals)
    for(i in seq_along(vals)) x[i] <- exp(vals[i])
    return(x)
}
fc <- cmpfun(f)
fc # notice the indication that the function is byte compiled.
x <- rnorm(100000)
benchmark(f(x), fc(x), y <- exp(x), replications = 5)

## @knitr

### 7.3 Challenges                  
                  
## @knitr mixture-example
lik <- matrix(as.numeric(NA), nr = n, nc = p)
for(j in 1:p) lik[ , j] <- dnorm(y, mns[j], sds[j])

## @knitr mixed-membership

load('mixedMember.Rda')

wgtsB[1:5]
IDsB[1:5]

f1 <- function(wgts, IDs, mu)   
	sapply(seq_along(wgts), function(i) sum(mu[IDs[[i]]]*wgts[[i]])) 

f1(wgtsB, IDsB, muB) 


## @knitr challenge5

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


# in the real code, oneUpdate was called repeatedly in a while loop
# as part of an iterative optimization to find a maximum likelihood estimator
 

## @knitr challenge6

logLik <- function(k, n, p, phi) {
  klogk <- ifelse(k == 0, 0, k*log(k))
  nmklognmk <- ifelse(n-k == 0, 0, (n-k)*log(n-k))
  exp(lchoose(n, k) + klogk + nmklognmk - n*log(n) + phi*(n*log(n) - klogk - nmklognmk) + k*phi*log(p) + (n-k)*phi*log(1-p))
}



## @knitr challenge7

PIKK <- function(n, k) {
    ## return indices of the sample of size k
    sort(runif(n), index.return = TRUE)$ix[1:k]
}

FYKD <- function(n, k) {
    indices <- seq_len(n)
    for(i in 1:n) {
        j = sample(i:n, 1)
        tmp <- indices[i]
        indices[i] <- indices[j]
        indices[j] <- tmp
    }
    return(indices[1:k])
}

## @knitr challenge8

n <- 100000
p <- 5  ## number of categories

## way to generate a random matrix of row-normalized probabilities:
tmp <- exp(matrix(rnorm(n*p), nrow = n, ncol = p))
probs <- tmp / rowSums(tmp)

smp <- rep(0, n)

## loop by row and use sample()
set.seed(1)
system.time(
    for(i in seq_len(n))
        smp[i] <- sample(p, 1, prob = probs[i, ])
)

                  
## @knitr                  
                                           
#####################################################
# 8: Evaluating memory use
#####################################################

### 8.2 Monitoring overall memory use

                                           
## @knitr gc
rm(x)
gc(reset = TRUE)
x <- rnorm(1e8) # should use about 800 Mb
object.size(x)
object_size(x)  # from pryr
gc()
mem_used() # from pryr
rm(x)
gc() # note the "max used" column is unchanged
mem_change(x <- rnorm(1e8)) # from pryr
mem_change(x <- rnorm(1e7))


## @knitr ls-sizes
ls.sizes <- function(howMany = 10, minSize = 1){
	pf <- parent.frame()
	obj <- ls(pf) # or ls(sys.frame(-1)) 
	objSizes <- sapply(obj, function(x) {
                               pryr::object_size(get(x, pf))
                           })
	## or sys.frame(-4) to get out of FUN, lapply(), sapply() and sizes()
	objNames <- names(objSizes)
	howmany <- min(howMany, length(objSizes))
	ord <- order(objSizes, decreasing = TRUE)
	objSizes <- objSizes[ord][1:howMany]
	objSizes <- objSizes[objSizes > minSize]
	objSizes <- matrix(objSizes, ncol = 1)
	rownames(objSizes) <- objNames[ord][1:length(objSizes)]
	colnames(objSizes) <- "bytes"
	cat('object')
	print(format(objSizes, justify = "right", width = 11),
              quote = FALSE)
}


## @knitr serialize


## size of a closure
x <- rnorm(1e7)
f <- function(input){
	data <- input
	g <- function(param) return(param * data) 
	return(g)
}
myFun <- f(x)
rm(x)
object.size(myFun)
object_size(myFun)
length(serialize(myFun, NULL))
## note that our discussion of copy-on-change will tell us
## why the 80 MB vs. 160 MB disagreement occurs

## size of an environment
e <- new.env()
e$x <- rnorm(1e7)
object.size(e)
object_size(e)
length(serialize(e, NULL))

## @knitr inspect
x <- rnorm(5)
.Internal(inspect(x))
obj <- list(a = rnorm(5), b = list(d = "adfs"))
.Internal(inspect(obj$a))
.Internal(inspect(obj))

                                           
## @knitr pryr-address
obj <- list(a = rnorm(5), b = list(d = "adfs"))
address(x)  # from pryr
address(obj)
address(obj$a) # doesn't work



## @knitr sequences

library(microbenchmark)

n <- 1e6
microbenchmark(tmp <- 1:n)
object.size(tmp)  # incorrect as of R 3.5
object_size(tmp)  # incorrect as of R 3.5
mem_change(mySeq <- 1:n)
length(serialize(mySeq, NULL)) 

## @knitr hidden3, eval=FALSE
x <- rnorm(1e7)
y <- x[1:(length(x) - 1)]


## @knitr
                                           
### 8.4 Hidden uses of memory

## @knitr hidden1, eval=FALSE
rm(x)
gc(reset = TRUE)

x <- rnorm(1e7)
gc()
dim(x) <- c(1e4, 1e3)
diag(x) <- 1
gc()

                                           
## @knitr hidden2, eval=TRUE
rm(x)
gc(reset = TRUE)

x <- rnorm(1e7)
address(x)
gc()
x[5] <- 7
## When run plainly in R, should be the same address as before,
## indicating no copy was made. Knitting the doc messes the
## result up!
address(x)
gc()

## @knitr
                                                                                     
### 8.5 Delayed copying (copy-on-change)

## @knitr copy-on-change-fun, eval=TRUE
rm(y)
gc(reset = TRUE)

f <- function(x){
	print(gc())
	.Internal(inspect(x))
	return(x)
}
y <- rnorm(1e7)
gc()
.Internal(inspect(y))
out <- f(y)
.Internal(inspect(y))
.Internal(inspect(out))



## @knitr copy-on-change, eval=TRUE
rm(y)
gc(reset = TRUE)

y <- rnorm(1e7)
gc()
address(y)
x <- y
gc()
object_size(x, y)  # from pryr
address(x)
x[1] <- 5
gc()
address(x)
object_size(x, y)
rm(x)
x <- y
address(x)
address(y)
y[1] <- 5
address(x)
address(y)


## @knitr copy-mem-change-question
library(pryr)
rm(x)
rm(y)
mem_change(x <- rnorm(1e7))
address(x)
mem_change(x[3] <- 8)
address(x)
mem_change(y <- x)
address(y)
mem_change(x[3] <- 8)
address(x)
address(y)



## @knitr named-r4
a <- rnorm(5)
## .Internal(inspect(a))  ##  see below for result in R 4.0
## @556accc65948 14 REALSXP g0c4 [REF(1)] (len=5, tl=0) 0.524365,0.55554,0.700011,-0.621318,-0.924413
## refs(a)
## [1] 1
address(a)
## [1] "0x556accc65948"
b <- a
## .Internal(inspect(b))  ##  see below for result in R 4.0
## @556accc65948 14 REALSXP g0c4 [REF(2)] (len=5, tl=0) 0.524365,0.55554,0.700011,-0.621318,-0.924413
## refs(a)
## [1] 2
## refs(b)
## [1] 2
address(b)
# [1] "0x556accc65948"

a[2] <- 0
## .Internal(inspect(a))
## @556accc657f8 14 REALSXP g0c4 [REF(1)] (len=5, tl=0) 0.524365,0,0.700011,-0.621318,-0.924413
## .Internal(inspect(b))
## @556accc65948 14 REALSXP g0c4 [REF(1)] (len=5, tl=0) 0.524365,0.55554,0.700011,-0.621318,-0.924413

a <- rnorm(5)
b <- a
## refs(a)
## [1] 2
rm(b)
## refs(a)
## [1] 1
                                           
## @knitr tracemem
a <- 1:10     
tracemem(a)      
## b and a share memory      
b <- a      
b[1] <- 1  
## result when done through knitr is not as in plain R   
untracemem(a)   
address(a)
address(b)

rm(x, y)
f <- function(x) sum(x^2)
y <- rnorm(10)
## result of next line should be 1 if executed in clean R session
## refs(y)  # knitting contaminates the result here

f(y)
## refs(y)  # knitting contaminates the result here
address(y)
y[3] <- 2
address(y)



## @knitr memuse1
x <- rnorm(1e7) 
myfun <- function(y){ 
	z <- y 
	return(mean(z)) 
} 
myfun(x)


## @knitr memuse2
x <- rnorm(1e7)
x[1] <- NA
myfun <- function(y){ 
	return(mean(y, na.rm = TRUE))
}
myfun(x)

                                           
## @knitr
                                           
### 8.7 Passing objects to compiled code

## @knitr casts, eval=FALSE
f <- function(arg1){
	print(address(arg1))
	return(mean(arg1))
}
x <- rnorm(10)
class(x)
debug(f)
f(x)
f(as.numeric(x))
f(as.integer(x))

                                           
## @knitr pass-to-C
library(inline) 
src <- '
  for (int i = 0; i < *n; i++) {
    x[i] = exp(x[i]);
  }
'
sillyExp <- cfunction(signature(n = "integer", x = "numeric"),
	src, convention = ".C")
## sillyExp <- cfunction(signature(n = "integer", x = "numeric"),
##    src, convention = ".C")
len <- as.integer(100)  # or 100L
vals <- rnorm(len)
vals[1]
out1 <- sillyExp(n = len, x = vals)
address(vals)
.Internal(inspect(out1))
.Internal(inspect(out1$x))


## @knitr

### 8.9 Example

## @knitr memuse-real, eval = FALSE
fastcount <- function(xvar, yvar) {
    print(xvar[1])
    print(yvar[1])
    naline <- is.na(xvar)
    naline[is.na(yvar)] = TRUE
    xvar[naline] <- 0
    yvar[naline] <- 0
    useline <- !naline
    ## We'll ignore the rest of the code.
    ## Table must be initialized for -1's
    tablex <- numeric(max(xvar)+1)
    tabley <- numeric(max(yvar)+1)
    stopifnot(length(xvar) == length(yvar))
    res <- .C("fastcount",PACKAGE="GCcorrect",
              tablex = as.integer(tablex), tabley = as.integer(tabley),
              as.integer(xvar), as.integer(yvar), as.integer(useline),
              as.integer(length(xvar)))
    xuse <- which(res$tablex>0)
    xnames <- xuse - 1
    resb <- rbind(res$tablex[xuse], res$tabley[xuse]) 
    colnames(resb) <- xnames
    return(resb)
}


                                           
## @knitr
                                           
                                           
#####################################################
# 9: Computing on the language
#####################################################

### 9.1 The R interpreter

## @knitr internal-funs
plot.xy # plot.xy() is called by plot.default()
print(`%*%`)

                                           
## @knitr
                                           
### 9.2 Parsing code and understanding language objects

## @knitr quote, tidy=FALSE
obj <- quote(if (x > 1) "orange" else "apple")
as.list(obj)
class(obj)
weirdObj <- quote(`if`(x > 1, 'orange', 'apple'))
identical(obj, weirdObj)

                                           
## @knitr type-quote
x <- 3; typeof(quote(x))

                                           
## @knitr expr
myExpr <- expression(x <- 3)
eval(myExpr)
typeof(myExpr)


## @knitr parsing
a <- quote(x <- 5)
b <- expression(x <- 5, y <- 3)
d <- quote({x <- 5; y <- 3})
class(a)
class(b)
b[[1]]
class(b[[1]])
identical(a, b[[1]])
identical(d[[2]], b[[1]])

                                           
## @knitr lang-objects, tidy=FALSE
e0 <- quote(3)
e1 <- expression(x <- 3) 
e1m <- expression({x <- 3; y <- 5}) 
e2 <- quote(x <- 3) 
e3 <- quote(rnorm(3))
print(c(class(e0), typeof(e0)))
print(c(class(e1), typeof(e1)))
print(c(class(e1[[1]]), typeof(e1[[1]])))
print(c(class(e1m), typeof(e1m)))
print(c(class(e2), typeof(e2)))
identical(e1[[1]], e2)
print(c(class(e3), typeof(e3)))
e4 <- quote(-7)
print(c(class(e4), typeof(e4))) # huh? what does this imply?
as.list(e4)


## @knitr eval-lang
rm(x)
eval(e1)
rm(x)
eval(e2)
e1mlist <- as.list(e1m)
e2list <- as.list(e2)
eval(as.call(e2list)) 
## here's how to do it if the language object is actually an expression (multiple statements)
eval(as.expression(e1mlist))


## @knitr expr-structure
e1 <- expression(x <- 3) 
## e1 is one-element list with the element an object of class '<-' 
print(c(class(e1), typeof(e1)))
e1[[1]]
as.list(e1[[1]])
lapply(e1[[1]], class)
y <- rnorm(5)
e3 <- quote(mean(y))
print(c(class(e3), typeof(e3)))
e3[[1]] 
print(c(class(e3[[1]]), typeof(e3[[1]])))
e3[[2]]
print(c(class(e3[[2]]), typeof(e3[[2]])))
## we have recursion
e3 <- quote(mean(c(12,13,15) + rnorm(3)))
as.list(e3)
as.list(e3[[2]])
as.list(e3[[2]][[3]])
library(pryr)
call_tree(e3)


                                           
## @knitr
                                           
### 9.3 Manipulating the parse tree

## @knitr manip-expr
out <- quote(y <- 3)
out[[3]] <- 4
eval(out)
y


## @knitr manip-expr2
e1 <- quote(4 + 5)
e2 <- quote(plot(x, y))
e2[[1]] <- `+`
eval(e2)
e1[[3]] <- e2
e1
class(e1[[3]]) # note the nesting
eval(e1) # what should I get?


                                           
## @knitr deparse
codeText <- deparse(out)
parsedCode <- parse(text = codeText) 
## parse() works like quote() except on the code in the form of a string
eval(parsedCode)
deparse(quote(if (x > 1) "orange" else "apple"))


## @knitr manip-names
x3 <- 7
i <- 3
as.name(paste('x', i, sep=''))
eval(as.name(paste('x', i, sep='')))
assign(paste('x', i, sep = ''), 11)
x3


## @knitr
                                           
### 9.4 Parsing replacement expressions

## @knitr replace-lang
animals <- c('cat', 'dog', 'rat','mouse')
out1 <- quote(animals[4] <- 'rat') 
out2 <- quote(`<-`(animals[4], 'rat')) 
out3 <- quote('[<-'(animals,4,'rat')) 
as.list(out1)
as.list(out2)
identical(out1, out2)
as.list(out3)
identical(out1, out3)
typeof(out1[[2]]) # language
class(out1[[2]]) # call


## @knitr replace-lang2
eval(out1)
animals
animals[4] <- 'mouse'  # reset things to original state
eval(out3) 
animals # both do the same thing
                                           

## @knitr
                                           
### 9.5 substitute()

## @knitr substitute
identical(quote(z <- x^2), substitute(z <- x^2))


## @knitr substitute2
e <- new.env(); e$x <- 3
substitute(z <- x^2, e)


## @knitr crazy-subst
e$z <- 5
substitute(z <- x^2, e)
                                          

## @knitr subst-example
f <- function(obj){
objName <- deparse(substitute(obj))
print(objName)
}
f(y)


## @knitr subst3
substitute(a + b, list(a = 1, b = quote(x)))


## @knitr subst4
e1 <- quote(x + y)
e2 <- substitute(e1, list(x = 3))


## @knitr double-subst
e2 <- substitute(substitute(e, list(x = 3)), list(e = e1))
substitute(substitute(e, list(x = 3)), list(e = e1)) 
## so e1 is substituted as an evaluated object, 
## which then allows for substitution for 'x' 
e2
eval(e2)
substitute_q(e1, list(x = 3))  # from pryr

                                           

