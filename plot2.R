library(lubridate)
library(dplyr)

# Load remote dataase
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
origDs <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";", stringsAsFactors=FALSE)
unlink(temp)

# Convert data to numeric
origDs$Global_active_power <- as.numeric(origDs$Global_active_power)
origDs[,"dateval"] <- as.Date(origDs$Date,'%d/%m/%Y')
origDs[,"hour"] <- hour(hms(origDs$Time))
origDs[,"weekday"] <- substr(weekdays(origDs$dateval), 1, 3)
origDs[,"datetime"] <- dmy_hms(paste(origDs$Date,origDs$Time))
t1 <- tbl_df(origDs)
t2 <- filter(t1, dateval >= as.Date("2007-02-01") & dateval <= as.Date("2007-02-02"))
t2 <- filter(t2, weekday == "Thu" || weekday == "Fri" || weekday == "Sat")

# generate plot
plot(t2$Global_active_power ~ t2$datetime, type="l", ylab = "Global Active Power (kilowatts)", xlab ="")

dev.copy(png, 'plot2.png', width=480, height=480)
dev.off()
