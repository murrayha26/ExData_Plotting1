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

# Adjust date format
full.power.data$Date <- as.Date(full.power.data$Date, format = "%d/%m/%Y")

# Convert time format to POSIXlt
full.power.data$Time <- strptime(paste(full.power.data$Date, full.power.data$Time), "%Y-%m-%d %H:%M:%S")

# Subset to get the dates we are interested in 2007-02-01 and 2007-02-02
feb.power.data <- subset(full.power.data, (full.power.data$Date >= "2007-02-01" & full.power.data$Date <= "2007-02-02"))

# Remove full power data file to free up memory
rm(full.power.data)

# Create histogram and save it in a PNG format with height and width = 480
hist(feb.power.data$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency", col = "Red")

dev.copy(png, filename = "Plot1.png", width = 480, height = 480)
dev.off()


