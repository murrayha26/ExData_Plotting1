# Load required libraries
library(data.table)

# Check if the file exists, if not, download it
if (!file.exists("exdata_data_household_power_consumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                "exdata_data_household_power_consumption.zip", method = "curl")
}

# Unzip the data file
unzip("exdata_data_household_power_consumption.zip")

# Read in the power consumption dataset
full.power.data <- read.csv("household_power_consumption.txt", sep=";", header=TRUE, na.strings = "?")

# Pull the data for the 1/2/2007 and 2/2/2007 dates
sub.power.data <- subset(full.power.data, full.power.data$Date == "1/2/2007" | full.power.data == "2/2/2007")

# Remove full power data file to free up memory
rm(full.power.data)

# Parse Date and Time columns
sub.power.data$Date <- as.Date(sub.power.data$Date, format = "%d/%m/%Y")
sub.power.data$Time <- strptime(sub.power.data$Time, format = "%H:%M:%S")
sub.power.data[1:1440, "Time"] <- format(sub.power.data[1:1440, "Time"], "2007-02-01 %H:%M:%S")
sub.power.data[1441:2880, "Time"] <- format(sub.power.data[1441:2880, "Time"], "2007-02-02 %H:%M:%S")

# Create multiplot
par(mfrow = c(2,2))
with(sub.power.data, {
  plot(sub.power.data$Time, sub.power.data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
  plot(sub.power.data$Time, sub.power.data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
  
  plot(sub.power.data$Time, sub.power.data$Sub_metering_1, xlab = "", ylab = "Energy sub metering", col = "black", type = "l")
  lines(sub.power.data$Time, sub.power.data$Sub_metering_2, col = "red")
  lines(sub.power.data$Time, sub.power.data$Sub_metering_3, col = "blue")
  legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  plot(sub.power.data$Time, sub.power.data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
})

dev.copy(png, filename = "Plot4.png", width = 480, height = 480)
dev.off()

