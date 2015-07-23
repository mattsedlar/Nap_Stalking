library(dplyr)
library(tidyr)

data <- read.csv("OutWit scraped export.csv", stringsAsFactors = FALSE, na.strings="")
## getting rid of the dates with no values
df <- data[complete.cases(data),]

## finding the unique character lengths for each record in the Sleep variable
lengths <- c(19,39,59)

## looping through the column to add NAs so we can split into multiple columns
x <- 1

while (x <= length(df$Sleep) ) {
  
  temp_var <- extract_numeric(substr(df$Sleep[x],1,2))
  
  if (nchar(df$Sleep[x]) == lengths[2]) { 
    
    ## fix early naps, naps that sneak into morning column
    if (temp_var == 8){
      df$Sleep[x] <- paste(df$Sleep[x],"; NA - NA")
    }

    else {
      df$Sleep[x] <- paste("NA - NA;",df$Sleep[x])
    }
  }
  
  else if (nchar(df$Sleep[x]) == lengths[1]) { 
    # fix afternoon naps that sneak into the morning column
    if (temp_var < 5) {
      df$Sleep[x] <- paste("NA - NA; NA - NA;", df$Sleep[x])
    }
    
    else {
      df$Sleep[x] <- paste("NA - NA;",df$Sleep[x],"; NA - NA")
    }
  }
  
  x <- x + 1
}

## First round of splitting into three columns, representing early naps,
## morning naps, and afternoon naps
splitDF <- df %>% separate(Sleep,c("early","morning","afternoon"), sep=";")

## Second round of splitting into start and end times
splitDF <- splitDF %>% separate(early,c("early start","early end"), sep="-", drop=TRUE)
splitDF <- splitDF %>% separate(morning,c("morning start","morning end"), sep="-", drop=TRUE)
splitDF <- splitDF %>% separate(afternoon,c("afternoon start","afternoon end"), sep="-", drop=TRUE)

## fix the whitespace in the Date column
splitDF$Date <- gsub(" ","", splitDF$Date, fixed=TRUE)
## convert column to Date class
splitDF$Date <- as.Date(splitDF$Date, format="%Y-%m-%d")

dfnames <- names(splitDF)
dfnames <- dfnames[-1]

for (y in dfnames) {
  splitDF[[y]] <- gsub(" $","",splitDF[[y]])
  splitDF[[y]] <- gsub("^ ","",splitDF[[y]])
}

## there are some bad times in the 'morning end' data (ex. nap ends at 12:00 a.m.)
## this function fixes those
bad_variables <- function(column) {
  x <- 1
  while (x <= length(column)) {
    if (substring(column[[x]],1,2) == "12") {
      column[[x]] <- paste(substring(column[[x]],1,5), "PM", sep=" ")
    }
    x <- x + 1
  }
  column
}

splitDF$`morning end` <- bad_variables(splitDF$`morning end`)

# This sets up the dates for POSIX conversion 

pconversion <- function (df,column) {
  column <- substr(strptime(column, "%I:%M %p"), 11, 19)
  z <- 1
  while (z <= length(column)) {
    if (!is.na(column[z])){
      column[z] <- format(paste(df$Date[z], column[z], sep=''))
    }
    else { column[z] = format(paste(df$Date[z], "00:00:00", sep=' ')) }
    z <- z + 1
  }
  column
}

splitDF$`early start` <- pconversion(splitDF,splitDF$`early start`)
splitDF$`early end` <- pconversion(splitDF,splitDF$`early end`)
splitDF$`morning start` <- pconversion(splitDF,splitDF$`morning start`)
splitDF$`morning end` <- pconversion(splitDF,splitDF$`morning end`)
splitDF$`afternoon start` <- pconversion(splitDF,splitDF$`afternoon start`)
splitDF$`afternoon end` <- pconversion(splitDF,splitDF$`afternoon end`)

## convert to POSIX

## AM
splitDF <- splitDF %>% mutate(`morning start` = as.POSIXct(`morning start`)) %>% 
                       mutate(`morning end` = as.POSIXct(`morning end`))

## PM
splitDF <- splitDF %>% mutate(`afternoon start` = as.POSIXct(`afternoon start`)) %>% 
                       mutate(`afternoon end` = as.POSIXct(`afternoon end`))