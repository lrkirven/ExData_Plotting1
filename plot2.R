library(lubridate)
library(dplyr)

# Load remote dataase
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
origDs <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";", stringsAsFactors=FALSE)
unlink(temp)
start <- as.Date("2007-02-01")
finish <- as.Date("2007-02-02")

# Convert data to numeric
origDs$Global_active_power <- as.numeric(origDs$Global_active_power)
origDs[,"weekday"] <- weekdays(as.Date(origDs$Date,'%d/%m/%Y'))
origDs[,"dateval"] <- as.Date(origDs$Date,'%d/%m/%Y')
t1 <- tbl_df(origDs)


ds1 <- subset(origDs, weekday == "Thursday" | weekday == "Friday" | weekday == "Saturday")
ds1_t <- tbl_df(ds1)
ds1_t <- select(ds1_t, Global_active_power, hour, weekday)
by_hourweekday_t <- ds1_t %>% na.omit() %>% group_by(hour, weekday)
sum1_t <- summarize(by_hourweekday_t, gap = mean(Global_active_power))

with(sum1_t, plot(sum1_t$hour, sum1_t$gap, type = "l", col="black", 
               xaxt="n",
               ylab = "Global Active Power (kilowatts)",
               xlab = "",
               axes = TRUE))
dev.copy(png,'plot2.png')
dev.off()
