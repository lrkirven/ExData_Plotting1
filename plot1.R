
# Load remote dataase
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
origDs <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";", stringsAsFactors=FALSE)
unlink(temp)

# Convert data to numeric
origDs$Global_active_power <- as.numeric(origDs$Global_active_power)
gap <- origDs$Global_active_power
gap <- gap[!is.na(gap)]

#opar <- options(scipen=1000)
#options("scipen"=100, "digits"=4)
options(scipen = 999)

hist(gap, col = "red", 
     main = "Global Active Power", 
     plot = TRUE, 
     ylim=range(0:1200000),
     xlim=range(0:6),
     xlab = "Global Active Power (kilowatts)")

dev.copy(png,'plot1.png')
dev.off()

