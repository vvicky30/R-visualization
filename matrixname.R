#naming of vectors
vector<-c(1,2,3,4,5,7,4,2,6)
vector
names(vector) <- c("v1","v2","v3","v4","v5","v6","v7","v8","v9")
vector
names(vector)<-NULL
vector
#naming matrix using colnames( )and rownames()
temp.vec<-rep(c("Aa","Bb","Zz"),each=3)
temp.vec
t<-matrix(temp.vec,3,3,byrow = T)
t
rownames(t)<-c("A1","B1","C1")
colnames(t)<-c("p","q","r")
t
rownames(t)<-NULL
t
t["B1","q"]
t["C1","p"]
t
t["A1","q"]<-4
t
