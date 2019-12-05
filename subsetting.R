#subsetting
A<-1:12
A
B<-matrix(A,3,4,byrow = T)
B
     #subsettingof B
  B[c(1,3),]
c<-B[c(1,2),c(1,2)]
c
is.matrix(c)
is.vector(c)
  #subsetting erorrs of one diamentional(vector)
B[1,2]
B[1,2,drop=F]#resolve problem by using drop as argument

B
B[,2]
B[,2,drop=F]#-------------\\---------------------------
B[2,]
B[2,,drop=F]#--------------\\---------------------------

