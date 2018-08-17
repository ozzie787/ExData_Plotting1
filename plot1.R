archive = "exdata%2Fdata%2Fhousehold_power_consumption.zip" # Filename of ZIP Archive
file    = "household_power_consumption.txt"                 # Filename of data file

### Libraries
library(data.table)
library(dplyr)

### Unzip archive
unzip(archive)

### Read data
data <- fread(file)

### Convert dates to datetime object
data <- mutate(data, Date = as.Date(Date, format = "%d/%m/%Y"))

### Create subset of data within date range 2007-02-01 and 2007-02-02 and store in data_range
data_range <- subset(data, (Date>=as.Date("2007-02-01)") & Date<=as.Date("2007-02-02")))

### Form datetime object of date and time by pasting $DATE and $TIME then using strptime()
data_range <- mutate(data_range,
          datetime = as.POSIXct(
               strptime(
                    paste(Date,Time,sep = " "),
                    format = "%Y-%m-%d %H:%M:%S"
                    )
               )
          )

### Convert $Global_active_power to numeric object
data_range <- mutate(data_range, Global_active_power = as.numeric(Global_active_power))

### Set plotting output to PNG file
png(filename = "plot1.png",
    width = 480,
    height = 480
    )

### Plot 1
hist(data_range$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     col = "red"
     )

### Close PNG
dev.off()
