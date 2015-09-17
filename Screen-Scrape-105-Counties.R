# Screen scrape election results from Kansas Secretary of State's site
# for all 105 counties and write to pipe-delimited file.

# Earl F. Glynn, 9 Nov. 2010
# Franklin Center for Government and Public Integrity

library(gdata)   # trim
library(XML)     # htmlTreeParse

Kansas.Counties <- c(
  "Allen",      "Anderson",     "Atchison",    "Barber",    "Barton",
  "Bourbon",    "Brown",        "Butler",      "Chase",     "Chautauqua",
  "Cherokee",   "Cheyenne",     "Clark",       "Clay",      "Cloud",
  "Coffey",     "Comanche",     "Cowley",      "Crawford",  "Decatur",
  "Dickinson",  "Doniphan",     "Douglas",     "Edwards",   "Elk",
  "Ellis",      "Ellsworth",    "Finney",      "Ford",      "Franklin",
  "Geary",      "Gove",         "Graham",      "Grant",     "Gray",
  "Greeley",    "Greenwood",    "Hamilton",    "Harper",    "Harvey",
  "Haskell",    "Hodgeman",     "Jackson",     "Jefferson", "Jewell",
  "Johnson",    "Kearny",       "Kingman",     "Kiowa",     "Labette",
  "Lane",       "Leavenworth",  "Lincoln",     "Linn",      "Logan",
  "Lyon",       "Marion",       "Marshall",    "McPherson", "Meade",
  "Miami",      "Mitchell",     "Montgomery",  "Morris",    "Morton",
  "Nemaha",     "Neosho",       "Ness",        "Norton",    "Osage",
  "Osborne",    "Ottawa",       "Pawnee",      "Phillips",  "Pottawatomie",
  "Pratt",      "Rawlins",      "Reno",        "Republic",  "Rice",
  "Riley",      "Rooks",        "Rush",        "Russell",   "Saline",
  "Scott",      "Sedgwick",     "Seward",      "Shawnee",   "Sheridan",
  "Sherman",    "Smith",        "Stafford",    "Stanton",   "Stevens",
  "Sumner",     "Thomas",       "Trego",       "Wabaunsee", "Wallace",
  "Washington", "Wichita",      "Wilson",      "Woodson",   "Wyandotte")

scrape.county <- function (county, outfile)
{
  url <- paste("http://www.kssos.org/ent/", county, ".html", sep="")
  doc <- htmlTreeParse(url, useInternalNodes=TRUE)

  # Extract lines using xpathApply
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
        cat( paste(line, collapse="|"), "\n", file=outfile)
    }
  }
}

basedir <- "C:/Users/earl/Desktop/CAR/Screen-Scraping/"    #### set base dir ####
outfile <- file(paste(basedir, "2010-Kansas-General-Election-11-03.txt", sep=""), "w")

for (i in 1:length(Kansas.Counties))
{
  county <- Kansas.Counties[i]
  cat(county, "\n")
  flush.console()
  scrape.county(county, outfile)
}

close(outfile)
