# ggplot playground

library(ggplot2)
library(dplyr)
data("midwest")


pl <- ggplot(midwest, aes(factor(state))) +
    geom_bar(width=0.5)

#print (pl)

pl2 <- ggplot(midwest, aes(county, poptotal, fill=state)) +
    geom_bar(stat="identity") +
    coord_flip()

print(pl2)
