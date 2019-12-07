#qplot visualization part=I (soln to demographic analysis)
wd
head(wd)
qplot(data = wd,x=Income.Group,y=Birth.rate,size=I(2)
      #for coloured
      qplot(data = wd,x=Income.Group,y=Birth.rate,size=I(3),colour=I("green"))
  
#for legendery ploting ;colour based upon the income groups
      qplot(data = wd,x=Income.Group,y=Birth.rate,size=I(2),colour=Income.Group)
      wd[wd$Birth.rate>30 & wd$Income.Group=="High income",]
      qplot(data = wd,x=Income.Group,y=Internet.users,size=I(2),colour=Income.Group)
      wd[wd$Internet.users>90 & wd$Income.Group=="High income",]
      