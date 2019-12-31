getwd()
setwd("c:\\users\\hp\\Desktop\\vedant")
movies<-read.csv(file.choose())

head(movies)
#for better acessing operation
colnames(movies)<-c("film","genre","crtic.rating","audience.rating","budget.millions","year")
head(movies,13)
tail(movies)
summary(movies)#check

#now we convert the year column from non factor to factor as genre(column)
factor(movies$year)
movies$year<-factor(movies$year)
    #now checking
summary(movies)


#-----------ASTHETICS--------------(actually briefing ggplot2):-
library(ggplot2)
ggplot(data=movies,aes(x=crtic.rating,y=audience.rating))
#we add gemetry for plotting 
ggplot(data=movies,aes(x=crtic.rating,y=audience.rating))+geom_point()
#add colour
ggplot(data=movies,aes(x=crtic.rating,y=audience.rating,colour=genre))+geom_point()
ggplot(data=movies,aes(x=crtic.rating,y=audience.rating,colour=year))+geom_point()

#plotting with layers of geometry
p<-ggplot(data=movies,aes(x=crtic.rating,y=audience.rating,colour=genre,size=budget.millions))
p
#point
p+geom_point()
#lines
p+geom_line()
#multiple layers
p+geom_point()+geom_line()
p+geom_line()+geom_point()

#overidding asthetics
p+geom_point(aes(size=crtic.rating))#EX1
p+geom_point(aes(colour=budget.millions))#EX2
p+geom_point(aes(x=budget.millions))#EX3
p+geom_point(aes(x=budget.millions))+xlab("budget.millions(in$)")
                                       #xlab function is used for naming x axes
#EX4:-
p+geom_line()+geom_point()
p+geom_line(size=1)+geom_point()


#mapping V/s setting
p+geom_point(aes(colour=genre))#by mapping
p+geom_point(colour="darkgreen")


#other example:-
   #1 mapping
p+geom_line(aes(colour=genre))+geom_point(aes(size=budget.millions))
    #2 setting
p+geom_point(size=10)
#error:-
p+geom_point(aes(size=10))
  #here we using aesthetic fn for giving size=10 which is mis leading as a catagory-stuff