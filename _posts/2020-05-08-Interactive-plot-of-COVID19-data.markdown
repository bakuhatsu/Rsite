---
layout: post
title: Getting an always up-to-date COVID dataset
image: images/20200507_COVID-19_plot.svg
author: Sven Nelson
categories: [R tutorial]
tags: [Part 4]
---
Here's another example.  We're all stuck sheltering at home, so why don't we make an interactive plot of COVID-19 data.  I'll put the initial code below and you can use that as a starting point and tweak or update as you please. 

## Getting an always up-to-date COVID dataset ##

It turns out there is a great package for this.  It has a CRAN version (which is what I recommend) and a version on Github.  The Github version is newer and starts with more recent data, but both should be able to be updated to the newest data every day if you follow the guide below.  (I will post the instructions for the Github version, too, just in case the update code doesn't work for you with the CRAN version, as some of us had issues when we tried last time.)   
  
**Recommended (CRAN) installation:**  

*UPDATE: probably easiest to just skip to the GitHub install to make it work for sure.*

```r
# Install the 'coronavirus' package
install.packages("coronavirus") 

# Load package:
library(coronavirus)

# Load data into your environment as variable "coronavirus"
data("coronavirus")

# You can use this like any other dataframe, but it will take a second the first time you use it to load.  After that, it should be fast. 
head(coronavirus) # to test

# What is the most recent data in this dataset?
max(coronavirus$date)#[1] "2020-02-16"

# So we want to update the dataset
coronavirus::update_dataset()
# This may not work depending on the version of R you are running, which may affect the version of coronavirus that gets installed for you.  

# Use the Github install instructions below if you get the error: 
#Error: could not find function "update_datasets"
```
If you don't get an error, you will need to restart your R session before the update will work, then run:  
  
```r
rm(coronavirus)
library(coronavirus)
data("coronavirus") # This reloads the new version
```
  
**Github installation:**  
Use this method if the CRAN method doesn't work. 

```r
# Make sure devtools in installed and loaded
install.packages("devtools")
library(devtools)

# Remove coronavirus from CRAN to be safe
remove.packages(coronavirus) # skip if you didn't do CRAN install

# Remove the 'coronavirus' dataset from your environment if loaded
rm(coronavirus)

# Install the 'coronavirus' package
install_github("covid19r/coronavirus") 

# Load package:
library(coronavirus)

# Load data into your environment as variable "coronavirus"
data("coronavirus")

# You can use this like any other dataframe, but it will take a second the first time you use it to load.  After that, it should be fast. 
head(coronavirus) # to test

# What is the most recent data in this dataset?
max(coronavirus$date)#[1] "2020-02-16" # you might get a newer value that from the CRAN version, or you might get the same

# So we want to update the dataset
coronavirus::update_dataset()

#### RESTART R SESSION ####
# Remove the 'coronavirus' dataset from your environment if loaded
rm(coronavirus)

# Load package:
library(coronavirus)

# Load data into your environment as variable 'coronavirus'
data("coronavirus")

# What is the most recent data in this dataset?
max(coronavirus$date)#[1] "2020-05-07"

```

Ok, now we are ready for the function code.


## A function to plot COVID-19 data ##
This function will use the 'coronavirus' dataframe (really, tibble) and plot cases against time divided by type of case.    
  
```r
covidTimecourse <- function(data = coronavirus, metric = "cases", country = "US", log_scale = FALSE, cumulative = TRUE) {
  if (!is.null(country)) { # country = "US"
    data <- dplyr::filter(data, Country.Region == country)
  } else {
    stop("No country selected, please specify a country.")
  }
  if (cumulative) {
    data[data$type == "confirmed",]$cases <- cumsum(data[data$type == "confirmed",]$cases)
    data[data$type == "death",]$cases <- cumsum(data[data$type == "death",]$cases)
    data[data$type == "recovered",]$cases <- cumsum(data[data$type == "recovered",]$cases)
    
  }
  # This line is only necessary for a few countries where there are multiple measurements per date to summarize the data.
  data <- Rmisc::summarySE(data, measurevar = metric, groupvars = c("date","Country.Region", "type"))
  
  data$date <- as.POSIXct(as.Date(data$date, format = "%Y%m%d"))
  
  ## Set up breaks for date (1 break per week)
  date_ticks <- unique(data$date)[seq(1, length(unique(data$date)), 7)]
  
  library(ggplot2)
  library(scales)
  
  scientific_10 <- function(x) {
    parse(text = gsub("e\\+", "%*%10^", scales::scientific_format()(x)))
  }
  
  plot <- ggplot(data, aes(x = date, y = get(metric), color = type)) +   
    #geom_errorbar(aes(ymin=get(metric)-se, ymax=get(metric)+se), width=.4, color="black") +
    geom_line() +
    geom_point(aes(shape = type)) +
    ggtitle(paste0("Number of cases in ", country)) +
    ylab("Number of cases") +
    theme_bw() +
    xlab(label = "Date") +
    scale_x_datetime(date_labels = "%b %d", breaks = date_ticks) +
    scale_y_continuous(labels = scientific_10) +
    scale_colour_manual(name = "type",
                        breaks = c("confirmed", "death", "recovered"),
                        values = c("#999999", "#E69F00", "#56B4E9"), 
                        labels = c("confirmed", "death", "recovered")) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          plot.title = element_text(hjust = 0.5))#,
  
  if (log_scale) {
    plot <- plot + scale_y_log10(labels = scientific_10)
  }
  return(plot)
}
```
  
##You can also run it with individual parameters set:##

```r
# Standard plot for USA
covidTimecourse()

# USA plot with log scale
covidTimecourse(log_scale = TRUE)

# USA plot of cases per day, not cumulative cases
covidTimecourse(cumulative = FALSE)

# Standard plot for New Zealand
covidTimecourse(country = "New Zealand",log_scale = TRUE)

# New Zealand plot with log scale
covidTimecourse(country = "New Zealand",log_scale = TRUE)

# What other country options do you have?
unique(coronavirus$Country.Region)

# Country names must by typed as in this list.

```

## Output nice high quality plots ##
You can output nice plots from the drop-down menu, but if you want high quality plots that are vector graphics (small file size, but always high quality no matter how much you zoom in), then don't use the drop-down menu.  

Use this method:
  
```r
wide <- 5.00
high <- 3.00

plt <- covidTimecourse()
plotname <- "20200507 COVID-19 plot.svg"
ggsave(filename = plotname, plot = plt, width = wide, height = high, units = "in")
```
  
These SVG can be displayed in a web browser, can be dragged and dropped into powerpoint, and can be used in web pages like this one.
  
![](/Rsite/images/20200507_COVID-19_plot.svg)  
  
## Make the plot interactive in RStudio ##
Use the manipulate package:

If you haven't installed it, install manipulate with: 
  
```r
install.packages("manipulate")
```
  
Not for the main event:  

```r
library(manipulate)
manipulate(
  covidTimecourse(country = country, log_scale = scale, cumulative = cum),
  country = picker("US", "New Zealand", "Japan", "Netherlands", "China", "Chile", "Mexico", "Canada", "United Kingdom", "Spain", "Sri Lanka"),
  scale = checkbox(initial = FALSE, label = "Use log scale:"),
  cum = checkbox(initial = TRUE, label = "Cumulative data:")
)
```

Click the gear in the plot window and adjust the settings. 

**Try adding a line for "active cases" which would be confirmed - (deaths + recovered)**  

```r
# maybe we will add your code here next time...

```


