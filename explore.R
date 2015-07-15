source("cleaning_script.R")

## Let's look at morning, afternoon nap lengths over time
napsDF <- splitDF

## Toss out the early naps
napsDF <- napsDF %>% select(-(2:3))

## new column for difftime
napsDF <- napsDF %>% mutate(`am nap length` = difftime(`morning end`, `morning start`, units="mins"))
napsDF <- napsDF %>% mutate(`pm nap length` = difftime(`afternoon end`, `afternoon start`, units="mins"))

## AM/PM nap lengths plot
plot(napsDF$`am nap length`~ napsDF$Date, 
     type='l', 
     col="blue",
     ylab="Nap Length (minutes)",
     xlab="Dates",
     main="AM/PM Nap Lengths")
lines(napsDF$`pm nap length` ~ napsDF$Date, col="green")
legend("topright",legend=c("AM nap length", "PM nap length"), col=c("blue","green"), pch="_")