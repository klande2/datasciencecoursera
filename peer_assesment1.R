fileUrl<-"https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
temp <- tempfile("household_power_consumption", fileext=c("zip"))
download.file(fileUrl,temp,mode="wb")
raw<-unzip(temp,"household_power_consumption.txt")

dmd <- read.csv(raw,header=TRUE,sep=";",nrows = 2075259,na.strings="?",stringsAsFactors=FALSE)

unlink(temp)

### Add column for DateTime
dmd$DateTime <- as.POSIXct(paste(dmd$Date, dmd$Time), format="%d/%m/%Y %H:%M:%S")

### Get the subset data
subdmd<-subset(dmd,dmd$DateTime>='2007-02-01'&dmd$DateTime<'2007-02-03')

### Reorder the columns and sort by DateTime
subdmd<-subdmd[,c(10,3:9)]
subdmdor<-subdmd[with(subdmd,order(subdmd$DateTime)),]
