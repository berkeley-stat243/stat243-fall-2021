############################################################
### Demo code for Unit 7 of Stat243, "Parallel processing"
### Chris Paciorek, October 2021
############################################################


##########################################################
# 7: Using Dask in Python
##########################################################

### 7.1 Scheduler 

## @knitr scheduler

import dask.multiprocessing
dask.config.set(scheduler='processes', num_workers = 4)  


## @knitr 

### 7.2 Parallel map

## @knitr map

from dask.distributed import Client, LocalCluster
cluster = LocalCluster(n_workers = 4)
c = Client(cluster)

# code in calc_mean.py will calculate the mean of many random numbers
from calc_mean import *    

p = 20
n = 100000000  # must be of type integer
# set up and execute the parallel map
inputs = [(i, n) for i in range(p)]
# execute the function across the array of input values
future = c.map(calc_mean_vargs, inputs)
results = c.gather(future)
results


## @knitr 

### 7.3 Futures / delayed evaluation

## @knitr delayed

# code in calc_mean.py will calculate the mean of many random numbers
from calc_mean import *    

import dask.multiprocessing
dask.config.set(scheduler='processes', num_workers = 4)  

futures = []
p = 10
n = 100000000
for i in range(p):
    futures.append(dask.delayed(calc_mean)(i, n))  # add lazy task

futures
results = dask.compute(futures)  # compute all in parallel
