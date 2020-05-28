getwd()
setwd("c:\\users\\hp\\Desktop\\Exploratory data analysis")
getwd()#checking
install.packages("readxl")#installing required package
library("readxl")#loading package
df <- read_excel("ANZ synthesised transaction dataset.xlsx")#loading file as dataframe
#exploring dataframe:-
head(df)
#here in dataframes we can see that , thire are many attributes that does'nt make any sense to the analysis so we drop that columns for while
#but here we create new dataframes with favourable columns :
ndf<-df[,c('status','card_present_flag','account','txn_description','first_name','balance','date','gender','age','merchant_suburb','merchant_state','amount','customer_id','movement','extraction')]
head(ndf)
#summary of new dataframe
summary(ndf)
str(ndf)

#as we know that the status should be as factor oe level :
ndf$status<- factor(ndf$status)#now its factor with level 2 :"authorized ", "posted" 
#now for account 
ndf$account<-factor(ndf$account)#account as factor has 100 levels 
#for costomer's name:
ndf$first_name<-factor(ndf$first_name)#first_name as factor has 80 levels 
#as account number is more than that of customers its means that some customers has more than one account 
#for customer id
ndf$customer_id<-factor(ndf$customer_id) #same levels as numbers of accounts i.e 100 levels
#now check whether any null values in dataframes or not 
complete.cases(ndf)#here are many rows which contains null values 
#but is thire any way to fill those values 
####lets check some sort of filters for that
ndf[is.na(ndf$card_present_flag),]
        #as here you can see that along with card_present_flag the merchgant_suburb merchan_state is also missing 

#as there is no way to fill out this values so we remove whole incomplete rows from dataframe
ndf<-ndf[!is.na(ndf$card_present_flag),]
complete.cases(ndf)#for checking whether thire is any nullified rows or not 

#now we again converting those values for refreshing thier levels after deletion of incomplete rows
#now we converting the moment as factor
ndf$movement<-factor(ndf$movement)
ndf$status<- factor(ndf$status)#status
ndf$account<-factor(ndf$account)#account
ndf$first_name<-factor(ndf$first_name)#names


ndf$customer_id<-factor(ndf$customer_id)#customer's id
ndf$gender<-factor(ndf$gender)#gender
ndf$txn_description<-factor(ndf$txn_description)#for taxation_descriptions 
ndf$card_present_flag<-factor(ndf$card_present_flag)#for card present flag
  #as card present flag had null values with posted-status customers 

str(ndf)#chacking for updates
#as here in structure of dataframe we can see that movement & status has 1 level means all customers in dataframe is with status=authorized & movement=debit
#so this status & movement column is does'nr make any sense to analysis as thire is no any veriety in them 

ndf$status=NULL
ndf$movement=NULL


head(ndf)#for check
#now converting extration to posixtime format
ndf$timestamp<-as.POSIXct(ndf$extraction)
as.POSIXlt(ndf$extraction)
ndf$timestamp=NULL

ndf$timestamp<-gsub( "T", " ", as.character(ndf$extraction))
ndf$Tstamp<-as.POSIXct(ndf$timestamp)
ndf$timestamp=NULL#removing processed columns
ndf$extraction=NULL#-------------------------
ndf$Tstamp#checking
str(ndf)

#now we can visualize the data:

#time-series plot(amount vs Tstamp)catagorized by gender:-
library('ggplot2')
p<-ggplot(data=ndf)
p+geom_line(aes(x=Tstamp, y=amount,colour=gender))

#time-series plot(Balance vs Tstamp ) catagorized by gender:-
p+geom_line(aes(x=Tstamp, y=balance,colour=gender))

#time series plot(amount vs Tstamp) catagorized by gender with saperate plot of card_present or not:-                       
myplot<-p+geom_line(aes(x=Tstamp,y=amount,colour=gender),size=1.2)+facet_grid(card_present_flag~.)
myplot
#time series plot(amount vs Tstamp) catagorized by gender with saperate plot of card_present or not:-
myplot1<-p+geom_line(aes(x=Tstamp,y=balance,colour=gender),size=1.2)+facet_grid(card_present_flag~.)
myplot1


#converting merchant states to factors
ndf$merchant_state<-factor(ndf$merchant_state)
str(ndf)
#box-plot for visualizing average balance by states  
s<-ggplot(data=ndf,aes(x=merchant_state,y=balance))
s+geom_jitter(aes(colour=merchant_state))+geom_boxplot(alpha=0.5,outlier.color = NA)#gor removing extra dots of box plot

#plotting time series chart(amount vs Tstamp)colored by gender & facets representation of states along with transaction threshold set as 5000
myplot2<-p+geom_line(aes(x=Tstamp,y=amount,colour=gender),size=1.2)+facet_grid(merchant_state~.)+geom_hline(yintercept = 5000,colour='gray',size=1.2,linetype=3)
myplot2


#saving/exporting  processed dataframe to csv :-
write.csv(ndf,"c:\\users\\hp\\Desktop\\Exploratory data analysis\\processed.csv", row.names = FALSE)
