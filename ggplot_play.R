library(ggplot2)
set.seed(10)

df <- data.frame(foo = rnorm(10), bar = rnorm(5))

pl <- qplot(df$foo, df$bar, geom="line", xlab="foo", ylab="bar")00
print (pl)
