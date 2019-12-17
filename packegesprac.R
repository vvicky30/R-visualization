?qplot()
?ggplot2
?diamonds

#mispricing concept analysis
qplot(data=diamonds,carat,price,colour=clarity
      ,facets = .~clarity)
#mtcars alalysis
head(mtcars)
#use data from dataframes
qplot(mpg,wt,data=mtcars)
qplot(mpg,wt,data=mtcars,geom = c("point","smooth"))
qplot(mpg,wt,data = mtcars,colour= factor(cyl),
      geom = c("point","smooth"))
qplot(data=diamonds,carat,price,colour=clarity,
      geom = c("point","smooth"))
