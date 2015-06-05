plot2 <- function () {
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
    ## to POSIXct values. Also converts Global_active_power column values to numeric
    x[,Date := as.POSIXct(strptime(paste(x$Date, x$Time), "%d/%m/%Y %H:%M:%S", tz="America/Los_Angeles"))]
    x[,Time := NULL]
    x$Global_active_power <- as.numeric(x$Global_active_power)
    
    ## Plots Global_active_power over time as a line graph in a PNG file 
    ## 'plot2.png'
    png(filename = 'plot2.png', bg = 'transparent')
    plot(x$Date, x$Global_active_power, main = '', xlab='', ylab = 'Global Active Power (kilowatts)', type = 'l')
    dev.off()
}