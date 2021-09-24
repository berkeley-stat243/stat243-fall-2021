# a solution
my_data <- read.csv('./data.csv')

logitBoot <- function(y, x, n_boot = 2000) {
  set.seed(5)
  
  # do n_boot random permutations of x and y and return coefficient on x with 
  # the myGLM function
  boot_coefs <- sapply(seq_len(n_boot), myGLM, y, x) 
  
  # remove any computations that led to a warning from glm (i.e. a NULL value)
  boot_coefs <- unlist(boot_coefs)
  
  # compute standard deviation of those estimates and return
  boot_se <- sd(boot_coefs)
  return(boot_se)
}

myGLM <- function(i, y, x) {
  n <- length(y)
  
  # randomly sample with replacement the observations from the data
  boot_sample <- sample(seq_len(n), n, replace = TRUE)
  
  # create vectors of the bootstrapped samples
  x_boot <- x[boot_sample]
  y_boot <- y[boot_sample]
  
  out <- tryCatch(
    {
      # R  will try to excecute this and see if there is an error or warning
      mod_boot <- glm(y_boot ~ x_boot, family = 'binomial')
      mod_boot$coef[2]
    }, 
    error = function(cond) {
      message("There was an error fitting the glm")
      message("This is the error produced by glm")
      message(cond)
      
      # return NA in this case
      return(NA)
    }, 
    warning = function(cond) {
      message(paste("The bootstrapped sample", i, "does not converge", 
                    "\nIt will be removed from further computation"))
      # we don't want to return anything is there is an error
      return(NULL)
    }
  )
  
  # return the estimated coefficient
  return(out)
}

# estimate standard error with our bootstrap function
logitBoot(my_data$y, my_data$x)
