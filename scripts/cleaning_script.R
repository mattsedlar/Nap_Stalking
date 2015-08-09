source("scrape.R")

library(tidyr)

df <- read.csv("./data/naps.csv", stringsAsFactors = FALSE, na.strings="")

## finding the unique character lengths for each record in the Sleep variable
lengths <- c(19,40,61)

## looping through the column to add NAs so we can split into multiple columns
x <- 1

while (x <= length(df$sleeps) ) {
  
  temp_var <- extract_numeric(substr(df$sleeps[x],1,2))
  
  if (nchar(df$sleeps[x]) == lengths[2]) { 
    
    ## fix early naps, naps that sneak into morning column
    if (temp_var == 8){
      df$sleeps[x] <- paste(df$sleeps[x],"; NA - NA")
    }

    else {
      df$sleeps[x] <- paste("NA - NA;",df$sleeps[x])
    }
  }
  
  else if (nchar(df$sleeps[x]) == lengths[1]) { 
    # fix afternoon naps that sneak into the morning column
    if (temp_var < 5) {
      df$sleeps[x] <- paste("NA - NA; NA - NA;", df$sleeps[x])
    }
    
    else {
      df$sleeps[x] <- paste("NA - NA;",df$sleeps[x],"; NA - NA")
    }
  }
  
  x <- x + 1
}

## First round of splitting into three columns, representing early naps,
## morning naps, and afternoon naps
splitDF <- df %>% separate(sleeps,c("morning","midday","afternoon"), sep=";")

## Second round of splitting into start and end times
splitDF <- splitDF %>% separate(morning,c("morningstart","morningend"), sep="-", drop=TRUE)
splitDF <- splitDF %>% separate(midday,c("middaystart","middayend"), sep="-", drop=TRUE)
splitDF <- splitDF %>% separate(afternoon,c("afternoonstart","afternoonend"), sep="-", drop=TRUE)

## convert column to Date class
splitDF$dates <- as.Date(splitDF$dates, format="%Y-%m-%d")

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

splitDF$`middayend` <- bad_variables(splitDF$`middayend`)

# This sets up the dates for POSIX conversion 

pconversion <- function (df,column) {
  column <- substr(strptime(column, "%I:%M %p"), 11, 19)
  z <- 1
  while (z <= length(column)) {
    if (!is.na(column[z])){
      column[z] <- format(paste(df$dates[z], column[z], sep=''))
    }
    else { column[z] = format(paste(df$dates[z], "00:00:00", sep=' ')) }
    z <- z + 1
  }
  column
}

splitDF$`morningstart` <- pconversion(splitDF,splitDF$`morningstart`)
splitDF$`morningend` <- pconversion(splitDF,splitDF$`morningend`)
splitDF$`middaystart` <- pconversion(splitDF,splitDF$`middaystart`)
splitDF$`middayend` <- pconversion(splitDF,splitDF$`middayend`)
splitDF$`afternoonstart` <- pconversion(splitDF,splitDF$`afternoonstart`)
splitDF$`afternoonend` <- pconversion(splitDF,splitDF$`afternoonend`)

## convert to POSIX

## AM
splitDF <- splitDF %>% mutate(`middaystart` = as.POSIXct(`middaystart`)) %>% 
                       mutate(`middayend` = as.POSIXct(`middayend`))

## PM
splitDF <- splitDF %>% mutate(`afternoonstart` = as.POSIXct(`afternoonstart`)) %>% 
                       mutate(`afternoonend` = as.POSIXct(`afternoonend`))

splitDF <- splitDF %>% mutate(location = "daycare")

# tidydata

tidydf <- splitDF