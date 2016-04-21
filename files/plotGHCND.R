#################################
# 4/18/2016                     #
# Sven Nelson                   #
# Function: plotGHCND           #
#################################

# Data from: http://www.ncdc.noaa.gov/cdo-web/results
# GHCND (Global Historical Climatology Network)-Monthly Summaries is a database that addresses the critical need for historical monthly temperature, precipitation, and snow records over global land areas.  

# This function requires that you also have the function summarySE() loaded, so this line will load that function if the file summarySE is in your working directory
source("summarySE.R") # put it in your working directory

# FileName input is the path to a .csv file downloaded from the site above
plotGHCND <- function(fileName = file.choose(), measure_var = "TPCP", year_min = 1933, year_max = 2018, printFilePath = T, stationList = NULL, returnSummary = F) {
  # Import data
  data <- read.csv(fileName, header = T, na.strings = "-9999", stringsAsFactors = F)
  
  if (printFilePath) {
    writeLines(paste("File loaded:\n\t",fileName,""))
  }
  # TPCP = Total precipitation amount for the month (inches to hundredths)
  # MNTM = Mean Normal Temperature Monthly (Mean monthly temperature)
  
  # Lets look at how the average precipitation for a year (across all 12 months) has changed over the years from 1931 to 2015
  # To do this, we'll want to consider all values with the same year
  
  # split 194210 into two columns: 1940 + 10
  dateColumn <- as.character(data$DATE) # makes it into a string
  data$YEAR <- as.integer(substring(dateColumn, first = 1, last = 4))
  data$MONTH <- as.integer(substring(dateColumn, first = 5, last = 7))
  
  # And subset the table to only include the columns that you want
  require("dplyr") # makes it easy to subet data
  attach(data)
  if (measure_var == "TPCP") {
    data <- data.frame(STATION_NAME, YEAR, MONTH, TPCP)
    detach(data)
    data <- dplyr::filter(data, !is.na(TPCP)) # remove rows with NAs
  } else if (measure_var == "MNTM") {
    data <- data.frame(STATION_NAME, YEAR, MONTH, MNTM)
    detach(data)
    data <- dplyr::filter(data, !is.na(MNTM)) # remove rows with NAs
  } else {
    detach(data)
  }
  #print("test2")
  #detach(data)
  
  # The location names are too long, lets shorten them to just the state name
  # To do this, first we need to extract the 2 letter state abbreviation from
  # each station name in our dataframe.  
  stateAbbrev <- substring(data$STATION_NAME, first = nchar(as.character(data$STATION_NAME)) - 4, last = nchar(as.character(data$STATION_NAME)) - 3) 
  # last digits of name are: FL US
  
  # Next we can use the built-in R tools to convert state abbreviations into state names.
  data$STATION_NAME <- state.name[match(stateAbbrev,state.abb)]
  
  # Create a summary of the data
  dataSumm <- summarySE(data, measurevar=measure_var, groupvars=c("STATION_NAME", "YEAR"))
  #print("test3")
  # Ommit rows where the a specific year does not have 12 months represented (1 - 12)
  #require("dplyr") # makes it easy to subet data
  dataSumm <- dplyr::filter(dataSumm, N==12) # only count those years with 12 months of data
  
  # Add code to specify a subest of stations
  if (!is.null(stationList)) {
    dataSumm <- dplyr::filter(dataSumm, STATION_NAME %in% stationList)
    # Filter dataSumm: only rows whose STATION_NAME is in the stationList
  }
  
  # Return the Summary data frame if returnSummary = TRUE
  if (returnSummary) {
    return(dataSumm) # Once we return something the function ends
  }
  
  ## Plot the data ##
  require("ggplot2")
  require("scales")
  #print("test4")
  if (measure_var == "TPCP") {
    ggplot(data=dataSumm, aes(x=YEAR, y=TPCP, group=STATION_NAME, colour=STATION_NAME)) + 
      coord_cartesian(xlim=c(year_min, year_max)) + # set the limits of the y axis
      geom_ribbon(aes(ymin=TPCP-se, ymax=TPCP+se), alpha = 0.3) + # Error ribbon
      geom_line(size=0.8) + 
      geom_point(size=2.5) +
      scale_x_continuous(breaks = pretty_breaks(n=16)) +
      scale_colour_hue(name="") +
      #scale_colour_hue(name="",  labels=c("Texas", "Florida", "Missouri", "New York", "Alaska")) + # Set legend labels (make them a bit shorter)
      xlab("Year") + # Set x-axis label
      ylab("Average precipitation") + # Set y-axis label
      #labs(title=title) + # Set plot title
      theme_bw()
  } else if (measure_var == "MNTM") {
    ggplot(data=dataSumm, aes(x=YEAR, y=MNTM, group=STATION_NAME, colour=STATION_NAME)) + 
      coord_cartesian(xlim=c(year_min, year_max)) + # set the limits of the y axis
      geom_ribbon(aes(ymin=MNTM-se, ymax=MNTM+se), alpha = 0.3) + # Error ribbon
      geom_line(size=0.8) + 
      geom_point(size=2.5) +
      scale_x_continuous(breaks = pretty_breaks(n=16)) +
      scale_colour_hue(name="") +
      #scale_colour_hue(name="",  labels=c("Texas", "Florida", "Missouri", "New York", "Alaska")) + # Set legend labels (make them a bit shorter)
      xlab("Year") + # Set x-axis label
      ylab("Average temperature") + # Set y-axis label
      #labs(title=title) + # Set plot title
      theme_bw()
  }
}