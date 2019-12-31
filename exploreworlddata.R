# method 1. select file manually
stats<-read.csv(file.choose())#--------after naviate the file open it manually

#method 2. select file by using working-directory(WD)&read dataset
getwd()# for geting adress of WD
setwd("c:\\users\\acer\\desktop\\vedant")
getwd()
stats<-read.csv("DemographicData.csv")
stats

#exploring data set
nrow(stats)#no. of rows
ncol(stats)#no. of coulmn
head(stats)#showing top 6 rows of dataset
tail(stats)#showing bottom 6 rows of data set
   #with more fexibility
   head(stats,n=9)#showing top 9
   tail(stats,n=10)#showing bottom 10
  
#for  deep brief knowledge about dataset
   str(stats)#structure fn for quick brief knowledge
   summary(stats)#summary fn for summarize brief knowledge

   