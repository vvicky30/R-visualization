#merging data frames
#as here we going to merge two data frame i.e.mydf 'nd wd
head(wd)
head(mydf)
  #merging by using merge fn
merged<-merge(wd,mydf,by.x ="Country.Code",by.y = "code" )
head(merged)
merged$Country.Name<-NULL
head(merged)


#qplot visualization II (soln to reigional challenge)
  #___-_________-__write script to visualize new dataframe
library(ggplot2)
qplot(data=merged,x=Internet.users,y= Birth.rate,colour=regions)

#shaped plotting
qplot(data=merged,x=Internet.users,y= Birth.rate,colour=regions,shape=I(18),size=I(4))

#transperency or opacity
qplot(data=merged,x=Internet.users,y= Birth.rate,colour=regions,shape=I(18),size=I(4),alpha=I(0.6))


#how to write title of plotted graph
qplot(data=merged,x=Internet.users,y= Birth.rate,colour=regions,shape=I(18),size=I(4)
      ,main = "internet users v/s birth rate")
