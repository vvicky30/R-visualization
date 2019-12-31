#data
revenue<-c(14574.49,7606.46,8611.41,9175.41,8058.65,8105.44,11496.28,9766.09,10305.32,14379.96,10713.97,15433.50)
expenses<-c(12051.82,5695.07,12319.20,12089.72,8658.57,840.20,3285.73,5821.12,6976.93,16618.61,10054.37,3803.96)
#solution
#profit fdor each month
profit<-revenue-expenses
profit

#profit after tax for each month(tax rate 30%)
tax<-round(profit*0.3,2)
profit.after.tax<-profit-tax
profit.after.tax
#profit margin for each month-equals to profit.after.tax devided by revenue
profit.margin<-round(profit.after.tax/revenue,2)*100
profit.margin
#curve plot
qplot(revenue,expenses,geom = c("line","smooth"))
qplot(revenue,expenses,colours=expenses,facets = .~expenses)
qplot(expenses,geom = "histogram")
plot(revenue,geom="density")

#good months-where the profit.after.tax was grater than the mean for the year
mean.profit<-mean(profit.after.tax)
good.months<-profit.after.tax>mean.profit
good.months
#bad.month-visevesa of above
bad.months<-!good.months
bad.months
#the bestmonth-where the profit after tax was max for the year
best.month<-profit.after.tax==max(profit.after.tax)
best.month
#the bad.month-where the profit afer tax was min for the year
worst.month<-profit.after.tax==min(profit.after.tax)
worst.month


#converting all units to the 1K(1000) with no decimal(set-precision=0)
revenue.1000<-round(revenue/1000)
expenses.1000<-round(expenses/1000)
profit.1000<-round(profit/1000)
profit.after.tax.1000<-round(profit.after.tax/1000)

#output
revenue.1000
expenses.1000
profit.1000
profit.after.tax.1000
profit.margin
good.months
bad.months
best.month
worst.month

#outpur matrices
m <- rbind(
  
  revenue.1000,
  expenses.1000,
  profit.1000,
  profit.after.tax.1000,
  profit.margin,
  good.months,
  bad.months,
  best.month,
  worst.month
  
)
m
