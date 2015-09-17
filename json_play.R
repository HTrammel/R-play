# JSON PLAY
#

library(gdata)
library(XML)

fileURL <- "http://www.census.gov/geo/reference/state-area.html"

html_page <- GET(fileURL)
doc <- htmlTreeParse(fileURL, useInternalNodes = TRUE)

x <-  unlist(xpathApply(doc, "//table/tr/th", xmlValue))

# Cleanup problems in data
x <- gsub("\r\n", "|", x)
x <- gsub("\\|\\|View Map", "", x)
x <- gsub("\\| \\|", "", x)
x <- gsub("\\|\\| ", "", x)
x <- gsub("\\&nbsp", "", x)
x <- gsub("\\\"", "", x)
