#introduction to quickplot
library(ggplot2)
?qplot()
getwd()
setwd("c:\\users\\acer\\desktop\\vedant")
states<-read.csv("DemographicData.csv")
states
head(states)
summary(states)
ncol(states)
nrow(states)
#filtering of dataframe
filter<-states$Internet.users<5
filter
states[filter,]
#optemize method
states[states$Income.Group=="High income",]
states[states$Country.Code=="IND",]
states[states$Birth.rate>45,]
