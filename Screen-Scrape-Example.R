# Simple screen scraping example of page
# http://www.kssos.org/ent/shawnee.html

# Earl F. Glynn, 16 Feb. 2011
# Franklin Center for Government and Public Integrity

# R packages needed below
library(gdata)   # trim
library(XML)     # htmlTreeParse

# Read web page into object "doc"
county <- "Shawnee"
url <- paste("http://www.kssos.org/ent/", county, ".html", sep="")
doc <- htmlTreeParse(url, useInternalNodes=TRUE)

# Extract lines using xpathApply
# http://www.omegahat.org/RSXML/shortIntro.html
# A Short Introduction to the XML package for R
x <- unlist(xpathApply(doc, "//table[@width='500']/tr/td/table", xmlValue))

# Cleanup problems in data
x <- gsub("\r\n", "|", x)
x <- gsub("\\|\\|View Map", "", x)
x <- gsub("\\| \\|", "", x)
x <- gsub("\\|\\| ", "", x)
x <- gsub("\\&nbsp\\&nbsp", "", x)
x <- gsub("\\\"", "", x)

# Loop through data extracting candidate, and reformatting output
contest <- ""
for (i in 1:length(x))
{
  if (length(grep("County Precincts Reporting:", x[i])) > 0)
  {
    candidate <-  unlist(strsplit(x[i], "County Precincts Reporting:"))[1]
  } else {
      raw <- trim(unlist(strsplit(x[i], "\\|")))
      raw <- gsub(",", "", raw)  # remove commas from numbers
      raw <- gsub("%", "", raw)  # remove percent sign
      line <- c(county, candidate, raw)
      cat( paste(line, collapse="|"), "\n")
  }
}
