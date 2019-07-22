setwd("C:/Users/Dell XPS 9575 4K/Google Drive/My/Programming/ExploratoryDataAnalysis/Week1/Project")
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName = "exdata_data_household_power_consumption.zip"

#To create a transferable code that automatically download the file in any workstation
if(!file.exists(fileName)){
    download.file(fileURL, destfile = fileName, method = "curl")
}
if(!file.exists("household_power_consumption.txt")){
    unzip(fileName)
}

#import the data
data <- read.table(file = "household_power_consumption.txt", header = TRUE, sep = ";", 
                   na.strings = "?", colClasses = c("character", "character", "numeric",
                                                    "numeric", "numeric", "numeric",  "numeric", "numeric", "numeric"))
data$Date <- as.Date(data$Date, "%d/%m/%Y")

#select out data points from between 2007-02-01 to 2007-02-02
if(!require("dplyr")){
    install.packages("dplyr")
}
library(dplyr)
data <- filter(data, Date >= "2007-2-1" & Date <= "2007-2-2")

#Removing missing data
data <- data[complete.cases(data),]

#combing date and time and convert format into POSIXct
data <- mutate(data, datetime = paste(data$Date, data$Time))
data$datetime <- strptime(data$datetime, format = "%Y-%m-%d %H:%M:%S")
data$datetime <- as.POSIXct(data$datetime)

#making plot 3
plot(data$Sub_metering_1~data$datetime, type = "l", xlab = NA, ylab = "Energy sub metering")
lines(data$Sub_metering_2~data$datetime, col = "red")
lines(data$Sub_metering_3~data$datetime, col = "blue")
legend("topright", legend = colnames(data)[7:9], lty = 1, lwd = 1.5, col = c("black", "red", "blue"))

#saving plot into a png file
dev.copy(png, "plot3.png", width = 480, height = 480)
dev.off()

