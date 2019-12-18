
getwd()
setwd("c://users//hp//Desktop//vedant")
mov<-read.csv(choose.files())
head(mov)
summary(mov)
str(mov)
#activate ggplot2
library(ggplot2)
  #cool insights:-
       #(when is movies are generally released)
ggplot(data=mov,aes(x=Day.of.Week))+geom_bar()
     #here we can't used geom_histogram because Day.of.Week is the factor not numeric value(with mean&mode)
#filtering dataframe
 #1-filter
mov$Genre
   filt<-(mov$Genre=="action")|(mov$Genre=="adventure")|(mov$Genre=="animation")|(mov$Genre=="comedy")|(mov$Genre=="drama")
mov$Studio
    #2-filter(another method)
   filt1<-mov$Studio %in% c("Buena Vista Studios", "WB", "Fox", "Universal", "Sony", "Paramount Pictures")
   
   filt   
  filt1

  mov2<-mov[filt & filt1,]#for combining desired datasets
  head(mov2)
  str(mov2)
  tail(mov2)
  
  #first prepare plot's data aestatics &layer
  p<-ggplot(data = mov2,aes(x=Genre,y=Gross...US))
p
#add geometry
q<-p+geom_jitter(aes(size=Budget...mill.,colour=Studio))+
  geom_boxplot(alpha=0.3,outlier.color = NA)
        #we used here outlier for removing extra dots of boxplots
q<-q+
  xlab("Genre")+
  ylab("gross % US")+
  ggtitle("Domestic Gross % by Genre")+
  theme(axis.title.x = element_text(colour = "blue",size="20"),
        axis.title.y = element_text(colour = "blue",size = 20),
        axis.text.x = element_text(colour = "red",size = 10),
        axis.text.y = element_text(colour = "red",size = 10),
        plot.title = element_text(colour = "purple",size = 30),
        legend.title = element_text(size = 20),
        legend.text = element_text(size = 15),
        text = element_text(family="courier")
  )#here we used 'text' to chage all plotted type of text's font
q$labels
q$labels$size<-"Budget $M"
warnings()
q   
