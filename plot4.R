library(lubridate)
library(dplyr)

# Load remote dataase
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
origDs <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";", stringsAsFactors=FALSE)
unlink(temp)

# Convert data to numeric
origDs$Global_active_power <- as.numeric(origDs$Global_active_power)
origDs$Sub_metering_1 <- as.numeric(origDs$Sub_metering_1)
origDs$Sub_metering_2 <- as.numeric(origDs$Sub_metering_2)
origDs$Sub_metering_3 <- as.numeric(origDs$Sub_metering_3)
origDs$Voltage <- as.numeric(origDs$Voltage)
origDs$Global_reactive_power <- as.numeric(origDs$Global_reactive_power)

origDs[,"dateval"] <- as.Date(origDs$Date,'%d/%m/%Y')
origDs[,"hour"] <- hour(hms(origDs$Time))
origDs[,"datetime"] <- dmy_hms(paste(origDs$Date,origDs$Time))

t1 <- tbl_df(origDs)
t2 <- filter(t1, dateval >= as.Date("2007-02-01") & dateval <= as.Date("2007-02-02"))

par(mfrow = c(2,2))

plot(t2$Global_active_power ~ t2$datetime, type="l", ylab = "Global Active Power (kilowatts)", xlab ="")

plot(t2$Voltage ~ t2$datetime, type="l", ylab = "Voltage", xlab ="datetime")

plot(t2$Sub_metering_1 ~ t2$datetime, type="l", xlab="", ylab="Energy sub metering", ylim = range(t2$Sub_metering_1, t2$Sub_metering_2, t2$Sub_metering_3))
lines(t2$Sub_metering_2 ~ t2$datetime, type = "l", col = "red", ylim = range(t2$Sub_metering_1,t2$Sub_metering_2,t2$Sub_metering_3))
lines(t2$Sub_metering_3 ~ t2$datetime, type = "l", col = "blue", ylim = range(t2$Sub_metering_1,t2$Sub_metering_2,t2$Sub_metering_3))
legend("topright", lty=1, legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"))

plot(t2$Global_reactive_power ~ t2$datetime, type="l", ylab = "Global_reactive_power", xlab ="datetime")


dev.copy(png, 'plot4.png', width=480, height=480)
dev.off()