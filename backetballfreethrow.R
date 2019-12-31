myplot<- function(data,rows=1:10){
  Data<-data[rows,,drop=F]
  matplot(t(Data),type="b",pch= 15:18,col=c(1:4,6))
  legend("bottomleft",inset = 0.01,legend = Players[rows],col = c(1:4,6),pch = 15:18,horiz = F)
}

myplot(Freethrow)
myplot(freethrowattempts)

#1. freethrow attempts per game
myplot(freethrowattempts/Games)
#2. freethrow accuacy
myplot(Freethrow/freethrowattempts)
#player style pattern excluding freethrows
myplot((Points-Freethrow)/FieldGoals)
