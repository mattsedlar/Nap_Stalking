source("access.R")

library(dplyr)

pull_report <- function(num) {

  content <- content(num,as="text")
  parsedHTML <- htmlParse(content,asText=TRUE)
  
  scrape <- xpathSApply(parsedHTML,"//table[@class='report_view']",xmlValue)
  
  dates <- c()
  sleeps <- c()
  
  i <- 1
  
  while (i <= length(scrape)) {
    # pulling dates
    date <- substr(scrape[i],1,10)
    dates <- c(dates,date)
    # pulling naps
    sleep <- sub(".*Sleeps\n        \n          ", "", scrape[i])
    sleep <- sub("(\\n +)D.+", "", sleep)
    sleep <- gsub("\\n",";", sleep)
    sleeps <- c(sleeps, sleep)
    i <- i + 1
  }
  
  df <- data.frame(dates,sleeps)
  df
}

# parse all the individual reports
report1 <- pull_report(reports1)
report2 <- pull_report(reports2)
report3 <- pull_report(reports3)
report4 <- pull_report(reports4)

# bind them all together in one data frame
reports <- rbind(report1,report2,report3,report4)

# let's clean up the environment
rm(report1,report2,report3,report4)

# filter out the dates with no reports and order by date
reports <- reports %>% 
            filter(!grepl("2015", sleeps)) %>%
            mutate(sleeps = trimws(as.character(sleeps))) %>%
            mutate(sleeps = sub(";$","",sleeps)) %>%
            mutate(sleeps = gsub("\\s+"," ", sleeps)) %>%
            arrange(dates)

if(!file.exists("./data")) { dir.create("./data") }

write.csv(reports,"./data/naps.csv", row.names = FALSE)
