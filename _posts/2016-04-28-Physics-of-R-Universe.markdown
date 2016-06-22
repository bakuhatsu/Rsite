---
layout: post
title: Understanding the physics of the R universe
author: Sven Nelson
categories: [R tutorial]
tags: [Part 2]
---
Now that you know why to use R, lets get you started by explaining some of the basics of the R language.

## Start basic ##
Although programming can be picked up bit-by-bit through memorization of small pieces of code, it is much more efficient to spend a little time to learn the rules of the language — the physics of the R universe — which you can then apply to reading or writing code that you have not previously memorized.  This may feel a bit basic, but understanding the simple things about R will build a strong foundation to prepare you for advanced topics.  

{: .center}
![image](http://i2.wp.com/www.vagabondjourney.com/travelogue/wp-content/uploads/monty-python-phrasebook.jpg?w=512)  
*Image from [http://www.vagabondjourney.com/](http://www.vagabondjourney.com/11-most-important-things-to-know-how-to-say-in-a-foreign-language/)*  

Another way to think about this is that learning the grammar of a programming language is like learning the grammar of a foreign language vs using a phrasebook.  If you just paste together code that you find in the phrasebook then you will improve at a very slow pace, but with a very small amount of (more time consuming) explanation at the beginning, you can pick up the basics of the language, learn the physics of the R universe.  And then you can make it do whatever you want it to.
  
## Running R code ##

Coding is R is the closest that I have found to what programming/hacking looks like on TV.  For most programming languages, you won't be typing away furiously and executing code as you go.  Instead, you write a program, save it (and possibly compile it), and then run it.  

<!-- 
->![image](RStudio_left_half.png =500x)<-
-->
<!-- 
![image](../images/RStudio_screenshot.png)
-->

![image](/Rsite/images/RStudio_screenshot.png)

But in R, most of what you will do will be in the interpreter.  It is very rare that you will need to write a full program, save it, and execute it.  More often, you will directly enter a command into the interpreter (**bottom-left pane of RStudio**), or write lines of code in a text file (**top-left pane of RStudio**) and select this block of code for execution in the interpreter window by hitting <kbd>command ⌘</kbd> + <kbd>enter</kbd> (Mac) / <kbd>ctrl</kbd> + <kbd>enter</kbd> (Windows).  Type, execute, get results... how furiously you do this is entirely up to you. 

For a (slightly complicated-looking) pdf cheatsheet to using the RStudio IDE:  
[http://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf](http://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf)  

My (somewhat simpler) explanation:
  
| left half				| right half		 |
|:-----------------:|:---------------:|
| **text editor: <br>write R code**    	| **environment <br>and history**     |   
| **interpreter: <br>run R code**   | **plots, packages, <br>files, and help** |  


## Setting the value of variables ##

At its core programming really comes down to getting and setting values of variable.  In most languages `=` is used as the symbol for defining a variable.  Although `=` will work in R, it is not recommended, since the equals sign is used most often in R to set parameters of a function (such as `plot(x = age, y = height)`), while `a == b` tests the logical statement of whether two values (a and b) are equal to one another.

Instead of `=`, R uses `<-` and `->` arrows to set the value of variables.  So if you wanted to set x equal to 4, then you could type:


```r
# most common
x <- 4

# or
4 -> x

# and also (not recommended)
x = 4 # this is equivalent to x <- 4
```

## The usefullness of variables ##

Initially it may not seem obvious why it is so useful to use variables.  After all, we can do something like this in R without variables:  

```r
# To calculate the cost of my shopping
(20.99 + 25 + 15.05 + 3.50 + 17) * 1.078 
```
I add the values of the items and then add 7.8% tax.  But the code above is both not easy to read and not flexible to changes.  Using variables I can quickly and easily change one variable (such as the tax rate) and run the same code again.  I can also use the same variable in multiple places if needed (say if I wanted to do another list that included beets, but no carrots).    

```r
# To calculate the cost of my shopping
carrots <- 20.99 
beets <- 25
potatoes <- 15.05 
spinach <- 3.50 
marshmallows <- 17 
taxRate <- 7.8

total <- carrots + beets + potatoes + spinach + marshmallows
totalWithTax <- total * (1 + taxRate/100)
print(totalTaxRate)
```

**Note: Be careful of spaces**  
Compared to some other programming languages R is pretty flexible in accepting the way that you format your text, but occasionally if you put spaces in the wrong spot you can get very different results, try to be consistent for easy-to-read code and to minimize mistakes due to unindended commands.  A `<-` is use for assigning values, but a `-` can be a negative sign and a `<` can be a less than sign if they have a space in between.

**QUIZ:** What is the output of each of the commands below? What is the value of x and of y after running these commands?  

```r
# rerun these commands before each number
x <- 1
y <- 2
```
**At the start x is 1 and y is 2.**   
(To reveal answers mouse over whitespace after "Output:" and "Value of x and y:")

```r
# 1
x <- y
```
Output: **<span class="spoiler"><span>no output</span></span>**  
Value of x and y: **<span class="spoiler"><span>x is 2 and y is 2</span></span>**  

```r
# 2
x<-y
```
Output: **<span class="spoiler"><span>no output</span></span>**  
Value of x and y: **<span class="spoiler"><span>x is 2 and y is 2... still the same...</span></span>**  

```r
# 3
x <-y
```
Output: **<span class="spoiler"><span>no output</span></span>**  
Value of x and y: **<span class="spoiler"><span>x is 2 and y is 2... so far so good</span></span>** 

```r
# 4
x< -y
```
Output: **<span class="spoiler"><span>[1] FALSE</span></span>**  
Value of x and y: **<span class="spoiler"><span>values have not been changed, x is 1 and y is 2</span></span>**

```r
# 5
x<--y
```
Output: **<span class="spoiler"><span>no output</span></span>**  
Value of x and y: **<span class="spoiler"><span>x is -2 and y is 2</span></span>**


## For loops in R ##

In most programming languages, if you wanted to do the same action to every element of a list (or column) you would probably use a **for loop**.  We tend to think of a programming language as something that was made for a computer to read, when, in fact, it is quite the contrary.  Computers read code as `1010010101...` directly.  Programming languages were made for humans.  So the words that are used for commands in programming languages usually mean something similar to what they would mean in plain English.  

### Loops in the real world ###
Here is an example of a real world equivalent of a **for loop**:
You are a plant scientist who is labeling seed envelopes.  You have 1000 envelpes and 1 undergraduate researcher.  In this case, the undergraduate researcher is like the computer.  You need to give clear instructions on what to do **for** each envelope.  So you might say something like this:   
   
*"For each of these 1000 envelopes, count the seeds and label the envelope with today's date, the number of seeds, and your initials."*  
   
If I were to convert that to pseudo-code it might look something like this:  

   
```r
# This is not real code, it's just restructured like code
for (each of the 1000 envelopes) { # do everything between these braces  
	  count seeds -> number of seeds
	  print on envelope( today's date )
	  print on envelope( number of seeds )
	  print on envelope( your initials )
}
```  
So looking at the pseudo-code above, you can actually read it like a sentence in English.  This will be the same with code in R once you get used to the syntax.
    
### Loops in the R world ###
In R, there are there are two ways to do **for loops**:

If you have a vector of values like this:  

```r
animals <- c("cat", "dog", "pig", "camel")
```

1) Using the first method, you can do this:  

```r
for (animal in animals) {
	print(animal)
}
```

2) The other way to do this (which is somewhat more powerful) is the way that uses `i` (the index of an object in the list)   

```r
for (i in 1:length(animals)) {
	print(animals[i])
}
```

Both methods will print the same output: the name of each animal in the order given by the list, with one animal per line.  The only reason that the second method is "more powerful" is because it gives us access to `i`, rather than just the `i`<sup>th</sup> element of the list.  This means that we could use `i` to take the `i`<sup>th</sup> element of a different list (or maybe a different column of the same data frame, for example) and do something to that.    

Loops allow you do an action over a long list of items without rewriting the code for every item in the list.  This is very useful, but long loops can be slow to run in R...  

...Not to worry!  One of the greatest strengths of R is the ability to do vectorized actions.  Vectorization means doing something to all elements of a list at once and with (close to) the speed of doing the same action to one item of the list.  This means that you very rarely need to write loops in R, and should try to do things the vector way, rather than using a loop if it is an option.   

**For more thoughts on for loops in R:**  
[http://paleocave.sciencesortof.com/2013/03/writing-a-for-loop-in-r/](http://paleocave.sciencesortof.com/2013/03/writing-a-for-loop-in-r/)

## Vectorization in R ##

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

### Comparing with loops ###
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

## Data types in R ##
R uses the terms `class` and `type` to refer to very similar concepts, so for the purpose of this tutorial we will use the term "data type" to refer to this idea.  Just know that the output of `typeof(x)` and of `class(x)` may use slightly different terms (an example is shown in the table below). For most things, it is probably the most straightforward to use `class(x)` to determine the data type of an object.  
  
***For advanced users:***  
`class` *refers to the classification of an object used by the programming layer to determine what properties the object has and how functions act on it.*  
`typeof` *gives you the form in which an object is stored in memory.*
  
**Basic data types for individual values:**  

| Used for:     | `class(x)`	| `typeof(x)`     	| other names     | Description     | 
|:-------------|:-------------|:---------------|:-------------|:-------------|
| numbers    | **numeric**    | **double**    | Double  	| numbers, ex: 3.0, 24, -100, 2.4, -87.3 |
| numbers    | **integer**    | **integer**    | int  	| numbers, ex: 3, 24, -100, (no decimals) | 
| asking a yes/no question    | **logical**   	| **logical**   	| boolean | `TRUE` or `FALSE` (also `T` or `F`), but not `true` or `false` |
| words    | **character**   | **character**   | String      	| character strings are any text.  define a character by surrounding it with quotes, ex: `"hello"`.  A number surrounded by quotes will be interpreted as a character string, ex `"3"`.|

**Note:**   
These are the main categories of data types that you need to worry about, but there are a few others.  You generally do not need to specify the types of your variables in R as in some other programming languages.  Under-the-hood, R will make some decisions for you about what type a variable should be.  Numeric values that are whole numbers could be saved as `integers` or as `doubles`, but in reality R will usually save numbers you type as `doubles`.   This takes up more memory than saving as `integers`, but it is also more flexible. 

To force a number to be saved as an `integer`, add "L" after the number like: `x <- 1L`.  So `class(1)` returns "numeric", whereas `class(1L)` returns "integer" in R.  The memory gains from using integers is only really noticable for very large datasets.

**Factors**  
There is one data type that I didn't mention called `factors` which comes up in R sometimes since the default setting in R when importing a data table is to "import strings as factors".  This means that if you have a column in your data frame that can contain one of three values: control, treatment1, or treatment2, R will create a list of these three values `c("control", "treatment1", "treatment2")` and just store the numbers 1, 2, or 3 corresponding to the position in this list.  Factors are a very efficient way to store strings of this sort, since each unique string is stored only once, and the data itself is stored as a vector of integers.  But factors can sometimes cause trouble with data manipulation, so in most cases it is best to import spreadsheet data with the option `importStringsAsFactors = FALSE` to prevent importing as factors, and instead import just as character strings.

Some more useful info on factors here: [http://www.stat.berkeley.edu/~s133/factors.html](http://www.stat.berkeley.edu/~s133/factors.html)

## Data types made up of lists or tables ##

| Data type     	| Code to create this type of object     | Contents     | Dimensions | 
|:-------------|:---------------|:--------------|:-----------|
| vectors       	| `c(item1, item2, item3)` | all same data type | 1 (a list of elements) |
| matrices      	| `mymatrix <- matrix(vector, nrow = r, ncol = c, byrow = FALSE, dimnames = list(char_vector_rownames, char_vector_colnames))` | all same data type | 2 (a table of elements) |
| arrays			| `array(data = vector, dim = length(data), dimnames = list(char_vector_rownames, char_vector_colnames))` |	all same data type | similar to matrices but can have > 2 dimensions |
| data frames   	| `column1 <- c(1,2,3,4)` <br>`column2 <- c("red", "white", "red", NA)` <br>`column3 <- c(TRUE,TRUE,TRUE,FALSE)` <br>`df <- data.frame(column1, column2, column3)` <br>`# set column names` <br> `names(df) <- c("ID","Treatment","Measurement")`  | like an excel sheet, Columns are names and have the same data type within a column, rows can contain different data type and rownames are optional | 2 |
| lists         	| `list(item1, item2, item3)` or <br> `list(name1 = item1, name2 = item2, name3 = item3)` | multiple types ok | 1 |
	
**Checking types:**  
You may remember that you can check the data type of any variable in R by using the `class()` function.  So `class("hello")` would return `"character"` and `class(23)` would return `"numeric"`.  If you call class on a list, it will return `"list"`.  If you call class on a dataFrame it will return `data.frame`.  But if you call class of a vector, it will return the data type of the contents.  So `class(c(1,2,3))` will return `"numeric"`.

**Note on vectors:**   
These are lists of elements that are all of the same data type.  You can get an element from a specific index (for example index 1) in the list with vectorName[1].  Remember that in R counting starts from 1, while in some other programming languages (such as python), counting starts from 0.  So the first element of vector x in R is x[1], but in python would be x[0]

**Note on lists:**  
Lists are very similar to vectors, but some functions require one or the other (create with `list()` or change to not a list with `unlist()` Elements in a list can be associated with names, so you can call an element by its index or it's name. **(*Actually, you can also do this with vectors by setting `names(vector)`, but this is used less frequently than names for list elements.*)**  You can also store multiple elements of different data types within the same list, which is not possible in vectors.

Check out Quick-R for more info on data types in R: [http://statmethods.net/input/datatypes.html] (http://statmethods.net/input/datatypes.html)  

## R functions ##

Functions are a bunch of R code set up in such a way that it can be reused to perform a similar function by simply passing it different input variables.  

Functions usually have an input variable or variables and often return an output, print something to the screen, or display a graphic.  

Many functions are included with R by default, such as the function `mean()`, which gives you the mean of a set of numbers.  When you install and then load a package you get access to many more functions.  For example if I install the **`ggplot2`** package then I can use the `ggplot()`, `qplot()`, etc.  But you can also write your own functions with very little effort.  

Here is the structure of a function that calculates the standard error for a set of numbers:

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
> print(a)
> print(b)
> print(a+b)
``` 

This allows us to easily do complex calculations without writing out all of the code for individual commands.  Above, we set the variables `a` and `b` to contain the standard error for the GA measurements and the standard error for the ABA measurements (just a random example).  We can then perform other actions with `a` and `b`, such as adding them or feeding them to another function.  Nesting these sorts of calls — making function calls on the returned value of other functions — is the basis of all R data analysis.  
  
***The golden rule is to try and type the least amount of code to get the work done.***

