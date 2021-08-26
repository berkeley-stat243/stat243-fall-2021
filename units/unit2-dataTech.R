##################################################
### Demo code for Unit 2 of Stat243,
### "Data input/output and webscraping"
### Chris Paciorek, August 2021
##################################################

## @knitr

#####################################################
# 2: Reading data from text files into R
#####################################################


### 2.1 Core R functions

## @knitr readcsv
dat <- read.table(file.path('..', 'data', 'RTADataSub.csv'),
                  sep = ',', header = TRUE)
sapply(dat, class)
## whoops, there is an 'x', presumably indicating missingness:
unique(dat[ , 2])
## let's treat 'x' as a missing value indicator
dat2 <- read.table(file.path('..', 'data', 'RTADataSub.csv'),
                   sep = ',', header = TRUE,
                   na.strings = c("NA", "x"))
unique(dat2[ ,2])
## hmmm, what happened to the blank values this time?
which(dat[ ,2] == "")
dat2[which(dat[, 2] == "")[1], ] # pull out a line with a missing string

# using 'colClasses'
sequ <- read.table(file.path('..', 'data', 'hivSequ.csv'),
  sep = ',', header = TRUE,
  colClasses = c('integer','integer','character',
    'character','numeric','integer'))
## let's make sure the coercion worked - sometimes R is obstinant
sapply(sequ, class)
## that made use of the fact that a data frame is a list

## @knitr readLines
dat <- readLines(file.path('..', 'data', 'precip.txt'))
id <- as.factor(substring(dat, 4, 11) )
year <- substring(dat, 18, 21)
year[1:5]
class(year)
year <- as.integer(substring(dat, 18, 21))
month <- as.integer(substring(dat, 22, 23))
nvalues <- as.integer(substring(dat, 28, 30))

## @knitr connections
dat <- readLines(pipe("ls -al"))
dat <- read.table(pipe("unzip dat.zip"))
dat <- read.csv(gzfile("dat.csv.gz"))
dat <- readLines("http://www.stat.berkeley.edu/~paciorek/index.html")

## @knitr curl
wikip1 <- readLines("https://wikipedia.org")
wikip2 <- readLines(url("https://wikipedia.org"))
library(curl)
wikip3 <- readLines(curl("https://wikipedia.org"))

## @knitr streaming
con <- file(file.path("..", "data", "precip.txt"), "r")
## "r" for 'read' - you can also open files for writing with "w"
## (or "a" for appending)
class(con)
blockSize <- 1000 # obviously this would be large in any real application
nLines <- 300000
for(i in 1:ceiling(nLines / blockSize)){
    lines <- readLines(con, n = blockSize)
    # manipulate the lines and store the key stuff
}
close(con)

## @knitr stream-curl
URL <- "https://www.stat.berkeley.edu/share/paciorek/2008.csv.gz"
con <- gzcon(curl(URL, open = "r"))
## url() in place of curl() works too
for(i in 1:8) {
	print(i)
	print(system.time(tmp <- readLines(con, n = 100000)))
	print(tmp[1])
}
close(con)

## @knitr text-connection
dat <- readLines('../data/precip.txt')
con <- textConnection(dat[1], "r")
read.fwf(con, c(3,8,4,2,4,2))

## @knitr

### 2.2 File paths

## @knitr relative-paths

dat <- read.csv('../data/cpds.csv')

## @knitr path-separators

## good: will work on Windows
dat <- read.csv('../data/cpds.csv')
## bad: won't work on Mac or Linux
dat <- read.csv('..\\data\\cpds.csv')  

## @knitr file.path

## good: operating-system independent
dat <- read.csv(file.path('..', 'data', 'cpds.csv'))  

## @knitr 

### 2.3 The readr package

## @knitr readr
library(readr)
## I'm violating the rule about absolute paths here!!
## (airline.csv is big enough that I don't want to put it in the
##    course repository)
setwd('~/staff/workshops/r-bootcamp-fall-2020/data') 
system.time(dat <- read.csv('airline.csv', stringsAsFactors = FALSE)) 
system.time(dat2 <- read_csv('airline.csv'))

## @knitr                                           

#####################################################
# 3: Output from R
#####################################################

### 3.2 Formatting output

## @knitr print
val <- 1.5
cat('My value is ', val, '.\n', sep = '')
print(paste('My value is ', val, '.', sep = ''))

## @knitr cat

## input
x <- 7
n <- 5
## display powers
cat("Powers of", x, "\n")
cat("exponent   result\n\n")
result <- 1
for (i in 1:n) {
	result <- result * x
	cat(format(i, width = 8), format(result, width = 10),
            "\n", sep = "")
}
x <- 7
n <- 5
## display powers
cat("Powers of", x, "\n")
cat("exponent result\n\n")
result <- 1
for (i in 1:n) {
	result <- result * x
	cat(i, '\t', result, '\n', sep = '')
}

## @knitr sprintf
temps <- c(12.5, 37.234324, 1342434324.79997234, 2.3456e-6, 1e10)
sprintf("%9.4f C", temps)
city <- "Boston"
sprintf("The temperature in %s was %.4f C.", city, temps[1])
sprintf("The temperature in %s was %9.4f C.", city, temps[1])


## @knitr

#####################################################
# 4: Webscraping and working with HTML, XML, and JSON
#####################################################

## 4.1 Reading HTML 

## @knitr https
library(rvest)  # uses xml2
URL <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
html <- read_html(URL)
tbls <- html_table(html_elements(html, "table"))
sapply(tbls, nrow)
pop <- tbls[[1]]
head(pop)

## @knitr https-pipe
library(magrittr)
## Turns out that html_table can take the entire html doc as input
tbls <- URL %>% read_html() %>% html_table()

## @knitr htmlLinks

URL <- "http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_year"
## approach 1: search for elements with 'href' attribute
links <- read_html(URL) %>% html_elements("[href]") %>% html_attr('href')
## approach 2: search for HTML 'a' tags
links <- read_html(URL) %>% html_elements("a") %>% html_attr('href')
head(links, n = 10)

## @knitr XPath
## find all 'a' elements that have attribute 'href'; then
## extract the 'href' attribute
links <- read_html(URL) %>% html_elements(xpath = "//a[@href]") %>%
    html_attr('href')
head(links)

## we can extract various information
listOfANodes <- read_html(URL) %>% html_elements(xpath = "//a[@href]")
listOfANodes %>% html_attr('href') %>% head(n = 10)
listOfANodes %>% html_name() %>% head(n = 10)
listOfANodes %>% html_text()  %>% head(n = 10)


## @knitr XPath2
URL <- "https://www.nytimes.com"
headlines2 <- read_html(URL) %>% html_elements("h2") %>% html_text()
head(headlines2)
headlines3 <- read_html(URL) %>% html_elements("h3") %>% html_text()
head(headlines3)


## @knitr

### 4.2 XML

## @knitr xml
library(xml2)
doc <- read_xml("https://api.kivaws.org/v1/loans/newest.xml")
data <- as_list(doc)
names(data)
names(data$response)
length(data$response$loans)
data$response$loans[[2]][c('name', 'activity',
                           'sector', 'location', 'loan_amount')]

## alternatively, extract only the 'loans' info (and use pipes)
loansNode <- doc %>% html_elements('loans')
loanInfo <- loansNode %>% xml_children() %>% as_list()
length(loanInfo)
names(loanInfo[[1]])
names(loanInfo[[1]]$location)

## suppose we only want the country locations of the loans (using XPath)
xml_find_all(loansNode, '//location//country')
xml_find_all(loansNode, '//location//country') %>% xml_text()

## or extract the geographic coordinates
xml_find_all(loansNode, '//location//geo/pairs')



## @knitr

### 4.3 Reading JSON

## @knitr json
library(jsonlite)
data <- fromJSON("http://api.kivaws.org/v1/loans/newest.json")
class(data)
names(data)
class(data$loans) # nice!
head(data$loans)

data$loans[1, 'location.geo.pairs'] # hmmm...
data$loans[1, 'location']

## @knitr

### 4.4 Using web APIs to get data

## @knitr

### 4.4.3 REST- and SOAP-based web services

## @knitr REST
times <- c(2080, 2099)
countryCode <- 'USA'
baseURL <- "http://climatedataapi.worldbank.org/climateweb/rest/v1/country"
##" http://climatedataapi.worldbank.org/climateweb/rest/v1/country"
type <- "mavg"
var <- "pr"
data <- read.csv(paste(baseURL, type, var, times[1], times[2],
                       paste0(countryCode, '.csv'), sep = '/'))
head(data)

### 4.4.4 HTTP requests by deconstructing an (undocumented) API

## @knitr http-byURL

## example URL:
## http://data.un.org/Handlers/DownloadHandler.ashx?DataFilter=itemCode:526;
##year:2012,2013,2014,2015,2016,2017&DataMartId=FAO&Format=csv&c=2,4,5,6,7&
##s=countryName:asc,elementCode:asc,year:desc
itemCode <- 526
baseURL <- "http://data.un.org/Handlers/DownloadHandler.ashx"
yrs <- paste(as.character(2012:2017), collapse = ",")
filter <- paste0("?DataFilter=itemCode:", itemCode, ";year:", yrs)
args1 <- "&DataMartId=FAO&Format=csv&c=2,3,4,5,6,7&"
args2 <- "s=countryName:asc,elementCode:asc,year:desc"
url <- paste0(baseURL, filter, args1, args2)
## if the website provided a CSV we could just do this:
## apricots <- read.csv(url)
## but it zips the file
temp <- tempfile()  ## give name for a temporary file
download.file(url, temp)
dat <- read.csv(unzip(temp))  ## using a connection (see Section 2)

head(dat)

## @knitr

### 4.4.5 More details on http requests

## @knitr http-get2
library(httr)
output2 <- GET(baseURL, query = list(
               DataFilter = paste0("itemCode:", itemCode, ";year:", yrs),
               DataMartID = "FAO", Format = "csv", c = "2,3,4,5,6,7",
               s = "countryName:asc,elementCode:asc,year:desc"))
temp <- tempfile()  ## give name for a temporary file
writeBin(content(output2, 'raw'), temp)  ## write out as zip file
dat <- read.csv(unzip(temp))
head(dat)


## @knitr http-post
if(url.exists('http://www.wormbase.org/db/searches/advanced/dumper')) {
      x = postForm('http://www.wormbase.org/db/searches/advanced/dumper',
              species="briggsae",
              list="",
              flank3="0",
              flank5="0",
              feature="Gene Models",
              dump = "Plain TEXT",
              orientation = "Relative to feature",
              relative = "Chromsome",
              DNA ="flanking sequences only",
              .cgifields = paste(c("feature", "orientation", "DNA",
                                   "dump","relative"), collapse=", "))
}


## @knitr


#####################################################
# 5: File and string encodings
#####################################################

## @knitr ascii

## 4d in hexadecimal is 'M'
## 0a is a newline (at least in Linux/Mac)
## "0x" is how we tell R we are using hexadecimal
x <- as.raw(c('0x4d','0x6f', '0x6d','0x0a'))  ## i.e., "Mom\n" in ascii
x
charToRaw('Mom\n')      
writeBin(x, 'tmp.txt')
readLines('tmp.txt')
system('ls -l tmp.txt', intern = TRUE)
system('cat tmp.txt')

## @knitr unicode-example

## n-tilde and division symbol as Unicode 'code points'
x2 <- 'Pe\u00f1a 3\u00f72' 
Encoding(x2) 
x2
writeBin(x2, 'tmp2.txt')
## here n-tilde and division symbol take up two bytes
## but there is an extraneous null byte in there; not sure why
system('ls -l tmp2.txt') 
## so the system knows how to interpret the UTF-8 encoded file
## and represent the Unicode character on the screen:
system('cat tmp2.txt')

## @knitr locale
Sys.getlocale()

## @knitr iconv
text <- "Melhore sua seguran\xe7a"
Encoding(text)
Encoding(text) <- "latin1"
text  ## this prints out correctly in R, but is not correct in the PDF

text <- "Melhore sua seguran\xe7a"
textUTF8 <- iconv(text, from = "latin1", to = "UTF-8")
Encoding(textUTF8)
textUTF8
iconv(text, from = "latin1", to = "ASCII", sub = "???")

## @knitr encoding
x <- "fa\xE7ile" 
Encoding(x) <- "latin1" 
x
## playing around... 
x <- "\xa1 \xa2 \xa3 \xf1 \xf2" 
Encoding(x) <- "latin1" 
x 

## @knitr encoding-error
load('../data/IPs.RData') # loads in an object named 'text'
tmp <- substring(text, 1, 15)
## the issue occurs with the 6402th element (found by trial and error):
tmp <- substring(text[1:6401],1,15)
tmp <- substring(text[1:6402],1,15)
text[6402] # note the Latin-1 character

table(Encoding(text))
## Option 1
Encoding(text) <- "latin1"
tmp <- substring(text, 1, 15)
tmp[6402]
## Option 2
load('../data/IPs.RData') # loads in an object named 'text'
tmp <- substring(text, 1, 15)
text <- iconv(text, from = "latin1", to = "UTF-8")
tmp <- substring(text, 1, 15)



