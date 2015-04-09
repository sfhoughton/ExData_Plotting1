##  plot4.R script to download Electric consumption data and create 4-panel plot
##  Creates file plot4.png containing the line plot

##  Setup url to get data from UC Irvine Machine Learning Repo

fileurl <-  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
## Change https to http for download on Windows
fileurl <-  "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "household_power_consumption.txt"
##  Download Electric power consumption data into data table "elecDT"
##  Data is in a zip file so need to extract; unzip to tempfile "temp" then read.table to "elecDT".
##  Then time stamp download file and delete "temp".

temp <- tempfile()
download.file(fileurl,temp)
elecDT <- read.table(unz(temp, filename), header=TRUE, sep=";", stringsAsFactors=FALSE)
dateDownloaded <- date()
unlink(temp)

##  Create "plotdata" with subset of readings for mm/dd/yyyy = 02/01/2007 - 02/02/2007
##  elecDT$Date is formatted as chr dd/mm/yyyy, so need to reformat to date class variable
##  choose where elecDT$Date == "01/02/2007" OR "02/02/2007"

plotdata <- elecDT[which(elecDT$Date=="1/2/2007" | elecDT$Date=="2/2/2007"), ]

##  Convert Date to date format and Time to time format for running line charts to be in order

plotdata$Date <- as.Date(plotdata$Date, format = "%d/%m/%Y")

##  Create timestamp from date and time, make it a date/time field and add as new column to plotdata
timestamp = paste(plotdata$Date,plotdata$Time)
timestamp <- strptime(timestamp, format = "%Y-%m-%d %H:%M:%S")
plotdata$datetime<- timestamp

##  Global_active_power, Global_reactive_power, Sub_metering_1, Sub_metering_2, Sub_metering_3, and Voltage
##  must be numeric for plotting so transform them

plotdata$Global_active_power <- as.numeric(plotdata$Global_active_power)
plotdata$Global_reactive_power <- as.numeric(plotdata$Global_reactive_power)
plotdata$Sub_metering_1 <- as.numeric(plotdata$Sub_metering_1)
plotdata$Sub_metering_2 <- as.numeric(plotdata$Sub_metering_2)
plotdata$Sub_metering_3 <- as.numeric(plotdata$Sub_metering_3)
plotdata$Voltage <- as.numeric(plotdata$Voltage)

##  Create multiple base plots using par, filled by rows, may need to set margins here also
par(mfrow=c(2,2), mar=c(4,4,.5,2))
with(plotdata, {
##  Plot 1 Upper Left - this is the same as created by plot2.R
plot(datetime,Global_active_power,type="l", ylab="Global Active Power", xlab=" ")

##  Plot 2 Upper Right - Voltage by datetime
plot(datetime, Voltage, type="l")

##  Plot 3 Lower Left - this is the same as created by plot3.R
plot(plotdata$datetime,plotdata$Sub_metering_1,type="l", ylim=c(0,40), ylab="Energy sub metering", xlab=" ", yaxp=c(0,30,3))
##  Make second plot without clearing the first, and don't draw axes on subsequent plots
par(new=T)
plot(plotdata$datetime,plotdata$Sub_metering_2,type="l", axes=FALSE, ylim=c(0,40), yaxp=c(0,30,3), xlab=" ", ylab=" ",  col="red")
par(new=T)
plot(plotdata$datetime,plotdata$Sub_metering_3,type="l", axes=FALSE, ylim=c(0,40), yaxp=c(0,30,3), xlab=" ", ylab=" ",  col="blue")
##  Add the legend
legend("topright", lty=c(1), col=c("black", "red", "blue"), cex=.7, bty="n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

##  Plot 4 Lower Right -

plot(datetime, Global_reactive_power, type="l")

})

## Create a .png file of the graphic

dev.copy(png, file="plot4.png")
##  Close the graphics device
dev.off()
