---
layout: post
title: Getting started with R
---
Getting started with R for microarray analysis
============
*9/7/2014*  
**Sven Nelson**

## Understanding the physics of the R universe ##

### Running R code ###
Although programming can be picked up bit-by-bit through memorization of small pieces of code, it is much more efficient to spend a little time to learn the rules of the language — the physics of the R universe — which you can then apply to reading or writing code that you have not previously memorized.

<!-- 
->![image](RStudio_left_half.png =500x)<-
-->

![image](/images/RStudio_screenshot.png)

Most of what you will do in R will be in the interpreter.  It is very rare that you will need to write a full program, save it, and execute it.  More often, you will directly enter a command into the interpreter (**bottom-left**), or write a couple of lines of code in a text file (**top-left**) and select this block of code for execution in the interpreter window (**bottom-left**).  

### Setting the value of variables ###

At its core programming really comes down to getting and setting values of variable.  In most languages `=` is used as the symbol for defining a variable.  Although `=` will work in R, it is not recommended, since the equals sign is used most often in R to set parameters of a function (such as `plot(x = age, y = height)`), while `a == b` tests the logical statement of whether two values (a and b) are equal to one another.

Instead of `=`, R used `<-` and `->` arrows to set the value of variables.  So if you wanted to set x equal to 4, then you could type:


```r
# most common
x <- 4

# or
4 -> x

# and also (not recommended)
x = 4 # this is equivalent to x <- 4
```

### Vector math in R ###

One of the great benefits of R over some other programming languages is the ability to apply a command to a vector as easily as to a single variable.  For example (`>` indicates running these commands in the interpreter):

```r 
> x <- 1
> y <- 2
> x + y
[1] 3
> x <- c(1,2,3) # a vector of 3 numbers
> x + y
[1] 3 4 5
> y <- c(3,2,1) # now both x and y are vectors
> x + y
[1] 4 4 4
```
As you can see, we can add 1 and 2 to get three, **or** add 1 to each of the three numbers in the second case to get 3, 4, and 5, **or** we can add two sets of three numbers to each other.  These same rules apply for other mathematical operations.

**Note: Be careful of spaces**
If you put spaces in the wrong spot you can sometimes get very different results, try to be consistent for easy-to-read code and to minimize mistakes due to unindended commands.

**QUIZ:** What is the output of each of the commands below? What is the value of x and of y after running these commands?  

```r
# rerun these commands before each number
x <- 1
y <- 2

# 1
x <- y

# 2
x<-y

# 3
x <-y

# 4
x< -y

# 5
x <-y

# 6 
x<--y

```

This ability to do the same process over a vector as over a single value also applies to many R functions:

```r
> toupper("a") # this function changes letters to uppercase
[1] "A"
> z <- c("a","b","c","d")
> toupper(z)
[1] "A" "B" "C" "D"
```  

**Note: Recycling Rule**   
If two vectors are of unequal length, the shorter one will be recycled in order to match the longer vector. For example, the following vectors u and v have different lengths, and their sum is computed by recycling values of the shorter vector u.

```r
> u = c(10, 20, 30) 
> v = c(1, 2, 3, 4, 5, 6, 7, 8, 9) 
> u + v 
[1] 11 22 33 14 25 36 17 28 39
```

You can remove a variable with the `rm()` function.

```r
> zebra <- c(32, 12, 5)
> zebra
[1] 32 12  5
> rm(zebra) # remove "zebra" variable
> zebra
Error: object 'zebra' not found
```

#### Comparing with loops ####
You can do the same thing with a loop, but it takes much more computer time.  You wouldn't notice this for a vector containg three numbers, but if your vector contains 20,000 numbers (like a transcriptome dataset) then the loss is speed is quite noticable.  

**Try this:**

```r
# generate a vector of 200,000 random numbers between 1 and 1,000,000,000
z <- sample(1:1000000000, 200000)

# calculate the square of all 200,000 numbers, then print "Done!"
zsquared <- z^2
print("Done!")
# Print the first 10 values
print(zsquared[1:10])

# calculate the square of all 200,000 numbers USING A LOOP, then print "Done!"
zsquaredloop <- c()
for (i in 1:length(z)) {
  zsquaredloop[i] <- z[i]^2
}
print("Done!")
# Print the first 10 values
print(zsquaredloop[1:10])

```

Which way was faster?  Be careful of using loops when there is a faster way if you are dealing with large datasets.

### Data types in R ###
This post on QuickR give exactly the description I want for this section, so why re-write it:  
[http://statmethods.net/input/datatypes.html] (http://statmethods.net/input/datatypes.html)

Major types include:  

| Data type     | Description     | 
|:------------- |:--------------- | 
| vectors       | make these with `c()` | 
| matrices      |                       
| data frames   | like an excel sheet, fixed number of rows and columns |
| lists         | very similar to vectors, but some functions require one or the other (create with `list()` or change to not a list with `unlist()` |
	

## R functions##

Functions are a bunch of R code set up in such a way that it can be reused to perform a similar function by simply passing it different input variables.  

Functions usually have an input variable or variables and often return an output, print something to the screen, or display a graphic.  

Here is the structure of a function (it is basically the same for the functions that I have written and for those that are provided in packages:

```r
# Standard Error function:
stderr <- function(x) {
	y <- sqrt(var(x)/length(x))
	return(y)
}

```

And here is how you would run that function: 

```r
> GA_levels_example <- c(2.5, 3.1, 2.66, 3.49, 4)
> stderr(GA_levels_example)
[1] 0.2741532
```
Your input variable is passed as `x` in the functon `stderr(x)` and the function calculates the standard error using the variable that you gave it.  This is saved to `y` and then the function "returns" `y`.  Sometimes a function just "prints" the output to the screen, but by "returning" the value it allows you to save that into another variable.  

For example you could do this:

```r
> a <- stderr(GA_levels_example)
> 
> ABA_levels_example <- c(55, 44, 66, 54, 56)
> b <- stderr(ABA_levels_example)
> 
> a > b # use this command to ask "is a greater than b?"
[1] FALSE

``` 

This allows us to easily do complex calculations without writing out all of the code for individual commands.  Above, we showed that the standard error for the GA measurements was not larger than the standard error for the ABA measurements (just a random example).  Nesting these sorts of calls — making function calls on the returned value of other functions — is the basis of all R data analysis.  We want to type the least amount of code to get the work done.


## Lets dive in: importing a micorarray dataset from raw CEL files ##

Ok, I know you have been anxious to get to this point.  

1. Download a dataset from somewhere like ArrayExpress.  This should contain a bunch of .CEL files.  Put this all in a folder somewhere and change that to your working directory with `setwd()` or using the RStudio drop down menu.

```r
setwd("~/Microarray Data Folder")
```

2. Next you need to make a targets.txt file which identifies your CEL files and tells R which are replicates of the same condition.

```r
# You need to make the tab-separated Targets.txt file of the format:

Name	FileName	Target
LerDry.1	Sven-Ler1_Dry-032312-1.CEL	WildType_Dry
LerDry.2	Sven-Ler2_Dry-032312-2.CEL	WildType_Dry
LerDry.3	Sven-Ler3_Dry-032312-3.CEL	WildType_Dry
sly1-2DDry.1	Sven-sly1-2D1_Dry-032312-4.CEL	Dormant_Dry
sly1-2DDry.2	Sven-sly1-2D2_Dry-032312-5.CEL	Dormant_Dry
sly1-2DDry.3	Sven-sly1-2D3_Dry-032312-6.CEL	Dormant_Dry
sly1-2ARDry.1	Sven-sly1-2AR1_Dry-032312-7.CEL	After-ripened_Dry
sly1-2ARDry.2	Sven-sly1-2AR2_Dry-032312-8.CEL	After-ripened_Dry
sly1-2ARDry.3	Sven-sly1-2AR3_Dry-032312-9.CEL	After-ripened_Dry
sly1-2GID1bDry.1	Sven-sly1-2GID1b1_Dry-032312-10.CEL	GID1b-overexpression_Dry
sly1-2GID1bDry.2	Sven-sly1-2GID1b2_Dry-032312-11.CEL	GID1b-overexpression_Dry
sly1-2GID1bDry.3	Sven-sly1-2GID1b3_Dry-032312-12.CEL	GID1b-overexpression_Dry

# In this file, the "FileName" is the exact filename of the raw *.CEL files
# Place this file in your working directory (in this example: "~/Microarray Data Folder")
```

3. Now run the following code for importin the data:

```r
Targets <- readTargets("Targets.txt")
exampleData <- ReadAffy(filenames=Targets$FileName)
View(Targets) # In RStudio, allows you to see if you read in the targets file correctly
```

4. Not perform background correction and normalization:

```r
# Boxplot of data before normalization/background correction
boxplot(exampleData,names=Targets$Name,las=2)
## The following will display ##
# Background correcting
# Normalizing
# Calculating Expression

# Boxplot of data after normalization/background correction
boxplot(data.frame(exprs(esetExampleData.rma)),names=SvenDryTargets$Name,las=2)
pData(esetSvenDry.rma) # make sure you loaded the correct files
```

5. Make a backup of the expression set and remove probes that are duplicate, control probes, or probes that do not have a corresponding AGI identifier (eg deprecated probes).

```r
# backup for safety
if (is.null(esetSvenDry.rma.backup)) {
  esetSvenDry.rma.backup <- esetSvenDry.rma  #do not run again or you will overwrite the backup
}

# Now modify esetSvenDry.rma
# Use default settings, removes duplicates, probes with no corresponding AGI ID, and control probes
esetSven.rma <- featureFilter(esetSven.rma.backup)
# same as nsFilter, but no removal of low variance probesets

## For similar setting using nsFilter:

#esetSven.rma <- nsFilter(esetSven.rma.backup, var.filter = FALSE,na.rm=TRUE) 
# if you do this one then the next steps use esetSven.rma$eset (and it must be changed everywhere because nsFilter outputs the file in a different format than featureFilter)

```

6. Making the design matrix:

```r
# write.exprs(esetSvenDry.rma,file="esetSvenDryRMA.txt")
## To load this from file:
# esetdata <- read.table(file="~/Microarray\ Data/Microarray\ Data\ (renamed\ files)/esetSvenDryRMA.txt",sep="\t")
# esetSvenDry.rma <- new("exprSet",exprs = as.matrix(esetdata))
designSvenDry <- matrix(c(                                         
  1,0,0,0,1,0,0,0,1,0,0,0, 
  0,1,0,0,0,1,0,0,0,1,0,0, 
  0,0,1,0,0,0,1,0,0,0,1,0, 
  0,0,0,1,0,0,0,1,0,0,0,1
),byrow=TRUE,nrow=12)
colnames(designSvenDry) <- 
  c("WT_Dry", "D_Dry","AR_Dry","GID_Dry")
designSvenDry
```

7. Making the comparisons (contrast matrix):

```r
fitSvenDryIncludeControls <- lmFit(esetSvenDryIncludeControls.rma, designSvenDry)
contrast.matrixSvenDryIncludeControls <- makeContrasts(D_Dry-WT_Dry, AR_Dry-WT_Dry, AR_Dry-D_Dry, levels=designSvenDry)
fitSvenDry2IncludeControls <- contrasts.fit(fitSvenDryIncludeControls,contrast.matrixSvenDryIncludeControls)
fitSvenDry2IncludeControls <- eBayes(fitSvenDry2IncludeControls)
```

8. Determining significant differential regulation for all genes using false discovery rate for multiple comparison adjustment with a p-value cutoff of 0.05:

```r
resultsSvenDry1IncludeControls <- decideTests(fitSvenDry2IncludeControls, p.value=0.05)
# And plot the overlaps
vennDiagram(resultsSvenDry1IncludeControls)
```

=> **This post will be updated with more information, but for now, here is the first part** <= 