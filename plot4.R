plot4 <- function () {
    datafile <- 'household_power_consumption.txt'
    
    ## Checks if the data file exists in the current directory and downloads it
    ## if it does not.
    if (!file.exists(datafile)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "assignment1.zip", method = "curl")
        unzip('./assignment1.zip')        
    }
    
    ## Checks if the package data.table is loaded and installs and loads it
    ## if it is not.
    if (!require(data.table)) {
        install.packages("data.table")
    }
    library(data.table)
    
    ## Reads data for 1/2/2007 and 2/2/2007 into data table with original
    ## column names
    x <- fread('./household_power_consumption.txt', skip = '1/2/2007', nrows=2880, na.strings = '?', colClasses = c(rep('character', 9)))
    y <- colnames(fread('household_power_consumption.txt', nrows=0))
    setnames(x,y)
    
    ## Combines 'Date' and 'Time' values into one column and type casts these
    ## to POSIXct values. Also converts Sub_metering_ columns, Global_active_power,
    ## Voltage, Global_reactive_power values to numeric
    x[,Date := as.POSIXct(strptime(paste(x$Date, x$Time), "%d/%m/%Y %H:%M:%S", tz="America/Los_Angeles"))]
    x[,Time := NULL]
    x$Global_active_power <- as.numeric(x$Global_active_power)
    x$Voltage <- as.numeric(x$Voltage)
    x$Sub_metering_1 <- as.numeric(x$Sub_metering_1)
    x$Sub_metering_2 <- as.numeric(x$Sub_metering_2)
    x$Sub_metering_3 <- as.numeric(x$Sub_metering_3)
    x$Global_reactive_power <- as.numeric(x$Global_reactive_power)
    
    ## Plots Global_active_power, Voltage, Energy sub metering,  
    ## Global_reactive_power as time series line graphs in 'plot4.png'
    png(filename = 'plot4.png')
    par(mfcol = c(2,2))
    
    plot(x$Date, x$Global_active_power, main = '', xlab='', ylab = 'Global Active Power', type = 'l')
    
    plot(x$Date, x$Sub_metering_1, type='l', main = '', xlab='', ylab = 'Energy sub metering', col = 'black')
    lines(x$Date, x$Sub_metering_2, col = 'red')
    lines(x$Date, x$Sub_metering_3, col = 'blue')
    legend('topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lwd=1, bty='n')
    
    plot(x$Date, x$Voltage, main = '', xlab='datetime', ylab = 'Voltage', type = 'l')
    
    plot(x$Date, x$Global_reactive_power, main = '', xlab='datetime', ylab = 'Global_reactive_power', type = 'l')
    
    dev.off()
}