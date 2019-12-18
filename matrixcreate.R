#matrix by using matrix fuction
mydata=1:15
mydata
m<-matrix(mydata,5,3,byrow = F)
m
m[3,2]
m[3,3]

#matrix by using rowbind function
v1<-c("hello","abhi","jeet")
v2<-c("how","are","you")
v<-rbind(v1,v2)
v
b<-matrix(v,3,3)
b

#matrix by using coulumnbind function
c1<-c("i","am","learning","R")
c2<-c("wow","what","is","d-day")
c3<-c(1,2,3,4)
c<-cbind(c1,c2,c3)
c
r<-rbind(c1,c2,c3)
r
