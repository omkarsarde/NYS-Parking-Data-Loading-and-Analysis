#
# Authors = (Omkar Sarde, Sharwari Salunkhe)
#

# install.packages("arules")
# install.packages("arulesViz")
library(RMySQL)
sqlQuery <- function (query) {
  
  # creating DB connection object with RMysql package
  DB <- dbConnect(MySQL(), user="root", password="amrutha@94",
                  dbname="ParkingViolations", host="localhost",port=3306)
  
  # close db connection after function call exits
  on.exit(dbDisconnect(DB))
  
  # send Query to obtain result set
  rs <- dbSendQuery(DB, query)
  
  # get elements from result sets and convert to dataframe
  result <- fetch(rs, -1)
  
  # return the dataframe
  return(result)
}
library(arules)
library(arulesViz)
violationsCountPerDay <- sqlQuery("select issueDate, count(summonsId) 
from ParkingViolations.parkingviolation
group by issueDate;")
library(dplyr)
# http://www.sthda.com/english/articles/40-regression-analysis/167-simple-linear-regression-in-r/

library(lubridate)
library(ggplot2)
violationsCountPerDayFormatted <- violationsCountPerDay %>%
  filter( `count(summonsId)`>1000 
             & as.Date(issueDate, format="%m/%d/%Y") > as.Date("01/01/2019",format="%m/%d/%Y")
             & as.Date(issueDate, format="%m/%d/%Y") < as.Date("12/31/2019",format="%m/%d/%Y"))  %>%
  arrange(as.Date(issueDate, format="%m/%d/%Y")) %>%
  select(issueDate,`count(summonsId)`)

  violationsCountPerDayFormatted$issueDateNumber <- yday(mdy(violationsCountPerDayFormatted$issueDate))
 
  violationsCountPerDayFormatted$CountNumber <-  mean(violationsCountPerDayFormatted$CountNumber)*ones(size(violationsCountPerDayFormatted$CountNumber))
  
ggplot(violationsCountPerDayFormatted, aes(x = issueDateNumber, y =`count(summonsId)` )) +
 xlab("Date") +
  ylab("Violation Count")+
  ggtitle("Total Parking Violations per day")+
  geom_point() +
  stat_smooth()

cor(violationsCountPerDayFormatted$`count(summonsId)`, violationsCountPerDayFormatted$issueDateNumber)






