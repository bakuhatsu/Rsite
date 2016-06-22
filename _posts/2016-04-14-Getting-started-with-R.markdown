---
layout: post
title: Getting started with R
author: Sven Nelson
categories: [R tutorial]
tags: [Part 1]
---
This is the first installation of the R tutorial for biologists.  This tutorial is designed to teach the basics of R without drowning you in statistics.

## Why R?##
**Premise for the course:**  
Learning to swim with R without drowning in statistics.  R is not just for statisticians and it can be difficult to pick up R if you are also trying to learn the statistics at the same time.   

Here are some reasons to use R and examples of useful things you can do in R:

- Plenty of built-in function for statistics incuding: correlations, t-tests, non-parametric tests (ex: Mann Whitney U, Wilcoxon Signed Rank, Kruskall Wallis Test, Friedman Test), ANOVA, ANCOVA, MANCOVA, cluster analysis (ex: partitioning (k-means), hierarchical agglomerative, and model based), generalized linear models (ex: logistic regression, poisson regression, and survival analysis), bootstrapping, matrix algebra, ...and the list goes on.

- generate beautiful plots (example below from [http://www.cookbook-r.com](http://www.cookbook-r.com))
![image](http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/figure/unnamed-chunk-3-1.png)

- analyze images (ex: [EBImage](http://www.bioconductor.org/packages/2.13/bioc/html/EBImage.html), [archiDART: an R package for the automated computation of plant root architectural traits] (http://link.springer.com/article/10.1007/s11104-015-2673-4/fulltext.html) (shown below))
![image](https://static-content.springer.com/image/art%3A10.1007%2Fs11104-015-2673-4/MediaObjects/11104_2015_2673_Fig2_HTML.gif)

- Process microarray, RNAseq, ChIP-seq, and RT-qPCR data, while having full control over your data

- make unique types of plots that nobody else has thought of (and therefore do not exist in excel or other programs).  An example of a unique way of plotting data: [OmicCircos: A Simple-to-Use R Package for the Circular Visualization of Multidimensional Omics Data](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3921174/) 
![image](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3921174/bin/cin-13-2014-013f1.jpg)
*Circular plots by OmicCircos of expression, CNV, and fusion proteins in 15 Her2 subtype samples from TCGA breast cancer data. Circular tracks from outside to inside: genome positions by chromosomes (black lines are cytobands), expression heatmap of 2000 most variable genes whose locations are indicated by elbow connectors, CNVs (red: gain, blue: loss), correlation p-values between expression and CNV, fusion proteins (intra/inter chromosomes: red/blue). Chromosomes 1–22 are shown in the right half of the circle. Zoomed chromosomes 11 and 17 are displayed in the left half.*

- Reformat dataframes, search excel sheets, remove duplicates, combine multiple spreadsheets and output one with only the desired data, in the desired format.  This can be very powerful when you have very large spreadsheets that you could not possibly edit by hand. For example... 

You have a spreadsheet with columns like this and a very large number of rows:  

| Sample name		| measurement	 | ... |
|:-----------------:|:---------------:|:---------------:|
| Col wt 12days watered #1  	| 24.7 | ... |
| Col wt 12days watered #2  	| 21.2 | ... |
| Col wt 12days watered #3  	| 23.5 | ... |
| Col wt 12days drought #1  	| 13.6 | ... |
| Col wt 12days drought #2  	| 17.7 | ... |
| Col wt 12days drought #3  	| 14.0 | ... |
| ...  	| ... | ... |

You can use R to quickly convert it to a spreadsheet with columns like this:

| ecotype | imibibition time | condition | rep		| measurement	 | ... |
|:------:|:------:|:------:|:------:|:------:|:------:|
| Col wt | 12days | watered | #1	| 24.7 | ... |
| Col wt | 12days | watered | #2	| 21.2 | ... |
| Col wt | 12days | watered | #3	| 23.5 | ... |
| Col wt | 12days | drought | #1	| 13.6 | ... |
| Col wt | 12days | drought | #2	| 17.7 | ... |
| Col wt | 12days | drought | #3	| 14.0 | ... |
| ... | ... | ... | ... | ... | ... |

Or even conditionally replace text/add abbreviations as desired and get this:

| ecotype | imibibition <br>time (days) | Well Watered <br>or Water Stress | rep		| measurement	 | ... |
|:------:|:------:|:------:|:------:|:------:|:------:|
| Col wt | 12 | WW | 1	| 24.7 | ... |
| Col wt | 12 | WW | 2	| 21.2 | ... |
| Col wt | 12 | WW | 3	| 23.5 | ... |
| Col wt | 12 | WS | 1	| 13.6 | ... |
| Col wt | 12 | WS | 2	| 17.7 | ... |
| Col wt | 12 | WS | 3	| 14.0 | ... |
| ... | ... | ... | ... | ... | ... |   

- Shiny webapps: interactive plots that can be viewed from a web browser [http://shiny.rstudio.com](http://shiny.rstudio.com)  
See also: `flexdashboards` and `shinydashboards`
![image](http://rmarkdown.rstudio.com/flexdashboard/images/shiny-biclust.png)  
[https://jjallaire.shinyapps.io/shiny-biclust/]()

- LaTeX tables suitible for publication can be directly generated from your data

- pretty much anything… R is a fully featured programming language.  You can make it do anything that you want.  You can even make calls to other programming languages (like python, perl, and C++) or the command line from within R.  

**When should you use R?:** A good rule of thumb is that it will be worth the time writing the code if it is anything you will repeat 5 or more times (even simple things you could do in excel).  Write once, use forever.  

## Why RStudio ##

This tutorial will be taught with [RStudio](https://www.rstudio.com).  With most programming languages, there are a lot of good IDEs (Integrated Development Environments) for you to choose from.  With R there are not so many and RStudio has really set the bar as the IDE to use.  (Although the [RKWard](https://rkward.kde.org) IDE has such an apt name.)  One of the reasons for this is because [the people who are developing RStudio](https://www.rstudio.com/about/) include some of the biggest contributers to R packages such as Hadley Wickham, whose work includes `ggplot2`, `plyr`, `reshape`, `lubridate`, `stringer`, `httr`, `roxygen2`, `testthat`, `devtools`, `lineprof`, and `staticdocs`.  RStudio also adds functionalities that are not available with the default R gui that comes bundled when you download R.  For example, you can click the back arrow to see your previous plots, you can save images in any size or format using the drop-down menu, and you can keep track of the variables in your current environment in the environment pane (and even click on data frames to give an excel-like preview without exporting).  And that is just to name a few of the features.  So let's get going, open RStudio and continue reading with the next post.

