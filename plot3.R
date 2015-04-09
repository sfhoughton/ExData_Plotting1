##  plot3.R script to download Electric consumption data and create Energy sub metering by day/time line plot
##  Creates file plot3.png containing the line plot

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

##  Create the graphic with three plots on one frame
##  Set up axes ranges equally in all plot commands (xlim, and ylim)

plot(plotdata$datetime,plotdata$Sub_metering_1,type="l", ylim=c(0,40), ylab="Energy sub metering", xlab=" ", yaxp=c(0,30,3))
##  Make second plot without clearing the first, and don't draw axes on subsequent plots
par(new=T)
plot(plotdata$datetime,plotdata$Sub_metering_2,type="l", axes=FALSE, ylim=c(0,40), yaxp=c(0,30,3), xlab=" ", ylab=" ",  col="red")
par(new=T)
plot(plotdata$datetime,plotdata$Sub_metering_3,type="l", axes=FALSE, ylim=c(0,40), yaxp=c(0,30,3), xlab=" ", ylab=" ",  col="blue")
##  Add the legend
legend("topright", lty=c(1), col=c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Note:  xaxp  = c(x1, x2, n)) to define the position (x1 & x2) of the extreme tick marks and
## the number of intervals between the tick marks (n). Accordingly, n+1 is the number of tick marks drawn. 

## Create a .png file of the graphic

dev.copy(png, file="plot3.png")
##  Close the graphics device
dev.off()
