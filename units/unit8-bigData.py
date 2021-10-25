##############################################################
### Demo code for Unit 8 of Stat243, "Databases and Big Data"
### Chris Paciorek, October 2021
##############################################################

#####################################################
# 2: Dask, MapReduce, Spark, and Hadoop
#####################################################

### 2.2.1 Dask dataframes

## @knitr dask-df-read

import dask
dask.config.set(scheduler='threads', num_workers = 4)  
import dask.dataframe as ddf
path = '/scratch/users/paciorek/243/AirlineData/csvs/'
air = ddf.read_csv(path + '*.csv.bz2',
      compression = 'bz2',
      encoding = 'latin1', # (unexpected) latin1 value(s) in TailNum field in 2001 file
      dtype = {'Distance': 'float64', 'CRSElapsedTime': 'float64',
      'TailNum': 'object', 'CancellationCode': 'object'})
# specify dtypes so Pandas doesn't complain about column type heterogeneity
air

## @knitr dask-df-compute

air.DepDelay.max().compute()   # this takes a while
sub = air[(air.UniqueCarrier == 'UA') & (air.Origin == 'SFO')]
byDest = sub.groupby('Dest').DepDelay.mean()
byDest.compute()               # this takes a while too



## @knitr 

### 2.2.2 Dask bags

## @knitr dask-bag-read

import dask.multiprocessing
dask.config.set(scheduler='processes', num_workers = 4)  # multiprocessing is the default
import dask.bag as db
## This is the full data
## path = '/scratch/users/paciorek/wikistats/dated_2017/'
## For demo we'll just use a small subset
path = '/scratch/users/paciorek/wikistats/dated_2017_small/dated/'
wiki = db.read_text(path + 'part-0000*gz')

## @knitr dask-bag-basic

import time
t0 = time.time()
wiki.count().compute()
time.time() - t0   # 136 sec. for full data

## @knitr dask-bag-filter

import re
def find(line, regex = 'Armenia'):
    vals = line.split(' ')
    if len(vals) < 6:
        return(False)
    tmp = re.search(regex, vals[3])
    if tmp is None:
        return(False)
    else:
        return(True)
    

wiki.filter(find).count().compute()
armenia = wiki.filter(find)
smp = armenia.take(100) ## grab a handful as proof of concept
smp[0:5]

## @knitr dask-bag-convert

def make_tuple(line):
    return(tuple(line.split(' ')))

dtypes = {'date': 'object', 'time': 'object', 'language': 'object',
'webpage': 'object', 'hits': 'float64', 'size': 'float64'}

## Let's create a Dask dataframe. 
## This will take a while if done on full data.
df = armenia.map(make_tuple).to_dataframe(dtypes)
type(df)

## Now let's actually do the computation, returning a Pandas df
result = df.compute()  
type(result)
result.head()

## @knitr 

### 2.2.3 Dask arrays

## @knitr dask-array-1

import dask
dask.config.set(scheduler = 'threads', num_workers = 4) 
import dask.array as da
x = da.random.normal(0, 1, size=(40000,40000), chunks=(10000, 10000))
# square 10k x 10k chunks
mycalc = da.mean(x, axis = 1)  # by row
import time
t0 = time.time()
rs = mycalc.compute()
time.time() - t0  # 41 sec.

## @knitr dask-array-2

import dask
dask.config.set(scheduler='threads', num_workers = 4)  
import dask.array as da
# x = da.from_array(x, chunks=(2500, 40000))  # adjust chunk size of existing array
x = da.random.normal(0, 1, size=(40000,40000), chunks=(2500, 40000))
mycalc = da.mean(x, axis = 1)  # row means
import time
t0 = time.time()
rs = mycalc.compute()
time.time() - t0   # 42 sec.

## @knitr dask-array-3

import dask
dask.config.set(scheduler='threads', num_workers = 4)  
import dask.array as da
import numpy as np
import time
t0 = time.time()
x = np.random.normal(0, 1, size=(40000,40000))
time.time() - t0   # 110 sec.
# for some reason the from_array and da.mean calculations are not done lazily here
t0 = time.time()
dx = da.from_array(x, chunks=(2500, 40000))
time.time() - t0   # 27 sec.
t0 = time.time()
mycalc = da.mean(x, axis = 1)  # what is this doing given .compute() also takes time?
time.time() - t0   # 28 sec.
t0 = time.time()
rs = mycalc.compute()
time.time() - t0   # 21 sec.

## @knitr dask-array-4

import dask
dask.config.set(scheduler='threads', num_workers = 4)  
import dask.array as da
x = da.random.normal(0, 1, size=(100000,100000), chunks=(10000, 10000))
mycalc = da.mean(x, axis = 1)  # row means
import time
t0 = time.time()
rs = mycalc.compute()
time.time() - t0   # 205 sec.
rs[0:5]

## @knitr

### 2.3.6 Spark in action: processing the Wikipedia traffic data

## @knitr read-filter

dir = '/global/scratch/paciorek/wikistats'

### read data and do some checks ###

## 'sc' is the SparkContext management object, created via PySpark
## if you simply start Python, without invoking PySpark,
## you would need to create the SparkContext object yourself

lines = sc.textFile(dir + '/' + 'dated') 

lines.getNumPartitions()  # 16800 (480 input files) for full dataset

# note delayed evaluation
lines.count()  # 9467817626 for full dataset

# watch the UI and watch wwall as computation progresses

testLines = lines.take(10)
testLines[0]
testLines[9]

### filter to sites of interest ###

import re
from operator import add

def find(line, regex = "Barack_Obama", language = None):
    vals = line.split(' ')
    if len(vals) < 6:
        return(False)
    tmp = re.search(regex, vals[3])
    if tmp is None or (language != None and vals[2] != language):
        return(False)
    else:
        return(True)

lines.filter(find).take(100) # pretty quick
    
# not clear if should repartition; will likely have small partitions if not
# obama = lines.filter(find).repartition(480) # ~ 18 minutes for full dataset (but remember lazy evaluation)
obama = lines.filter(find)  # use this for demo in section
obama.count()  # 433k observations for full dataset

## @knitr map-reduce

### map-reduce step to sum hits across date-time-language triplets ###
    
def stratify(line):
    # create key-value pairs where:
    #   key = date-time-language
    #   value = number of website hits
    vals = line.split(' ')
    return(vals[0] + '-' + vals[1] + '-' + vals[2], int(vals[4]))

# sum number of hits for each date-time-language value
counts = obama.map(stratify).reduceByKey(add)  # 5 minutes
# 128889 for full dataset

### map step to prepare output ###

def transform(vals):
    # split key info back into separate fields
    key = vals[0].split('-')
    return(",".join((key[0], key[1], key[2], str(vals[1]))))

### output to file ###

# have one partition because one file per partition is written out
outputDir = dir + '/' + 'obama-counts'
counts.map(transform).repartition(1).saveAsTextFile(outputDir) # 5 sec.

## @knitr 

### 2.3.9 Nonstandard reduction

## @knitr median

import numpy as np

def findShortLines(line):
    vals = line.split(' ')
    if len(vals) < 6:
        return(False)
    else:
        return(True)


def computeKeyValue(line):
    vals = line.split(' ')
    # key is language, val is page size
    return(vals[2], int(vals[5]))


def medianFun(input):
    # input[1] is an iterable object containing the page sizes for one key
    # this list comprehension syntax creates a list from the iterable object
    med = np.median([val for val in input[1]])
    # input[0] is the key
    # return a tuple of the key and the median for that key
    return((input[0], med))


output = lines.filter(findShortLines).map(computeKeyValue).groupByKey()
medianResults = output.map(medianFun).collect()

## @knitr null

### 2.3.10 Spark DataFrames and SQL queries

## @knitr DataFrames

### read the data in and process to create an RDD of Rows ###

dir = '/global/scratch/paciorek/wikistats'

lines = sc.textFile(dir + '/' + 'dated')

### create DataFrame and do some operations on it ###

def remove_partial_lines(line):
    vals = line.split(' ')
    if len(vals) < 6:
        return(False)
    else:
        return(True)

def create_df_row(line):
    p = line.split(' ')
    return(int(p[0]), int(p[1]), p[2], p[3], int(p[4]), int(p[5]))


tmp = lines.filter(remove_partial_lines).map(create_df_row)

## 'sqlContext' is the Spark sqlContext management object, created via PySpark
## if you simply start Python without invoking PySpark,
## you would need to create the sqlContext object yourself

df = sqlContext.createDataFrame(tmp, schema = ["date", "hour", "lang", "site", "hits", "size"])

df.printSchema()

## note similarity to dplyr and R/Pandas dataframes
df.select('site').show()
df.filter(df['lang'] == 'en').show()
df.groupBy('lang').count().show()

## @knitr spark-sql

### use SQL with a DataFrame ###

df.registerTempTable("wikiHits")  # name of 'SQL' table is 'wikiHits'

subset = sqlContext.sql("SELECT * FROM wikiHits WHERE lang = 'en' AND site LIKE '%Barack_Obama%'")

subset.take(5)
# [Row(date=20081022, hits=17, hour=230000, lang=u'en', site=u'Media:En-Barack_Obama-article1.ogg', size=145491), Row(date=20081026, hits=41, hour=220000, lang=u'en', site=u'Public_image_of_Barack_Obama', size=1256906), Row(date=20081112, hits=8, hour=30000, lang=u'en', site=u'Electoral_history_of_Barack_Obama', size=141176), Row(date=20081104, hits=13890, hour=110000, lang=u'en', site=u'Barack_Obama', size=2291741206), Row(date=20081104, hits=6, hour=110000, lang=u'en', site=u'Barack_Obama%2C_Sr.', size=181699)]

langSummary = sqlContext.sql("SELECT lang, count(*) as n FROM wikiHits GROUP BY lang ORDER BY n desc limit 20") # 38 minutes
results = langSummary.collect()
# [Row(lang=u'en', n=3417350075), Row(lang=u'de', n=829077196), Row(lang=u'ja', n=734184910), Row(lang=u'fr', n=466133260), Row(lang=u'es', n=425416044), Row(lang=u'pl', n=357776377), Row(lang=u'commons.m', n=304076760), Row(lang=u'it', n=300714967), Row(lang=u'ru', n=256713029), Row(lang=u'pt', n=212763619), Row(lang=u'nl', n=194924152), Row(lang=u'sv', n=105719504), Row(lang=u'zh', n=98061095), Row(lang=u'en.d', n=81624098), Row(lang=u'fi', n=80693318), Row(lang=u'tr', n=73408542), Row(lang=u'cs', n=64173281), Row(lang=u'no', n=48592766), Row(lang=u'he', n=46986735), Row(lang=u'ar', n=46968973)]


