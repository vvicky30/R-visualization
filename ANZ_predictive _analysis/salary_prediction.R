getwd()
setwd("c:\\users\\hp\\Desktop\\ANZ_predictive _analysis")
getwd()#checking

library(stringr)
library(lubridate)
library(tidyverse)
library(modelr)
library(sp)
library(leaflet)
library(geosphere)
library(knitr)
library(rpart)

library("readxl")#loading package
df <- read_excel("Dataset\\ANZ synthesised transaction dataset.xlsx")#loading file as dataframe
#exploring dataframe:-
head(df)

# examine the summary of the dataset
summary(df)
str(df)
# change the format of date column
df$date<- as.Date(df$date,format = "%d/%m/%Y")
# the dateset only contain records for 91 days, one day is missing
DateRange <- seq(min(df$date), max(df$date), by = 1)
DateRange[!DateRange %in% df$date] # 2018-08-16 transactions are missing
# derive weekday and hour data of each transaction
df$extraction = as.character(df$extraction)
df$hour = hour(as.POSIXct(substr(df$extraction,12,19),format="%H:%M:%S"))
df$weekday = weekdays(df$date)
# confirm the one -to -one link of account_id and customer_id
df %>% select(account,customer_id) %>%
  unique() %>%
  nrow()


# split customer & merchant lat_long into individual columns for analysis
dfloc = df[,c("long_lat","merchant_long_lat")]
dfloc<- dfloc %>% separate("long_lat", c("c_long", "c_lat"),sep=' ')
dfloc<- dfloc %>% separate("merchant_long_lat", c("m_long", "m_lat"),sep=' ')
dfloc<- data.frame(sapply(dfloc, as.numeric))
df <- cbind(df,dfloc)
# check the range of customer location
# filtering out transactions for those who don't reside in Australia
############3Reference: http://www.ga.gov.au/scientific-topics/national-location-information/dimensions/continental-extremities
df_temp <- df %>%
  filter (!(c_long >113 & c_long <154 & c_lat > (-44) & c_lat < (-10)))
length(unique(df_temp$customer_id))


# check the distribution of missing values
apply(df, 2, function(x) sum(is.na(x)| x == ''))
# check the number of unique values for each column
apply(df, 2, function(x) length(unique(x)))


# filtering out purchase transactions only
# assuming purchase transactions must be associated with a merchant (have a merchant Id)
df_temp <- df %>% filter(merchant_id != '' )
# it turned out that is equivilent to excluding following categories of transactions
df_csmp <- df %>%filter(!(txn_description %in% c('PAY/SALARY',"INTER BANK", "PHONE BANK","PAYMEN
                                                 T")))
summary(df_csmp)

# visualise the distribution of transaction amount
hist(df_csmp$amount[!df_csmp$amount %in% boxplot.stats(df_csmp$amount)$out],    
     xlab= 'Transaction Amount', main = 'Histogram of purchase transaction amount')
#here we exclude outlieirs
hist(df$amount[!df$amount %in% boxplot.stats(df$amount)$out], #exclude outliers
     xlab= 'Transaction Amount',main = 'Histogram of overall transaction amount')


#Visualise customers'average monthly transaction volume.
df2 <- df %>%
  group_by(customer_id) %>%
  summarise(mon_avg_vol = round(n()/3,0))
hist(df2$mon_avg_vol,
     xlab= 'Monthly transaction volume', ylab='No. of customers', main = "Histogram of customer
     s' monthly transaction volume")


#Segment the dataset by transaction date and time.
# Visualise transaction volume over an average week.
df3 <- df %>%
  select(date,weekday) %>%
  group_by(date,weekday) %>%
  summarise(daily_avg_vol = n()) %>%
  group_by(weekday) %>%
  summarise(avg_vol=mean(daily_avg_vol,na.rm=TRUE ))
df3$weekday <- factor(df3$weekday, levels=c( "Monday","Tuesday","Wednesday",
                                             "Thursday","Friday","Saturday","Sunday"))
ggplot(df3,aes(x=weekday, y=avg_vol)) +geom_point()+geom_line(aes(group = 1))+
  ggtitle('Average transaction volume by weekday') +
  labs(x='Weekday',y='Transaction volume')


# visualize transaction volume over an average week.
df4 <- df %>%
  select(date,hour) %>%
  group_by(date,hour) %>%
  summarize(trans_vol=n()) %>%
  group_by(hour) %>%
  summarize(trans_vol_per_hr = mean(trans_vol,na.rm=TRUE))
ggplot(df4,aes(x=hour,y=trans_vol_per_hr))+geom_point()+geom_line(aes(group = 1))+
  ggtitle('Average transaction volume by hour') +
  labs(x='Hour',y='Transaction volume') + expand_limits( y = 0)


#challenge: exploring location information
#We could firstly see the distribution of distance between a customer and the merchange he/she trades with.
# exclude the single foreign customer whose location information was incorrectly stored (i.e latitude 573)
df_temp <- df_csmp %>%
  filter (c_long >113 & c_long <154 & c_lat > (-44) & c_lat < (-10))
dfloc = df_temp [,c("c_long", "c_lat","m_long", "m_lat")]
dfloc<- data.frame(sapply(dfloc, as.numeric))
dfloc$dst <- distHaversine(dfloc[, 1:2], dfloc[, 3:4]) / 1000
hist(dfloc$dst[dfloc$dst<100], main = "Distance between customer and merchants",xlab= 'Distance (km)' )



# second module solution starts here:------------------------
df_inc = data.frame(customer_id= unique(df_csmp$customer_id)) #create a data frame to store result

head(df_inc)#checking

# create a mode function that will be used to find out what is the salary payment frequency
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


# loop through all salary payment for each customer
# assume the salary level is constant for each customer over the observed period
for (i in seq(nrow(df_inc))){
  trans_data <- df[df$customer_id == df_inc$customer_id[i]
                   & df$txn_description=='PAY/SALARY',c("amount","date")] %>%
    group_by(date) %>%
    summarise(amount = sum(amount))
  total_s <- sum(trans_data$amount)
  count = dim(trans_data)[1]
  if ( count == 0){
    df_inc$freq[i] = NA
    df_inc$level[i] = NA
  } else {
    s=c()
    lvl = c()
    for (j in seq(count-1)){
      s = c(s,(trans_data$date[j+1]-trans_data$date[j]))
      lvl = c(lvl,trans_data$amount[j])
    }
    lvl = c(lvl,tail(trans_data$amount,n=1))
    df_inc$freq[i] = Mode(s)
    df_inc$level[i] = Mode(lvl)
  }
}

df_inc$annual_salary= df_inc$level / df_inc$freq *365.25

head(df_inc)#checking

# visualise the distribution of customers' annual salary
hist(df_inc$annual_salary[!is.na(df_inc$annual_salary)],
     main = "Histogram of customers' annual salary", xlab= 'Income($)')


#Explore correlations between annual salary and various customer attributes like AGE.

# create a dataframe to store relevant features for customers
df_cus <-df_csmp %>% # use df_csmp to summarize customers' consumption behavior
  select (customer_id,gender,age,amount,date,balance) %>%
  group_by(customer_id) %>%
  mutate(avg_no_weekly_trans= round(7*n()/length(unique(df$date)),0),max_amt = max(amount),
         no_large_trans = sum(amount>100), # an arbitrary $100 benchmark is selected based on the
         # transaction amount histogram created in task above
         use_no_day=length(unique(date)),
         avg_trans_amt = mean(amount, na.rm =TRUE),
         med_bal = median(balance,na.rm=TRUE)) %>%
  select(-c("amount","date","balance")) %>%
  unique()


# create additional features or we can say derived features
df_cus$age_below20 <- ifelse(df_cus$age<20,1,0)
df_cus$age_btw20n40 <- ifelse(df_cus$age>=20 & df_cus$age <40,1,0)
df_cus$age_btw40n60 <- ifelse(df_cus$age>=40 & df_cus$age <60,1,0)

## investigate the state where customers live
# assume they live where most transactions occured (indicated by merchant_state)
df_region <-df_csmp %>%
  group_by(customer_id,merchant_state) %>%
  summarize(trans_count=n()) %>%
  group_by(customer_id) %>%
  mutate (no_state = n()) %>%
  filter(trans_count == max(trans_count))


# For equal number of transactions between multiple States, pick the most likely State
n_occur = data.frame(table(df_region$customer_id))
cus_id_rep = n_occur$Var1[n_occur$Freq > 1]
state_by_cust_no <- rev(names(sort(table(df_region$merchant_state),rev = TRUE)))
t = data.frame(customer_id = cus_id_rep, merchant_state=NA)
for (i in seq(length(cus_id_rep))){
  s = df_region$merchant_state[df_region$customer_id == cus_id_rep[i]]
  for (state in state_by_cust_no){
    if (state %in% s){
      t[i,2] = state
      break
    }
  }
}


df_region <- df_region[!(df_region$customer_id %in% cus_id_rep), c(1,2)] %>%
  as.data.frame() %>%
  rbind(t) %>%
  rename( State = merchant_state)


# merge all the features into single dataframe
df_cus <- df_cus %>% merge(df_inc) %>%
  merge(df_region)

# extract relevant features
df_cus_attr <- df_cus %>%
  select("gender","annual_salary","age","avg_no_weekly_trans","max_amt",
         "no_large_trans", "use_no_day","avg_trans_amt","med_bal","State")

plot(df_cus_attr)



#Build a simple regression model to predict the annual salary for each customer
# start with the model that includes all features created
fit1 <- lm(annual_salary ~.-customer_id - level-freq,data=df_cus)
summary(fit1)
MASS::stepAIC(fit1)


# backwards model selection, together with stepAIC yield the most appropriate model:
fit2 <- lm(formula = annual_salary ~ age + avg_trans_amt + med_bal +
             age_below20 + age_btw20n40 + age_btw40n60, data = df_cus)
summary(fit2)

# Call:
#   lm(formula = annual_salary ~ age + avg_trans_amt + med_bal + 
#        age_below20 + age_btw20n40 + age_btw40n60, data = df_cus)
# 
# Residuals:
#   Min     1Q Median     3Q    Max 
# -42579 -17760  -5140  15158  70974 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)  
# (Intercept)   7.901e+02  3.606e+04   0.022   0.9826  
# age           5.181e+02  4.830e+02   1.073   0.2862  
# avg_trans_amt 4.183e+01  8.602e+01   0.486   0.6279  
# med_bal       1.265e-01  7.529e-02   1.680   0.0963 .
# age_below20   5.577e+04  2.996e+04   1.861   0.0659 .
# age_btw20n40  4.843e+04  2.545e+04   1.903   0.0601 .
# age_btw40n60  3.696e+04  2.057e+04   1.797   0.0756 .
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 24860 on 93 degrees of freedom
# Multiple R-squared:  0.08355,	Adjusted R-squared:  0.02442 
# F-statistic: 1.413 on 6 and 93 DF,  p-value: 0.2179


# examine the residules to capture any missed relationships
plot(fit2$residuals, ylab = 'Residual')


#How accurate is your model?
  # to see model accuracy
  rmse(fit2,df_cus)
  # 23973.15

  
#making decision tree:-----
#split into train and test datasets
  smp_size <- floor(0.75 * nrow(df_cus))
  ## set the seed to make your partition reproducible
  set.seed(123)
  train_ind <- sample(seq_len(nrow(df_cus)), size = smp_size)
  df_cus_train <- df_cus[train_ind, ]
  df_cus_test <- df_cus[-train_ind, ]
  fit3 <- rpart(annual_salary ~gender + age + avg_no_weekly_trans + max_amt + no_large_trans + use_no_day + avg_trans_amt + med_bal + age_below20 + age_btw20n40 + age_btw40n60 + State, method ="anova", data=df_cus_train)

  plot(fit3, uniform=TRUE,
       main="Regression Tree for Annual Salary ")
  text(fit3, use.n=TRUE, all=TRUE, cex=.8)

  
  # examine the prediction accuracy
  rmse(fit3, df_cus_test)  
  # 23189.04
  