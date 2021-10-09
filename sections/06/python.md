---
title: Introduction to Python
...


Background
================


Preparation
---------------

This tutorial assumes you are familiar with R.

You will also need Python and IPython installed on your computer, as well as a few core additional packages, including re, numpy, scipy, and pandas. 

Packages can generally be installed via pip, or via conda if you have the Anaconda (or Miniconda) installation of Python. The following shows how to do this from the command line on MacOS or Linux.

```{.sourceCode .bash}
## using conda
conda list
conda install numpy
conda install ipython

## using pip
pip install numpy
pip install ipython
# or to install within your home directory if you do not have admin control of the computer
pip install --user numpy

```

For additional help with installation, please see the [IPython installation page](http://ipython.org/install.html).


Resources
---------------

Useful written references and tutorials:

-   <https://docs.python.org/3/index.html>
-   <https://docs.python.org/3/library/index.html>
-   <https://scipy-lectures.github.io/>

Some introductory video lectures:

-   <https://www.youtube.com/watch?v=a_Z_6brm9ZQ>

While working through this tutorial, you should type the example code
snippets at an interactive Python terminal. I recommend using either the
IPython shell or a Jupyter IPython notebook. To start an IPython shell, type
the following at a bash prompt:

``` {.sourceCode .bash}
ipython
```

To start an Jupyter IPython notebook, type this:

``` {.sourceCode .bash}
jupyter notebook
```

A notebook should open in your browser.

Alternatively you can access Jupyter notebooks through a service called [Jupyterhub on the SCF](https://jupyter.stat.berkeley.edu).

Side note: to have all output (not just the last result) printed in the Jupyter notebook, you can run this in a cell in your notebook.

```python
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
```


Python 2 vs. 3
--------------------------

Python 3 is the current version of Python. For many years the old version (Python 2) has co-existed with Python 3 and Python 2 has been used by many people despite the existence of Python 3. Python 2 is now being phased out. 

Introduction
===============

Formatting Python code
-------------------------

Unlike most languages, in Python indentation determines code blocks, including functions, loops, and if-else statements.

The standard is one tab or 4 spaces, but you can use other spacing if it's consistent within a block of code.


``` {.sourceCode .python}
a = 3
 a = 3  # this will cause an IndentationError, at least in Python itself, if not IPython
```

Note that because indentation determines the beginning and end of code blocks, the following two pieces of code do different things.

``` {.sourceCode .python}
if a>=4:    
    print('a is big')
    if(a == 4):
        print('a is 4')
else:
    print('a is small')

if a>=4:    
  print('a is big')
  if(a == 4):
        print('a is 4')
  else:
        print('a is not 4')
```

The importance of indentation can cause problems when cutting and pasting code into a Python session.

Objects
-------

Everything is an object in Python. Roughly, this means that it can be
tagged with a variable (i.e., given a name) and passed as an argument to a function. Often it
means that everything has *attributes* and *methods*.

Certain objects in Python are mutable (e.g., lists, dictionaries), while
other objects are immutable (e.g., tuples, strings, sets). Mutable means one can change parts of the object.

Many objects can be composite (e.g., a list of dictionaries or a dictionary of lists,
tuples, and strings).

Here's a list in Python. It's similar to a list in R in that it can store heterogeneous information, but the syntax is a bit different.

Also note that indexing in Python starts at 0 not at 1.

``` {.sourceCode .python}
myList = [1, 2, 'foo']
myList[0]
myList[1]
myList[1] = 2.5
myList
```

Here's a tuple in Python. What's different compared to the list?


``` {.sourceCode .python}
myTuple = (1, 2, 'foo')
myTuple[1] = 2.5
myTuple
```

Variables
---------

As in R and other interpreted languages, variables are not their values in Python (think "I am not my name, I am
the person named XXX"). You can think of variables as tags on objects.
In particular, variables can point to (be bound to) an object of one type and then
reassigned to an object of another type without error.

``` {.sourceCode .python}
a = 'foobar'
a
a * 4
len(a)

a = 3
a
a*4
len(a)
```

Modules, files, packages, import
--------------------------------

While you will often explore things from an interactive Python prompt,
you will save your code in files for reuse as well as to document what
you’ve done. You can use Python code saved in a plain text file from a
Python prompt or other files by importing it. Typically, this is done at
the top of a file (if you are working at a prompt, you just need to
import it before you want to use the functionality).

Note that the use of `mytest.` is similar to our discussion of package
namespaces in R.

``` {.sourceCode .bash}
cat mytest.py  # special IPython functionality to call the operating system
```

``` {.sourceCode .python}
del(a); del(hello)   # delete any existing objects

import mytest          # make available objects/functions in mytest.py

mytest.hello()         # access using object-oriented style syntax
mytest.a

hello()
a
```

We can import everything in the test.py file if we want. Why
might this not be a great idea?

``` {.sourceCode .python}
from mytest import *

hello()
a
```


As in R, you can also load in additional supporting packages for extra functionality.
In contrast to R, a lot of basic functionality is provided in supporting packages
that need to be loaded before you can use it.

Here are some examples of importing Python packages and using functionality from them:

``` {.sourceCode .python}
from math import cos
cos(0)
sin(0)    # why doesn't this work?
import math
math.cos(0)
math.sin(0)
import numpy as np
numpy.arctan(1)
np.arctan(1)
import scipy as sp
import matplotlib.pyplot as plt
```

Note as seen above for numpy and scipy, it's common to import a package but give it a
shortened name, 'np' and 'sp' in this case.

The different packages have different namespaces, which helps to avoid problems with
different packages using the same names for different functions.


Documentation and getting help
-------------------------------

We can get help like this.

``` {.sourceCode .python}
In [1]: import numpy as np

In [2]: np.ndim?
Type:        function
String form: <function ndim at 0x7fcabd864938>
File:        /usr/lib64/python2.7/site-packages/numpy/core/fromnumeric.py
Definition:  np.ndim(a)
Docstring:
Return the number of dimensions of an array.

Parameters
----------
a : array_like
    Input array.  If it is not already an ndarray, a conversion is
    attempted.

Returns
-------
number_of_dimensions : int
    The number of dimensions in `a`.  Scalars are zero-dimensional.

See Also
--------
ndarray.ndim : equivalent method
shape : dimensions of array
ndarray.shape : dimensions of array

Examples
--------
>>> np.ndim([[1,2,3],[4,5,6]])
2
>>> np.ndim(np.array([[1,2,3],[4,5,6]]))
2
>>> np.ndim(1)
0
```

Docstrings are an important part of Python. A docstring is a character string that occurs as the first statement in a module, function, class, or method definition. Such a docstring becomes the __doc__ special attribute of that object. All modules (e.g., test.py is a module) should normally have docstrings, and all functions and classes exported by a module should also have docstrings. 


Decoding error messages
--------------------------

Run the following code and try to tease out where the error is. The tricky part is that the error occurs within a function where the function comes from a module (separate code file).

``` {.sourceCode .python}
import days

days.print_friday_message()
```

The list of function calls that led to the error is called a *traceback*.  (Recall that in R you can get similar output using `traceback()` after an error or setting `options(error = recover)` before an error.)

Data Structures
===============

Python has a number of basic data structure types that are widely used. There are both similarities and differences from basic data structures in R.

-   <https://docs.python.org/3/library/stdtypes.html>
-   <https://docs.python.org/3/tutorial/datastructures.html>
-   <https://docs.python.org/3/reference/datamodel.html>

Numbers
-------

Python has integers, floats, and complex numbers with the usual
operations.

``` {.sourceCode .python}
2*3
2/3

# be careful - if you try `2/3` in Python 2, you'll get different behavior.

x = 1.1
type(x)

x * 2
x ** 2

(type(1), type(1.1), type(1+2j))
y = 1+2j
```


We can apply various functions to numbers, as expected.
``` {.sourceCode .python}
import math
math.cos(0)
math.cos(math.pi)
```

The *math* package in the standard library includes many additional
numerical operations.

If you type the name of a module or package followed by period (.) and tab
you should see the objects and functions in that module/package.

``` {.sourceCode .python}
math.    
```
```
math.acos       math.degrees    math.fsum       math.pi
math.acosh      math.e          math.gamma      math.pow
math.asin       math.erf        math.hypot      math.radians
math.asinh      math.erfc       math.isinf      math.sin
math.atan       math.exp        math.isnan      math.sinh
math.atan2      math.expm1      math.ldexp      math.sqrt
math.atanh      math.fabs       math.lgamma     math.tan
math.ceil       math.factorial  math.log        math.tanh
math.copysign   math.floor      math.log10      math.trunc
math.cos        math.fmod       math.log1p      
math.cosh       math.frexp      math.modf
```



**Exercises**

- Using the section on "Built-in Types" from the [official "The Python
Standard Library" reference](https://docs.python.org/3/library/index.html), figure out how to compute:
    1.  $(\lceil \frac{3}{4} \rceil \times 4)^3$, 
    and
    2.  $\sqrt{-1}$.



Objects and object-oriented programming
---------------------------------------

We'll talk about this in more detail later, but it's worth mentioning here that Python is an object-oriented language.  What this means is that variables in Python are objects that are instances of a class.

Objects have methods that can be used on them and attributes (member data) that are part of the object. All objects in a class have the same methods and same member data 'slots', but different objects will have different values in those slots.

Note that even the basic numeric structures behave like objects. We can use tab completion to see what methods are available for an object and what member data are part of an object.

``` {.sourceCode .python}
x = 3.0
type(x)
x.
# x.as_integer_ratio  x.hex               x.real
# x.conjugate         x.imag              
# x.fromhex           x.is_integer        
```

Which of those are attributes/metadata ('member data') and which are methods ('member functions')? If it's a method, say `foo`, you can run the method as `x.foo()`. If it's member data, you can see its value with `x.foo`. 


Tuples
------

Tuples are immutable sequences of (zero or more) objects. Functions in
Python often return tuples.

``` {.sourceCode .python}
x = 1; y = 'foo'

xy = (x, y)
type(xy)
xy = x,y
type(xy)

xy
xy[1]

xy[1] = 3

a,b = x,y
a
b
```

**Exercises**

- Create the following: `x=5` and `y=6`. Now swap their values using a single line of code. (How would you do this in R?)
- What happens when you multiply a tuple by a number? how is this different than similar syntax in R?
- What's nice about using immutable objects in your code?

Lists
----

Lists are mutable sequences of (zero or more) objects.

``` {.sourceCode .python}
dice = [1, 2, 3, 4, 5, 6]
dice.extend([7,8])

dice.insert(3, 100)
```

Indexing (also called 'slicing') in Python starts at 0 and ends at the length of the object minus 1.

``` {.sourceCode .python}
dice = [1, 2, 3, 4, 5, 6]
dice[0]
dice[1]
dice[6]
```

One can also use sequences. Figure out what is going on here:

``` {.sourceCode .python}
dice = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
dice[1::2]
dice[1:4:2]

dice[1::2] = dice[::2]

dice
```

**Exercises**

- What do you get if you multiply a list of numbers by a number? We'll need to use numpy if we want this to behave like we might expect based on R.
- What does the following tell you about copying and use of memory in Python?
``` {.sourceCode .python}
a = [1, 3, 5]
b = a
id(a)
id(b)
# this should confirm what you might suspect
a[1] = 5
```

Dictionaries
------------

Dictionaries are mutable, unordered collections of key-value pairs. They're like named lists or named vectors in R.

``` {.sourceCode .python}
students = {"Jarrod Millman": ['A', 'B+', 'A-'], 
            "Thomas Kluyver": ['A-', 'A-'], 
            "Stefan van der Walt": 'and now for something completely different'}
students
students.keys()
students.values()
students["Jarrod Millman"]
students["Jarrod Millman"][1]
students.
```


Control flow
============

-   <https://docs.python.org/3/tutorial/controlflow.html>

If-then-else
------------

-   <https://docs.python.org/3/tutorial/controlflow.html#if-statements>

This is as expected based on your experience with other languages. As previously noted, the indentation is important.

``` {.sourceCode .python}
x = 2

if a>=4:    
    print('a is big')
    if(a == 4):
        print('a is 4')
else:
    print('a is small')

if a>=4:    
    print('a is big')
    if(a == 4):
        print('a is 4')
    else:
        print('a is not 4')
```

For-loops (and list comprehension)
----------------------------------

-   <https://docs.python.org/3/tutorial/controlflow.html#for-statements>
-   <https://docs.python.org/3/whatsnew/2.0.html#list-comprehensions>

Here's basic use of a for loop. Once again indentation is critical, in this case for indicating where the loop ends.

``` {.sourceCode .python}
for x in [1,2,3,4]:
    print(x)

for x in [1,2,3,4]:
    y = x*2
    print(y, end=" ")

print("\n")
for x in range(30):
    print(x)
    y = x


print(y, end=" ")
```

Building up a list piece-by-piece is a common task, which can easily be
done in a for-loop. An approach called 'List comprehension' provides a compact syntax to
handle this task.

``` {.sourceCode .python}
y = [x for x in range(4)]

vals = [-4, 3, -1, 2.5, 7]
[x for x in vals if x > 0]  # list comprehension

```


**Exercises**

- See what `[1, 2, 3] + 3` returns. Try to explain what happened and why.
- Use list comprehension to perform element-wise addition of a scalar to a list of scalars.



Functions
===============

-   <https://docs.python.org/3/tutorial/controlflow.html#defining-functions>

Here's an example that illustrates both positional arguments (always first) and named arguments.

``` {.sourceCode .python}
def add(x, y=1, absol=False):
    if absol:
        return(abs(x+y))
    else:
        return(x+y)

add(3)
add(3, 5)

add(3, absol=True, y=-5)

add(y=-5, x=3)
add(y=-5, 3)
```

**Exercises**

- Define a function that will take the sqrt of a number and will (if requested by the user) set the square root of a negative number to 0.


Math and Statistics
======================

NumPy and SciPy
-------------

Standard lists in Python are not amenable to mathematical manipulation unlike standard vectors in R. Instead we generally work with numpy arrays. These arrays can be of various dimensions (i.e., vectors, matrices, multi-dimensional arrays). One important difference between R and numpy objects is that numpy performs operations *in place* - i.e. the object itself is modified and no copies are made. 

``` {.sourceCode .python}
z = [0, 1, 2] 

y = np.array(z)
y*3

y.dtype  # what type of value is stored in the array


x = np.array([[1, 2], [3, 4]], dtype=np.float64)
x*x         # element wise multiplication
x.dot(x)    # matrix multiplication
x.T         # transpose

np.linalg.svd(x)   # do an SVD

e = np.linalg.eig(x)  # find eigenvalues and vectors

e[0]  # first eigenvalue (not the largest in this case...)
e[1][:, 0] # corresponding eigenvector
```

All of the elements of the array must be of the same type.

There are a variety of numpy functions that allow us to do standard mathematical/statistical manipulations. 

Here we'll use some of those functions in addition to some syntax for subsetting and vectorized calculations.

``` {.sourceCode .python}
np.linspace(0, 1, 5)

np.random.seed(0)
x = np.random.normal(size=10)

pos = x > 0

y = x[pos]

x[[1, 3, 4]]

x[pos] = 0

np.cos(x)
```

scipy has even more numerical routines, including working with distributions and additional linear algebra.

``` {.sourceCode .python}
import scipy.stats as st
st.norm.cdf(1.96, 0, 1)
st.norm.cdf(1.96, 0.5, 2)
st.norm(0.5, 2).cdf(1.96)
```

**Exercise**

- See what happens if you try to create a numpy array with a mix of numbers and character strings.
- Try to add a vector to a matrix; how does this compare to R?


Pandas
---------

Pandas provides a Python implementation of R's dataframe capabilities. Let's see some example code.

``` {.sourceCode .python}
import pandas as pd
dat = pd.read_csv('gapminder.csv')
dat.head()

dat.columns
dat['year']
dat.year
dat[0:5]

dat.sort_values(['year', 'country'])

dat.loc[0:5, ['year', 'country']]  # R-style indexing

dat[dat.year == 1952]

ndat = dat[['pop','lifeExp','gdpPercap']]
ndat.apply(lambda col: col.max() - col.min())
```

Now let's see the sort of split-apply-combine functionality that is popular in dplyr and related R packages.

``` {.sourceCode .python}
dat2007 = dat[dat.year == 2007].copy()  

dat2007.groupby('continent', as_index=False).mean()

def stdize(vals):
    return((vals - vals.mean()) / vals.std())

dat2007['lifeExpZ'] = dat2007.groupby('continent')['lifeExp'].transform(stdize)
```

**Exercise**

- Use *pd.merge()* to merge the continent means for life expectancy for 2007 back into the original *dat2007* dataFrame.




Additional topics
==================

Style 
-----

Adopting standard coding conventions is good practice.

-   <https://www.python.org/dev/peps/pep-0008/>
-   <https://docs.python.org/3/tutorial/controlflow.html#intermezzo-coding-style>
-   <https://github.com/numpy/numpy/blob/master/doc/HOWTO_DOCUMENT.rst.txt>
-   <http://matplotlib.org/devel/coding_guide.html>

The first link above is the official "Style Guide for Python Code",
usually referred to as PEP8 (PEP is an acronym for Python Enhancement
Proposal). There are a couple of potentially helpful tools for helping
you conform to the standard. The
[pep8](https://pypi.python.org/pypi/pep8) package that provides a
commandline tool to check your code against some of the PEP8 standard
conventions. Similarly,
[autopep8](https://pypi.python.org/pypi/autopep8) provides a tool to
automatically format your code so that it conforms to the PEP8
standards. I have used both a little and they seem to work fairly well.

Classes
------------

-   <https://docs.python.org/3/tutorial/classes.html>

We've already seen a bunch of object-oriented behavior. Here we'll see how to make our own classes and objects that are instances (realizations) of a class.

``` {.sourceCode .python}
class Rectangle(object):
    dim = 2  # class variable
    counter = 0
    def __init__(self, height, width):
        self.height = height  # instance variable
        self.width = width    # instance variable
        self.set_diagonal()
        Rectangle.counter += 1
    def __repr__(self):
        return("{0} by {1} rectangle".format(self.height, self.width))        
    def area(self, verbose = False):
	if verbose:
	    print('Computing the area... ')
        return(self.height*self.width)
    def set_diagonal(self):
        self.diagonal = pow(self.height**2 + self.width**2, 0.5)

x = Rectangle(10, 5)

x.dim
x.dim = 'foo'
x.dim # hmmm

x.area()
Rectangle.area(x)

y = Rectangle(4, 8)
y.counter
x.counter
```

Strings
----------

Strings are immutable sequences of (zero or more) characters.

**Sequences**

Unlike numbers, Python strings are container objects. Specifically, it
is a sequence. Python has several sequence types including strings,
tuples, and lists. Sequence types share some common functionality, which
we can demonstrate with strings.

**Indexing** 

To see how indexing works in Python let’s use the
string containing the digits 0 through 9.

``` {.sourceCode .python}    
import string
string.digits 
string.digits[1]
string.digits[-1]
```

Note that indexing starts at 0 (unlike R and Fortran, but like C).
Also negative integers index starting from the end of the sequence.
You can find the length of a sequence using the *len* function.

**Slicing** 

Slicing allows you to select a subset of a string (or
any sequence) by specifying start and stop indices as well as a
step, which you specify using the `start:stop:step` notation inside
of square braces.

``` {.sourceCode .python}
string.digits[1:5]
string.digits[1:5:2]
string.digits[1::2]
string.digits[:5:-1]
string.digits[1:5:-1]
string.digits[-3:-7:-1]
```

**Subsequence testing**

``` {.sourceCode .python}    
'23' in string.digits 
'25' not in string.digits
```

**String methods**

``` {.sourceCode .python}
string1 = "my string"
string1.
```
```
string1.capitalize  string1.islower     string1.rpartition
string1.center      string1.isspace     string1.rsplit
string1.count       string1.istitle     string1.rstrip
string1.decode      string1.isupper     string1.split
string1.encode      string1.join        string1.splitlines
string1.endswith    string1.ljust       string1.startswith
string1.expandtabs  string1.lower       string1.strip
string1.find        string1.lstrip      string1.swapcase
string1.format      string1.partition   string1.title
string1.index       string1.replace     string1.translate
string1.isalnum     string1.rfind       string1.upper
string1.isalpha     string1.rindex      string1.zfill
string1.isdigit     string1.rjust       
```

``` {.sourceCode .python}
string1.upper()

string1.upper?

string1 + " is your string."
"*"*10

string1[3:]
string1[3:4] 
string1[4::2]

string1[3:5] = 'ts'
```

``` {.sourceCode .python}
string1 > "ab"
string1 > "zz"
string1.__
```
```
string1.__add__           string1.__len__
string1.__class__         string1.__lt__
string1.__contains__      string1.__mod__
string1.__delattr__       string1.__mul__
string1.__doc__           string1.__ne__
string1.__eq__            string1.__new__
string1.__format__        string1.__reduce__
string1.__ge__            string1.__reduce_ex__
string1.__getattribute__  string1.__repr__
string1.__getitem__       string1.__rmod__
string1.__getnewargs__    string1.__rmul__
string1.__getslice__      string1.__setattr__
string1.__gt__            string1.__sizeof__
string1.__hash__          string1.__str__
string1.__init__          string1.__subclasshook__
```

**Exercises**

- Using this string: `x = 'The ant wants what all ants want.'`, solve the following string manipulation problems using string indexing, slicing, methods, and subsequence testing:
    1.  Convert the string to all lower case letters (don’t change x).
    2.  Count the number of occurrences of the substring `ant`.
    3.  Create a list of the words occurring in `x`. Make sure to remove
    punctuation and convert all words to lowercase.
    4.  Using only string methods on `x`, create the following string:
    `The chicken wants what all chickens want.`
    5.  Using indexing and the `+` operator, create the following string:
    `The tna wants what all ants want.`
    6.  Do the same thing except using a string method instead.
- What can you do with the *in* and *not in* operators?  What R operator is this like and how is it different?
- Figure out what code you could run to figure out if Python is explicitly counting the number of characters when it does `len(x)`?
- Compare the time for computing the length of a (long) string in Python and R. What can you infer about what is happening behind the scenes?



A Note on the Contents
==============

This content was adapted by Chris Paciorek from [material prepared by K. Jarrod Millman](http://www.jarrodmillman.com/capstone/bootcamp/standard.html) and is licensed under the [CC BY-NC-SA 4.0 license](http://creativecommons.org/licenses/by-nc-sa/4.0/).
