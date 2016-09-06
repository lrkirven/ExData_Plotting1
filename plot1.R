
# Load remote dataase
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
origDs <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";", stringsAsFactors=FALSE)
unlink(temp)

# Convert data to numeric
origDs$Global_active_power <- as.numeric(origDs$Global_active_power)
origDs[,"dateval"] <- as.Date(origDs$Date,'%d/%m/%Y')
t1 <- tbl_df(origDs)
t2 <- filter(t1, dateval >= as.Date("2007-02-01") & dateval <= as.Date("2007-02-02"))

hist(t2$Global_active_power, col = "red", 
     main = "Global Active Power", 
     plot = TRUE, 
     ylim=range(0:1200),
     xlim=range(0:6),
     xlab = "Global Active Power (kilowatts)")

dev.copy(png,'plot1.png', width=480, height=480)
dev.off()
