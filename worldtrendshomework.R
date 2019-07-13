#load data
getwd()
data<-read.csv(file.choose())
head(data)
tail(data)
#for observing
str(data)
summary(data)
#insights into nxt section
data$Year
temp<-factor(data$Year)
levels(temp)
#filterinf\g data frame for splitting
data1960<-data[data$Year==1960,]
data2013<-data[data$Year==2013,]

#check row counts
nrow(data1960)
nrow(data2013)
  #equal splitting!

#create additinal dataframe
add1960<-data.frame(code=Country_Code,life.exp=Life_Expectancy_At_Birth_1960)
add2013<-data.frame(code=Country_Code,life.exp=Life_Expectancy_At_Birth_2013)
#check summary
summary(add1960)
summary(add2013)


#merge the pairs of data fame ie data1960 'nd add1960,,,,data2013 'nd add2013
merged1960<-merge(data1960,add1960,by.x = "Country.Code",by.y = "code")
merged2013<-merge(data2013,add2013,by.x = "Country.Code",by.y = "code")

#checkstructures
str(merged1960)
str(merged2013)
#remove region years as the data already splits acording to years
merged1960$Year<-NULL
merged2013$Year<-NULL
  #check
head(merged1960)
head(merged2013)
#visualization time 
library(ggplot2)
#visualize the 1960dataset
qplot(data = merged1960,x=Fertility.Rate,y=life.exp,colour=Region,size=I(4),alpha=I(0.6),main = "life expectancy v/s fertility(1960)")
#visualize the 2013dataset
qplot(data = merged2013,x=Fertility.Rate,y=life.exp,colour=Region,size=I(4),alpha=I(0.6),main = "life expectancy v/s fertility(2013)")
