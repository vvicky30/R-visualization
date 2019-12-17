#creating function
myplot<- function(){
  Data<-MinutesPlayed[1:3,,drop=F]
  matplot(t(Data),type="b",pch= 15:18,col=c(1:4,6))
  legend("bottomleft",inset = 0.01,legend = Players[1:3],col = c(1:4,6),pch = 15:18,horiz = F)
}
myplot()



#creating function with more flexibility i.e. default arg,arg etc
myplot<- function(data,rows=1:10){
  Data<-data[rows,,drop=F]
  matplot(t(Data),type="b",pch= 15:18,col=c(1:4,6))
  legend("bottomleft",inset = 0.01,legend = Players[rows],col = c(1:4,6),pch = 15:18,horiz = F)
}
myplot(Games)#as secong arg-rows seted as default here
myplot(FieldGoals/FieldGoalAttempts,rows = 1:4)
myplot(MinutesPlayed,1)
