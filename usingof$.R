#using of $(dollar) sign
stats
head(stats)
    #using of square brackets
    stats[5,]
    stats[3,3]
    stats[3,4]
    
    stats["Aruba",3]#we can't acess them by this,becoz 'country.name' is also a coulmn
    
  #$ using dollar sign
    head(stats)
stats$Country.Name    
stats$Country.Code
stats$Birth.rate
stats$Internet.users[5]#we acess 2nd no. value of vector
stats$Birth.rate[5]#--------------\\--------------------

#for identifying factors wrt coulmns
?levels()
levels(stats$Income.Group)
levels(stats$Country.Code)
