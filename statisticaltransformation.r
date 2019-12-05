#statistical transformation
?geom_smooth
movies<-read.csv(file.choose())
head(movies)
colnames(movies)<-c("film","genre","critic.rating","audience.rating","budget.millions","year")
factor(movies$year)
str(movies)
summary(movies)
movies$year<-factor(movies$year)
u<-ggplot(data=movies,aes(x=critic.rating,y=audience.rating,colour=genre))
u+geom_point()+geom_smooth()
         #for vanishing automatic fill colour of geom_smooth
u+geom_point()+geom_smooth(fill=NA)
u+geom_point()+geom_smooth(alpha=0.1)#other way by opacity option
  #box-plot__--------
w<-ggplot(data = movies,aes(x=genre,y=audience.rating,colour=genre))
w+geom_boxplot()
w+geom_boxplot(size=1.2)#for sizening
w+geom_boxplot(size=1.2)+geom_point()
     #tip hack:
w+geom_boxplot(size=1.2)+geom_jitter()
w+geom_jitter()+geom_boxplot(size=1.2,alpha=0.5)
         #changing order of plotting and adding opacity feature