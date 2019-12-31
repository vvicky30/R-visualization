#bascketball insight
myplot<- function(data,rows=1:10){
  Data<-data[rows,,drop=F]
  matplot(t(Data),type="b",pch= 15:18,col=c(1:4,6))
  legend("bottomleft",inset = 0.01,legend = Players[rows],col = c(1:4,6),pch = 15:18,horiz = F)
}

#salary
myplot(Salary)
myplot(Salary/Games)
myplot(Salary/FieldGoals)

#in-games matrices
myplot(FieldGoals/FieldGoalAttempts)
myplot(FieldGoals/Games)
myplot(FieldGoalAttempts/Games)
myplot(Points/Games)

#intresting observation
myplot(MinutesPlayed/Games)
myplot(Games)

#time valuable
myplot(FieldGoals/MinutesPlayed)

#player style
myplot(Points/FieldGoals)
