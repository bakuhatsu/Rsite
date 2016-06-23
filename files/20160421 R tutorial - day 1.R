#################################
# 4/18/2016                     #
# Sven Nelson                   #
# R tutorial: precipitation     #
#################################

# Data from: http://www.ncdc.noaa.gov/cdo-web/results
# GHCND (Global Historical Climatology Network)-Monthly Summaries is a database that addresses the critical need for historical monthly temperature, precipitation, and snow records over global land areas.  

# For this example: Choose Monthly Summaries
# Choose Custom Monthly Summaries of GHCN-Daily CSV
# Choose TPCP and MNTM

# move to your working directory
getwd() # returns your current working directory

# you can type the command below or just use the files tab in Rstudio to navigate to the folder, then select: More > Set As Working Directory
setwd("~/CloudStation/R_tutorial_series/working directory")

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

# Write out a dataframe to a csv and you can open in excel and save it as an xls
write.csv(x = data_FL, file = "ClimateDataset_Florida.csv", row.names = F)
# R can also write directly to xls or xlsx using packaged like WriteXLS().

# dataFrame[rows, columns] 
head(dataFL)
tail(dataFL)

summary(dataFL$TPCP)

# TPCP = Total precipitation amount for the month (inches to hundredths)
# MNTM = Mean Normal Temperature Monthly (Mean monthly temperature)

# Lets look at how the average precipitation for a year (across all 12 months) has changed over the years from 1931 to 2015
# To do this, we'll want to consider all values with the same year

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

# Load the summarySE function
#install.packages("doBy") # Run this if you don't have this package already
#install.packages("survival") # Run this if you don't have this package already
source("summarySE.R") # put it in your working directory

# Create a summary of the data
dataFLsumm <- summarySE(dataFL, measurevar="TPCP", groupvars=c("STATION_NAME", "YEAR"))
#dataFLsumm <- summarySE(dataFL, measurevar="MNTM", groupvars=c("STATION_NAME", "YEAR"))

dataFLsumm <- dplyr::filter(dataFLsumm, N==12) # only count those years with 12 months of data

## Plot the data ##
require("ggplot2")

ggplot(data=dataFLsumm, aes(x=YEAR, y=TPCP, group=STATION_NAME, colour=STATION_NAME)) + 
  #geom_errorbar(aes(ymin=TPCP-se, ymax=TPCP+se), width=2) + # Add/adjust errbars
  geom_ribbon(aes(ymin=TPCP-se, ymax=TPCP+se), alpha = 0.3) +
  geom_line(size=0.8) + 
  geom_point(size=2.5) +
  #scale_colour_hue(name="",  labels=c("Texas", "Florida", "Missouri", "New York", "Alaska")) + #temp#
  xlab("Year") + # Set x-axis label
  ylab("Average precipitation") + # Set y-axis label
  #labs(title=title) + # Set plot title
  theme_bw()


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


# make into functions
# variables: file, measure_var, year_min and year_max

plotGHCND()
plotGHCND("/Users/sven/CloudStation/R_tutorial_series/working directory/ClimateDataset_Florida.csv")
plotGHCND(measure_var = "MNTM")

data2 <- plotGHCND(returnSummary = T)

# Then use manipulate to run the function and change these values on the fly
library(manipulate) # Only available in RStudio
dataFile <- file.choose() # select the file outside of the manipulate call
manipulate(
  plotGHCND(fileName = dataFile, measure_var = mv, year_min = yMn, year_max = yMx, printFilePath = F),
  mv = picker("Average precipitation" = "TPCP",
              "Average temperature" = "MNTM",
              label="Measurement"),
  yMn = slider(1933,2015, step = 1, initial = 1933, label = "Starting year"),
  yMx = slider(1930,2018, step = 1, initial = 2018, label = "Ending year")
)

# Then use manipulate to run the function and change these values on the fly
library(manipulate) # Only available in RStudio
dataFile <- file.choose() # select the file outside of the manipulate call
states <- c("Florida", "Hawaii", "Michigan","Missouri", "New York", "Texas", "Utah")
manipulate(
  plotGHCND(fileName = dataFile, measure_var = mv, year_min = yMn, year_max = yMx, printFilePath = F, stationList = states[c(a,b,c,d,e,f,g)]),
  mv = picker("Average precipitation" = "TPCP",
              "Average temperature" = "MNTM",
              label="Measurement"),
  yMn = slider(1933,2015, step = 1, initial = 1933, label = "Starting year"),
  yMx = slider(1930,2018, step = 1, initial = 2018, label = "Ending year"),
  a = checkbox(TRUE, states[1]),
  b = checkbox(TRUE, states[2]),
  c = checkbox(TRUE, states[3]),
  d = checkbox(TRUE, states[4]),
  e = checkbox(TRUE, states[5]),
  f = checkbox(TRUE, states[6]),
  g = checkbox(TRUE, states[7])
)

