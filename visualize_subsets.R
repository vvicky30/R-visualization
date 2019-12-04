#visualizationof subsets
   #script for plotting graph for top three players of bascketball
MinutesPlayed
b<-MinutesPlayed[1:3,]
b
a<-t(b)
a
matplot(a,type = "b",pch = 15:18,col=c(1:4,6))
legend("bottomleft",inset = 0.01,legend = Players[1:3],col = c(1:4,6),pch = 15:18,horiz =F)
Players


#script for plotting graph for only "lebronjames" accuracy
z<-round(FieldGoals/FieldGoalAttempts,2)
z
Z<-t(z)
Z
c<-Z[,"LeBronJames",drop=F]
c
matplot(c,type = "b",pch = 15:18,col=c(1:4,6))
legend("bottomleft",inset = 0.01,legend = Players[3],col = c(1:4,6),pch = 15:18,horiz =F)
Players[3]


