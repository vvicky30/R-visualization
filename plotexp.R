#generate some data(sex)
?set.seed(1234)
mydata =data.frame(
  sex= factor(rep(c("lounde","londiya"),each=200)),
  weight =c(rnorm(200,55), rnorm(200,58))
)
head(mydata)

#histogram plot
qplot(weight, data = mydata,geom = "histogram",colour=sex)
qplot(weight,data = mydata,geom = "histogram",fill=sex)

#density plot
qplot(weight,data=mydata,geom="density",colour=sex)
  
