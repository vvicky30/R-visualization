c(rnorm(4),rnorm(2),rnorm(1))#we can do this
c(rep("hello",3),seq(1,5))#we can do this also

x<-rnorm(5)
#conventional programming loop
for(i in 1:5)
{print(x[i])
}
#r specified lopp
for(i in x)
{print(i)
}