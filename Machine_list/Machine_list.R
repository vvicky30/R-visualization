getwd()
setwd("C:\\Users\\hp\\Desktop\\R-files\\R_advanced")
getwd()
#importing dataset
util<-read.csv("P3-Machine-Utilization.csv")

#structure
str(util)
  ##as there are 720 records for each machines i.e.  RL1, RL2, SR1..
head(util,12)


#now we deriving utilisation coulumn from Percent.Idle
util$Utilisation <- 1-util$Percent.Idle
head(util,12)##check

#handling Date & time in R:---
##as here we don't know in the dataset wether it's european-format or american-format of Date & time
##here we used POSIX i.e POSIXct(for calender time) , POSIXlt(for local time)
?POSIXct

util$Posixtime<-as.POSIXct(util$Timestamp,format="%d/%m/%Y %H:%M")
util$Timestamp<-NULL#doesn't need this coulumn anymore
head(util,12)#check
#rearrange the coulumns
util<-util[,c(4,1,2,3)]  #here 4th coulumn appears first
head(util,12)


##---what is LIST in R---##
#firstly subsetting dataset on behalf of the RL1 machines
rl1<-util[util$Machine=="RL1",]
rl1$Machine<-factor(rl1$Machine)
summary(rl1)#check

#for constructing vector with minimum and mean,maximum utilisation of machines
util_stats_rl1<-c(min(rl1$Utilisation,na.rm=T),mean(rl1$Utilisation,na.rm = T),max(rl1$Utilisation,na.rm = T))
util_stats_rl1
    ##i.e  0.8492262 0.9516976 0.9950000
#for constructing logicals forutilisation fallen below 90% or not
##as we can directly find out by analysing the minimum value of utilisation for RL1
## YES, its fallen below 90 or 0.90  as its 0.84
##but we identify this by programatically:--
length(which(rl1$Utilisation<0.90))  #27
util_under_90<-length(which(rl1$Utilisation<0.90))>0
util_under_90  ##as here atleast 1 times utilisation should fall under 0.90 of RL1 machines
               ##which is actualy 27 times
               ##by using which -function we also able to ignore some NA automatically

#list
list_rl1<- list ("RL1",util_stats_rl1,util_under_90)
list_rl1
##naming the components of list 
names(list_rl1)<-c("Machine","Stats","LowThreshold")
list_rl1
##another way of naming;-during creating the list:----
# list_rl1<- list (Machine="RL1",Stats=util_stats_rl1,LowThreshold=util_under_90)

#extracting components of list
#three ways
#1.by "[]" always returns the list 
#2.by"[[]]" always returns the actual object
#3.by"$" same as the [[]] but very easy to use
##ex:- for accessing second one on the list
list_rl1[2]
   #if
   typeof(list_rl1[2])
list_rl1[[2]]  
   # but if
   typeof(list_rl1[[2]] )
list_rl1$Stats   
   # but if
   typeof(list_rl1$Stats)
#for acessing maximum utilisation on the list
list_rl1[[2]][3]
list_rl1$Stats[3]

#adding and Deleting list components 
list_rl1[4]<-"NEWLY ADDED one"
list_rl1#check

#Another way
#as here we going to add unkown utilisations hours
rl1[is.na(rl1$Utilisation),"Posixtime"]
#add the above one to list 
list_rl1$unkown_util_hour<-rl1[is.na(rl1$Utilisation),"Posixtime"]
#removing components
list_rl1[4]<-NULL
list_rl1
##NOTE:- in list numerisation has adjusted accordingly ..unlikely to datasets
##   here in unkown_util_hour which was at no 5 now after removal of "NEWLY ADDED one" its shifted to no4
##as we can see
list_rl1[4]


#now adding dataset rl1 in to list
list_rl1$Data<-rl1
list_rl1

#subsetting list :---
list_rl1[1:3]
list_rl1[c(1,3)]
sub_list<-list_rl1[c("Stats","LowThreshold")]
sub_list

#for acessing mean 
sub_list[[1]][2]
#or
sub_list$Stats[2]

#double square brackets can't be used for the subsetting
##as  list_rl1[[1:3]]   returns ERROR:-Recursive Indexing

list_rl1

#building Time sries plot
library(ggplot2)
p<-ggplot(data=util)
#time-plot-1
p+geom_line(aes(x=Posixtime,y=Utilisation,colour=Machine))

#better approach using facets
#time-plot-2
myplot<-p+geom_line(aes(x=Posixtime,y=Utilisation,colour=Machine),size=1.2)+
facet_grid(Machine~.)+
geom_hline(yintercept = 0.90,colour="gray",size=1.2,linetype=3)
#linetype=3 stands for dotted line used for indicating LowTheshold
myplot

#now adding "myplot" to the list
list_rl1$plot<-myplot
list_rl1#check

                  ##---The End---##