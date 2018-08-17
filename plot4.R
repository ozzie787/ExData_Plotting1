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
### Convert $Global_reactive_power to numeric object
data_range <- mutate(data_range, Global_reactive_power = as.numeric(Global_reactive_power))
### Convert $Voltage to numeric object
data_range <- mutate(data_range, Voltage = as.numeric(Voltage))
### Convert $Sub_metering_{1,2,3} to numeric objects
data_range <- mutate(data_range,
                     Sub_metering_1 = as.numeric(Sub_metering_1),
                     Sub_metering_2 = as.numeric(Sub_metering_2),
                     Sub_metering_3 = as.numeric(Sub_metering_3)
)

### Set plotting output to PNG file
png(filename = "plot4.png",
    width = 480,
    height = 480
    )

###Plot 4
par(mfrow=c(2,2))

plot(data_range$datetime, data_range$Global_active_power,
     xlab = "",
     ylab = "Global Active Power",
     type = "l"
     )

plot(data_range$datetime, data_range$Voltage,
     col = "black",
     xlab = "datetime",
     ylab = "Voltage",
     type = "l"
     )

plot(data_range$datetime, data_range$Sub_metering_1,
     col = "black",
     xlab = "",
     ylab = "Energy sub metering",
     type = "l"
)
lines(data_range$datetime, data_range$Sub_metering_2,
     col="red"
)
lines(data_range$datetime, data_range$Sub_metering_3,
     col="blue"
)
legend("topright",
     legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
     col = c("black","red","blue"),
     lty = 1,
     bty = "n"
)

plot(data_range$datetime, data_range$Global_reactive_power,
     col = "black",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     type = "l"
     )

### Close PNG
dev.off()