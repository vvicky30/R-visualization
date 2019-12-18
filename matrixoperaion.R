Games
#matrix operation
vector1<-rep(c(1,0,1),3)
vector2<-rep(c(0,1,0),3)
vector1
vector2
m1<-matrix(vector1,3,3)
m1
m2<-matrix(vector2,3,3)
m2
m<-m1+m2
m
rownames(m)<-c("r1","r2","r3")
colnames(m)<-c("c1","c2","c3")
m
#matrix operation using bascketball data set
MinutesPlayed
Games
   #minutes played per games
    round(MinutesPlayed/Games,2)
    #field-goals scored per games
    FieldGoals
     Games
      round(FieldGoals/Games,0)     
    #acuraccy of each player
      a<-round(FieldGoals/FieldGoalAttempts,2)
a      
a["LeBronJames","2005"]
rownames(a)

a["LeBronJames",]
a[,"2005"]
