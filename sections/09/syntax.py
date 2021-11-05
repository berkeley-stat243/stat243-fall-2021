## How to create a 1-d array of random numbers or zeroes

import numpy

x = numpy.random.normal(size = 100000)

x = numpy.zeros(100000)


## How to time code (one way to do it)

import time
t0 = time.time()
x = numpy.random.normal(size = 10000000)
time.time() - t0

## Defining a simple function

def myfun(scalar, vector):
    scalar = 7
    vector[1] = 9
    return(1)

## Extending a vector

dice = [1, 2, 3, 4, 5, 6]
dice.extend([7])


## Figuring out if two objects use the same memory

x = [0, 1, 2, 3]
y = [0, 1, 2, 3]
id(x)
id(y)

## Variable types

a=pow(2,55)
a
type(a)

## Printing out many digits of a real-valued number

val=123456781234567812.0
print(str.format('{0:.0f}', val))


## The Python debugger

import pdb

def myfun(a):
    tmp = a*7
    pdb.set_trace()
    tmp = pow(tmp, 2)
    return(tmp)

