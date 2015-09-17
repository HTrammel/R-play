# play with random number generation
#

# set up random data
#
set.seed(10)
df <- data.frame(foo = rnorm(10), bar = rnorm(5), yr = c(2015, 2014, 2015, 2013, 2013) )
