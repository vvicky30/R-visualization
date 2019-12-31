getwd()

setwd("c://users//hp//Desktop//vedant")

movies<-read.csv(file.choose())
head(movies)
colnames(movies)<-c("film","genre","critic.rating","audience.rating","budget.millions","year")
factor(movies$year)
str(movies)
summary(movies)
movies$year<-factor(movies$year)
#using facets
v<-ggplot(data=movies,aes(x=budget.millions))
v+geom_histogram(binwidth = 10,aes(fill=genre),color="black")
#if we want to make histogram with individual-hist representing each genre seperately
#then we use fcets___________
v+geom_histogram(binwidth = 10,aes(fill=genre),color="black")+facet_grid(genre~.)
#here all axes are uniform for all plotted raw-wise graph
#for plotting this row-wise graph with free and individual axes scale
v+geom_histogram(binwidth = 10,aes(fill=genre),color="black")+facet_grid(genre~.,scale="free")


#scatter plot:-
w<-ggplot(data=movies,aes(x=critic.rating,y=audience.rating,color=genre))
w+geom_point(size=3)
  #for faceting
w+geom_point(size=3)+facet_grid(genre~.)
#if:-
w+geom_point(size=3)+facet_grid(.~year)
#so we can:-
w+geom_point(size=3)+facet_grid(genre~year,scale="free")
#for smootning
w+geom_point(size=3)+facet_grid(genre~year,scale="free")+geom_smooth()
#set budget as size
w+geom_point(aes(size=budget.millions))+facet_grid(genre~year,scale="free")+geom_smooth(fill=NA)

