###########################
### RepData_PeerAssessment1
### author: kjl
###########################

######################################
### Loading and preprocessing the data
######################################

### Load the data
fileUrl<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
temp <- tempfile("repdata-data-activity", fileext=c("zip"))
download.file(fileUrl,temp,mode="wb")
raw<-unzip(temp,"activity.csv")

### Process the data to a data.frame
pamd <- read.csv(raw,header=TRUE,nrows = 17568,stringsAsFactors=FALSE)

unlink(temp)

### Transform the data
pamd$date<-as.Date(pamd$date,format="%Y-%m-%d")

#####################################################
### What is mean total number of steps taken per day?
#####################################################

### Create histogram
hist(pamd$steps,breaks=100)

### Average steps taken per day
meandsteps<-sum(pamd$steps,na.rm=TRUE)/61

### Median steps taken per day
mediandsteps<-median(pamd$steps,na.rm=TRUE)/61

################################################
### What is the average daily activity pattern?
################################################

### Average daily activity pattern
install.packages("plyr", repos="http://cran.rstudio.com/")
library(plyr)
avgdactp<-ddply(pamd,~interval,summarise,mean=mean(steps,na.rm=TRUE))
plot(x=avgdactp$interval,y=avgdactp$mean,type="l")

###########################
### Imputing missing values
###########################

### Calc the number of NAs
summary(pamd)

### Fill NAs
install.packages("zoo", repos="http://cran.rstudio.com/")
library(zoo,quietly = TRUE)
clpamd<-pamd
clpamd$steps<-na.locf(clpamd$steps,fromLast = TRUE)
clpamd$steps<-na.fill(clpamd$steps,fill = 0)

### histogram with cleaned data
hist(clpamd$steps,breaks=100, col="green")

################
### findings replacing the 288 with na.locf {zoo} na.rm=TRUE,fromLast = TRUE lowers the mean steps from 37.38 to 32.48.  Median is still obviously zero
################

#############################################################################
### Are there differences in activity patterns between weekdays and weekends?
#############################################################################

### Determine if a day is a weekday or weekend
install.packages("timeDate", repos="http://cran.rstudio.com/")
library(timeDate,quietly = TRUE)
clpamd$wdwe<-ifelse(isWeekday(clpamd$date),"weekday","weekend")

### Make a panel plot 
library(lattice,quietly = TRUE)
avgdactpcl<-ddply(clpamd,.(interval,wdwe),summarise,mean=mean(steps,na.rm=TRUE))
xyplot(x=mean~interval|wdwe,data=avgdactpcl,type="l",layout=c(1,2),ylab="Number of steps")
