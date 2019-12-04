setwd("C:\\Users\\hp\\Desktop\\R-files\\R_advanced")
getwd()

#importing dataset
# basic import:-
#  fin<-read.csv("P3-Future-500-The-Dataset.csv")
#for avoiding problems in locating mising data with empty places:-
fin<-read.csv("P3-Future-500-The-Dataset.csv",na.strings = c(""))
head(fin)
tail(fin,12)
#structure
str(fin)
 #changing non-factors into factors  
    #for ID:-
  fin$ID<- factor(fin$ID)
    #for Inception
  fin$Inception<-factor(fin$Inception)
  str(fin)#checking

  
  
#factor Variable trap(FVT):-
  ##its used for converting factors-value into non-factors values
  ##what is Trap here:-
  ##ex1:--
   z<-factor(c("11","12","11","13","12","12","14"))
   typeof(z)# its  an integer  ...its doesn't symbolizes numbers inside but the categories i.e. 11 12 13 14
   
   # big issue
   y<-as.numeric(z)
   typeof(y)
   y#represents as 1 2 1 3 2 2 4 as we loss actual values i.e. 11 12 11...etc
   
   #correct way:-
   y<-as.numeric(as.character(z))
   typeof(y)
   y# now represents correct values

#sub() and gsub() [substitution and group/gathered-substitution-functions]
   ?sub
   ?gsub#pattern matching replacement function 
#gsub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
  #replacing Dollars with empty string "" or we can say remove it 
fin$Expenses<-gsub("Dollars","",fin$Expenses)   
head(fin)
#similarly for coma","   
fin$Expenses<-gsub(",","",fin$Expenses)

#for revenue 
fin$Revenue<-gsub("\\$","",fin$Revenue)
      #here we used "\\"before the $ for making ESCAPE-sequence otherwise R recognized "$" as a special chacter
#similarly for coma ","
fin$Revenue<-gsub(",","",fin$Revenue)
head(fin)#check

#now for GROWTH
fin$Growth<-gsub("%","",fin$Growth)

#By using gsub foe replacement this all attributes are converted to characters:-
typeof(fin$Revenue)
typeof(fin$Growth)
typeof(fin$Expenses)
#now convert all of three into numeric (non-factor)
fin$Growth<-as.numeric(fin$Growth)
fin$Revenue<-as.numeric(fin$Revenue)
fin$Expenses<-as.numeric(fin$Expenses)
str(fin)#check


#method for locating mising data
complete.cases(fin)#true for complete rows & false for incomplete rows(means rows with missing data)

#by subsetting technique
fin[!complete.cases(fin),]  #preview the incomplete rows of data sets 
  ##here big problems is that the mising data which symbolizes by empty string is not recognized as missing one
  ##because its doesn't contains "NA"  for this problem we have to read our data in such way that its automatically
  ##allocate "NA" symbol to the empty places 


#for factor-values  ---- <NA>    for non-factor-value ----  NA

#Data filters:- Which() for non-missing data
?which #its used for indicating which indices are TRUE in corresponds to the argument in which-function

#if we use conventional method:-
fin[fin$Revenue==9746272,]
   #then its also confused with "NA"  i.e. 9746272==NA  o/p=NA
#if using which()
##ex1
  fin[which(fin$Revenue==9746272),]
##ex2
  fin[which(fin$Employees==45),]

  
#Data filters:--  is.na() for mising data
#conventional
fin[fin$Revenue==NA,]  #then all are showed up as "NA"
#ex
a<-c(1,3,NA,348)
is.na(a)#i.e.  false for constant values  but true for NA
#in DATASET:-
fin[is.na(fin$Expenses),]


#removing records in missing data:-
##in INdustry coulumn as we know:----
fin[is.na(fin$Industry),]

fin[!is.na(fin$Industry),]#opposite
#now removing
fin<-fin[!is.na(fin$Industry),]  #now row 14 & 15 are removed 
head(fin,20)#check 
      ## as after 13th id there is 16th id comes ..hence its removed
      ##but here row_names are also ommitted as we even removes two rows its showed us 500 rows 
      ##because R not treated it as number but the names of rows
##for adjusting rows with dataset:-
rownames(fin)<-1:nrow(fin)
head(fin,20)#check  again
nrow(fin)


#replacing missing data:-Factual  analysis method
## in state coulumn as we can predict what is the state by knowing or analysing City-names
fin[is.na(fin$State),]

#for city-names with  NEW YORk
fin[is.na(fin$State) & fin$City== "New York","State"]<-"NY"
fin[c(11,377),]#check

#for city-names with  san francisco
fin[is.na(fin$state) & fin$City== "San Francisco","State"]<-"CA"
fin[c(82,265),]#check

fin[!complete.cases(fin),]

#replacing missing data:--median inputation method
med_emp_rtl<-median(fin[,"Employees"],na.rm = TRUE)#here na.rm is seted as TRUE for not considering NA while calculating median
med_emp_rtl#56
##its batter if we calculate median Industry-wise
med_emp_rtl<-median(fin[fin$Industry=="Retail","Employees"],na.rm = TRUE)
med_emp_rtl#28
fin[is.na(fin$Employees) & fin$Industry=="Retail","Employees"]<-med_emp_rtl
fin[!complete.cases(fin),]#check
fin[3,]

#similarly Employees of financial -services
med_emp_fs<-median(fin[fin$Industry=="Financial Services","Employees"],na.rm = TRUE)
med_emp_fs
fin[is.na(fin$Employees) & fin$Industry=="Financial Services","Employees"]<-med_emp_fs
fin[330,]#check


fin[!complete.cases(fin),]
#for growth
med_growth_const<-median(fin[fin$Industry=="Construction","Growth"],na.rm = TRUE)
med_growth_const
fin[is.na(fin$Growth) & fin$Industry=="Construction","Growth"]<-med_growth_const
fin[8,] #check

#for Revenue 
med_revenue_const<-median(fin[fin$Industry=="Construction","Revenue"],na.rm = TRUE)
med_revenue_const
fin[is.na(fin$Revenue) & fin$Industry=="Construction","Revenue"]<-med_revenue_const
fin[c(8,42),] #check

fin[!complete.cases(fin),]

#for Expenses
med_expenses_const<-median(fin[fin$Industry=="Construction","Expenses"],na.rm = TRUE)
med_expenses_const
fin[is.na(fin$Expenses) & fin$Industry=="Construction","Expenses"]<-med_expenses_const
fin[c(8,42),] #check

#replacing mising data :-deriving values method
##Revenue - Expenses = profit
##Revenue - profit = Expenses
fin[!complete.cases(fin),]
#for profit 
fin[is.na(fin$Profit),"Profit"]<-fin[is.na(fin$Profit),"Revenue"]-fin[is.na(fin$Profit),"Expenses"]
fin[c(8,42),]#check

#for Expenses
fin[is.na(fin$Expenses),"Expenses"]<-fin[is.na(fin$Expenses),"Revenue"]-fin[is.na(fin$Expenses),"Profit"]
fin[15,]#check

fin[!complete.cases(fin),]


#visualizations:---
library(ggdark)
library(ggplot2)
##Scatterplot-1.1 :-- classified by industry for Revenue & Expenses ,Profit
p<-ggplot(data=fin)
p+geom_point(aes(x=Revenue,y=Expenses,colour=Industry,size=Profit))

?ggdark
#scatterpot 1.2
p<-ggplot(data = fin ,aes(x=Revenue,y=Expenses,colour=Industry,size=Profit))
d<-p+geom_point()+geom_smooth(fill=NA,size=1.2)
d+dark_mode()

invert_geom_defaults()#restore geom defaults to theire original values

#boxplot
f<-ggplot(data=fin,aes(x=Industry,y=Growth,colour=Industry))
f+geom_jitter()+geom_boxplot(size=1,alpha=0.5,outlier.colour = NA)

                                   ##----THE END----##
