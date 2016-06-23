---
layout: post
title: Lets dive in - a hands-on example
author: Sven Nelson
categories: [R tutorial]
tags: [Part 3]
---
Now it's time to actually start coding!  Open up RStudio and follow along below.  We'll do an example project using real data from The National Center for Enviromental Information.

## Analyzing temperature and precipitation ##

Ok, I know you have been anxious to get to this point.   
  
**Here is the plan of action:**  

1. Import data, format data, summarize data, plot data.
2. Make this into a function to use on similar datasets
3. Use `manipulate` package to make this function interactive.
4. Test this with other similar datasets.

Required R file: [summarySE.R](/Rsite/files/summarySE.R) *(for the R function `summarySE()`)*

Data is from: ([http://www.ncdc.noaa.gov/cdo-web/search](http://www.ncdc.noaa.gov/cdo-web/search))


## The data source ##
GHCND (Global Historical Climatology Network)-Monthly Summaries is a database that addresses the critical need for historical monthly temperature, precipitation, and snow records over global land areas.  

**Go here:** 
[http://www.ncdc.noaa.gov/cdo-web/search](http://www.ncdc.noaa.gov/cdo-web/search)

**For this example:** 
Choose Monthly Summaries  
Choose Custom Monthly Summaries of GHCN-Daily CSV  
Choose TPCP and MNTM

*I have prepared 5 datasets for you that were downloaded from NOAA as specified above.  Choose one and download it to use for this exercise.  The code that we write will be written to allow reuse for any of these datasets.*

**Prepared datasets:**  
[ClimateDataset_Alaska.csv](/Rsite/files/ClimateDataset_Alaska.csv)  
[ClimateDataset_Florida.csv](/Rsite/files/ClimateDataset_Florida.csv)  
[ClimateDataset_Missouri.csv](/Rsite/files/ClimateDataset_Missouri.csv)  
[ClimateDataset_NewYork.csv](/Rsite/files/ClimateDataset_NewYork.csv)  
[ClimateDataset_Texas.csv](/Rsite/files/ClimateDataset_Texas.csv)  
  
## Import data ##
**TPCP** = Total precipitation amount for the month (inches to hundredths)  
**MNTM** = Mean Normal Temperature Monthly (Mean monthly temperature)


```r
# move to your working directory
getwd() # returns your current working directory

# you can type the command below or just use the files tab in Rstudio to navigate to the folder, then select: More > Set As Working Directory
setwd("~/R_tutorial_series/working directory")

# Import data
dataFL <-read.csv("ClimateDataset_Florida.csv", header = T, stringsAsFactors = F)

# Uh oh, there are some cells with -9999.  This is not a possible temp or precipitation (even in Alaska), so this must be their NA value.  Let's remove this data.frame and import it again with -9999 identified as the string for "NA"
rm(dataFL) # rm = removes the variable from the current environment

dataFL <-read.csv("ClimateDataset_Florida.csv", header = T, na.strings = "-9999", stringsAsFactors = F)

# if you want to select the file in finder/explorer you can use file.choose()
dataFL <-read.csv(file.choose(), header = T, na.strings = "-9999", stringsAsFactors = F)

# If your data was in excel format you could export to csv, or you could:
require("gdata")
dataFL <-read.xls("ClimateDataset_Florida.xlsx", na.strings = "-9999", stringsAsFactors = FALSE)
```

**Since we are talking about reading csv files, how about saving a dataframe to a csv file:**

```r
# Write out a dataframe to a csv and you can open in excel and save it as an xls
write.csv(x = data_FL, file = "ClimateDataset_Florida.csv", row.names = F)
# R can also write directly to xls or xlsx using packaged like WriteXLS().
```

**The following calls can help us to get a feel for the data**  

```r
# dataFrame[rows, columns] 
head(dataFL)
tail(dataFL)

summary(dataFL$TPCP)

# And in RStudio we can simply type:
View(dataFL) # to get a scrollable table view
```

## Format data ##
Ok, lets tidy up the dataframe and reformat it for easy plotting.    

Lets look at how the average precipitation (**TPCP**) for a year (across all 12 months) has changed over the years from 1931 to 2015. To do this, we'll want to consider all values with the same year

```r
# split 194210 into two columns: 1940 + 10
dateColumn <- as.character(dataFL$DATE) # makes it into a string
dataFL$YEAR <- as.integer(substring(dateColumn, first = 1, last = 4))
dataFL$MONTH <- as.integer(substring(dateColumn, first = 5, last = 7))
#class(dataFL$DATE)
#class(dataFL$YEAR)
rm(dateColumn) # remove the date column variable

# And subset the table to only include the columns that you want
attach(dataFL)
dataFL <- data.frame(STATION_NAME, YEAR, MONTH, TPCP)
#dataFL <- data.frame(STATION_NAME, YEAR, MONTH, MNTM)
detach(dataFL)
#install.packages("dplyr") # Run this if you don't have this package already
require("dplyr") # makes it easy to subet data
dataFL <- dplyr::filter(dataFL, !is.na(TPCP)) # remove rows with NAs
#data <- dplyr::filter(data, !is.na(MNTM)) # remove rows with NAs

# The location names are too long, lets shorten them to just the state name
# To do this, first we need to extract the 2 letter state abbreviation from
# each station name in our dataframe.  
stateAbbrev <- substring(dataFL$STATION_NAME, first = nchar(as.character(dataFL$STATION_NAME)) - 4, last = nchar(as.character(dataFL$STATION_NAME)) - 3) # last digits of name is: FL US

# Next we can use the built-in R tools to convert state abbreviations into state names.
dataFL$STATION_NAME <- state.name[match(stateAbbrev,state.abb)]
rm(stateAbbrev)
```

## Summarize data ##
Now we have the data in a nice format.  Let's summarize the data using the `summarySE()` function that I have provided for you.  

This function will give you summarized data with standard deviations, standard errors, and convidence intervals, which will be useful for plotting.

```r
# Load the summarySE function
#install.packages("doBy") # Run this if you don't have this package already
#install.packages("survival") # Run this if you don't have this package already
# Make sure the summarySE.R file that you downloaded is in your working directory and run the following:
source("summarySE.R") # to make the function available for you to use

# Create a summary of the data
dataFLsumm <- summarySE(dataFL, measurevar="TPCP", groupvars=c("STATION_NAME", "YEAR"))
#dataFLsumm <- summarySE(dataFL, measurevar="MNTM", groupvars=c("STATION_NAME", "YEAR"))

dataFLsumm <- dplyr::filter(dataFLsumm, N==12) # only count those years with 12 months of data
```

## Plot data ##
Now it's time to plot the data.  We will plot the data using the powerful package `ggplot2`.  Once you learn how the syntax works for plotting one type of ggplot2 plot, you will be able to easily plot most other types of plots using the `ggplot2` package.  

**Very helpful reference site for ggplot2:**  
[http://docs.ggplot2.org/current/](http://docs.ggplot2.org/current/)

```r
## Plot the data ##
require("ggplot2")

ggplot(data=dataFLsumm, aes(x=YEAR, y=TPCP, group=STATION_NAME, colour=STATION_NAME)) + 
  geom_errorbar(aes(ymin=TPCP-se, ymax=TPCP+se), width=2) + # Add/adjust errbars
  geom_line(size=0.8) + 
  geom_point(size=2.5) +
  xlab("Year") + # Set x-axis label
  ylab("Average precipitation") + # Set y-axis label
  #labs(title=title) + # Set plot title
  theme_bw()
```

Hmm... error bars are too crowded and hard to see.  Let's try `geom_ribbon` instead.  We can leave the `geom_errorbar` code there and just comment it out, in case we decide to revert to that later.

```r
ggplot(data=dataFLsumm, aes(x=YEAR, y=TPCP, group=STATION_NAME, colour=STATION_NAME)) + 
  #geom_errorbar(aes(ymin=TPCP-se, ymax=TPCP+se), width=2) + # Add/adjust errbars
  geom_ribbon(aes(ymin=TPCP-se, ymax=TPCP+se), alpha = 0.3) +
  geom_line(size=0.8) + 
  geom_point(size=2.5) +
  xlab("Year") + # Set x-axis label
  ylab("Average precipitation") + # Set y-axis label
  #labs(title=title) + # Set plot title
  theme_bw()
```

That looks much better!  
 
---
  
Next, if we wanted to plot the temperature (**MNTM**) data, we only need to go back and change the code in a few places.

```r
ggplot(data=dataFLsumm, aes(x=YEAR, y=MNTM, group=STATION_NAME, colour=STATION_NAME)) + 
  #geom_errorbar(aes(ymin=MNTM-se, ymax=MNTM+se), width=2) + # Add/adjust errbars
  geom_ribbon(aes(ymin=MNTM-se, ymax=MNTM+se), alpha = 0.3) +
  geom_line(size=0.8) + 
  geom_point(size=2.5) +
  #scale_colour_hue(name="",  labels=c("Texas", "Florida", "Missouri", "New York", "Alaska")) + #temp#
  xlab("Year") + # Set x-axis label
  ylab("Average temperature") + # Set y-axis label
  #labs(title=title) + # Set plot title
  theme_bw()
```

**This file contains the code from today:**  
[R file with today's code](/Rsite/files/20160421 R tutorial - day 1.R)  
*Don't look too far, this file may contain spoilers!*

**Next up:** making this all into a function!