getwd()
setwd("C:\\Users\\hp\\Desktop\\R-files\\R_advanced\\Weather-Data")
getwd()
#importing data
chicago<-read.csv("Chicago-F.csv",row.names = 1)
chicago
#here in data we make 1 coulumn as rownames for dataframe for batter compability
newyork<-read.csv("NewYork-F.csv",row.names = 1)
newyork
houston<-read.csv("Houston-F.csv",row.names = 1)
houston
sanfrancisco<-read.csv("SanFrancisco-F.csv",row.names = 1)
sanfrancisco
#there are dataframes
is.data.frame(chicago)
#but let convert it into matrix
chicago<-as.matrix(chicago)
newyork<-as.matrix(newyork)
houston<-as.matrix(houston)
sanfrancisco<-as.matrix(sanfrancisco)

#check
is.matrix(newyork)
is.matrix(sanfrancisco)
is.matrix(houston)
is.matrix(chicago)


#now put this on list
weather<-list(chicago=chicago,newyork=newyork,houston=houston,sanfrancisco=sanfrancisco)
weather#check
weather$newyork
#or
weather[[2]]
#for specically
weather[[2]][,"Jan"]
weather[[2]][,1]#or

#using apply
#?apply(array, margin, ...)
apply(chicago,1,mean)
#check by conventional ways
mean(chicago["AvgPrecip_inch",])
#analyze one city for max/min
apply(chicago,1,max)
apply(chicago,1,min)
#compare (closer approach to result)
apply(chicago,1,mean)
apply(newyork,1,mean)
apply(houston,1,mean)
apply(sanfrancisco,1,mean)

#recreating function with loops
#finding mean for every loops
#via loops
output<-NULL
for(i in 1:5){output[i]<-mean(chicago[i,])}#run cycle
output #let see
#then
names(output)<-rownames(chicago)
output#finally
apply(chicago,1,mean)#so the result is identical

#using lapply()
# ?lapply(list, function)
chicago
#transpose it
t(chicago)
#but if we want to transpose each matrix in list then we use lapply()
my_new_list<-lapply(weather,t)
#EX1
rbind(chicago,NewRow=1:12)
lapply(weather,rbind,Newrow=1:12)
#EX2
rowMeans(chicago)
lapply(weather, rowMeans)#same approach
#also for
#rowmeans
#coulmnmeans
#rowsums
#coulumnsums
#combining lapply with "[]"
weather[[1]][1,1]
#for retriving avg_high_F of jan-month for all cities
lapply(weather,"[",1,1)

lapply(weather,"[",1,)#for retriving avg_high_F  for all months of all cities..weather[[*]][1,]
#for taking all march data
lapply(weather,"[",,3)


#adding our own function
lapply(weather,function(z) z[1,]-z[2,])#avg_high_F - avg_low_F --------function
#now how temperature fluctuates in each coulumn from maxm to minm(base:minimum)
#formula:avg_high_F - avg_low_F/avg_low_F
lapply(weather,function(z) z[1,]-z[2,]/z[2,])
#but with decimal values with 2-precision
lapply(weather,function(z) round(z[1,]-z[2,]/z[2,],2))

#using sapply for further simplification
lapply(weather,"[",1,7)
sapply(weather,"[",1,7)#better

#avg_high_F for 4th quarter
lapply(weather,"[",1,10:12)
sapply(weather,"[",1,10:12)#better

#1st critics
round(sapply(weather,rowMeans),2)
#2nd critics
sapply(weather,function(z) round(z[1,]-z[2,]/z[2,],2))
sapply(weather,rowMeans,simplify = F)
    # as toshow that sapply is the version of the lapply

#nesting of apply function 
lapply(weather, function(z) apply(z,1,max))
lapply(weather,apply, 1,max)#peferable
#lokking tedious just simplify above one
sapply(weather,apply,1,max)#deliverable-3
sapply(weather,apply,1,min)#deliverable-4

#advanced analysis
#which.max()
which.max(chicago[1,])
  #jul--7
names(which.max(chicago[1,]))
#only jul
#as we have apply function for the iterate over rows of matrix
#and we also have the lapply & sapply to iterate over list of matrix 
###apply:----
apply(chicago ,1 ,function(x) names(which.max(x)))
#lapply:----
lapply(weather,function(y) apply(y ,1 ,function(x) names(which.max(x))))
#further simplification
month_max_amnt<-sapply(weather,function(y) apply(y ,1 ,function(x) names(which.max(x))))
month_max_amnt#deliverable-5
