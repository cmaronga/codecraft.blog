# link to material --------------------------------------------------------
browseURL("https://www.dartistics.com/fast-r-code.html#resources")


# Tips for speed ----------------------------------------------------------
## 1. Use Vectorisation ------

# you should always be trying to work with vectors rather than looping around objects if you can

## slower version

v <- c(1,4,5,3,54,6,7,5,3,5,6,4,3,4,5)

## add 42 to every element of the vector
for(i in 1:length(v)){
  v[i] <- v[i] + 42
}

v

# vectorized but faster
v <- c(1,4,5,3,54,6,7,5,3,5,6,4,3,4,5)

## add 42 to every element of the vector
v <- v + 42

v

## Tip: instead of a heavily nested list or data.frame make code that runs on a vector


## 2. Avoid creating objects in a loop ---------

# R isn’t always modifying objects directly, but rather on copies of objects

# a 100 column data.frame
x <- data.frame(matrix(runif(100*1e4), ncol = 100))
dim(x)

# loop 100 times, adding another row to x
system.time(
  for(i in seq_along(1:100)){
    x <- rbind(x, data.frame(matrix(runif(1*1e4), ncol = 100)))
  }
)
dim(x)


# faster code
# a 100 column data.frame
x <- data.frame(matrix(runif(100*1e4), ncol = 100))

## using lapply
system.time(
  lapply(1:100, function(y) rbind(x, data.frame(matrix(runif(1*1e4), ncol = 100))))
  
)


## avoid modifying original data.frame x
x <- data.frame(matrix(runif(100*1e4), ncol = 100))

avoid_copy <- function(z){
  list_of_dfs <- lapply(1:100, function(z) data.frame(matrix(runif(1*1e4), ncol = 100)))
  rows <- Reduce(rbind, list_of_dfs)
  rbind(x, rows)
}

system.time(
  y <- avoid_copy(x)
)


## 3. Get a bigger computer -------


## 5. Find better packages -------
browseURL("https://www.r-bloggers.com/2013/04/faster-higher-stonger-a-guide-to-speeding-up-r-code-for-busy-people/")



## 6. Use parallel processing -------
# R is by nature a single process language, meaning its only using one core


library(future)
plan(multiprocess)

x <- data.frame(matrix(runif(1000*1e4), ncol = 100))

avoid_copy <- function(z){
  list_of_dfs <- lapply(1:100, function(z) data.frame(matrix(runif(1*1e4), ncol = 100)))
  rows <- Reduce(rbind, list_of_dfs)
  rbind(x, rows)
}

## job 1
a %<-% {
  avoid_copy(x[,1:50])
}
## job 2
b %<-% {
  avoid_copy(x[,51:100])
}

## probably not quicker as not a long running enough function
system.time(
  c <- cbind(a, b)
)


# Strategies to Speedup R Code --------------------------------------------

browseURL("https://datascienceplus.com/strategies-to-speedup-r-code/")

## Always initialise your data structures and output variable to 
###required length and data type before taking it to loop for computations.







































