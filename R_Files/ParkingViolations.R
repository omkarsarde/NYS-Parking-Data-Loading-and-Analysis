#
# Authors = (Omkar Sarde, Sharwari Salunkhe)
#

library(RMySQL)
library(dplyr)
library(ggplot2)
library(scales)

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
PrecinctViolations <- sqlQuery(" SELECT violationPrecinctId, count(violationPrecinctId) as count FROM ParkingViolations.parkingViolation GROUP BY violationPrecinctId;")

top6PrecinctViolations <- PrecinctViolations %>%
                        arrange(desc(count)) %>%
                        select(violationPrecinctId, count) %>%
                        top_n(6)

violationCodes <- sqlQuery("Select * from ParkingViolations.violationCode")

ViolationCounties <- sqlQuery("SELECT  violationCounty, violationCode, count(summonsID) as count
FROM ParkingViolations.parkingviolation
GROUP BY violationCounty,violationCode;")
violationCountiesQ <- ViolationCounties %>%
  filter(violationCounty == 'Q') %>%
  inner_join(violationCodes, by="violationCode") %>%
  arrange(desc(count)) %>%
  select(violationCounty, violationDefinition,count) %>%
  top_n(5)
violationCountiesK <- ViolationCounties %>%
  filter(violationCounty == 'K') %>%
  inner_join(violationCodes, by="violationCode") %>%
  arrange(desc(count)) %>% 
  select(violationCounty, violationDefinition,count) %>%
  top_n(5)

violationCountiesBX <- ViolationCounties %>%
  filter(violationCounty == 'BX') %>%
  inner_join(violationCodes, by="violationCode") %>%
  arrange(desc(count)) %>%
  select(violationCounty, violationDefinition,count) %>%
  top_n(5)


violationCountiesST <- ViolationCounties %>%
  filter(violationCounty == 'ST') %>%
  inner_join(violationCodes, by="violationCode") %>%
  arrange(desc(count)) %>%
  select(violationCounty, violationDefinition,count) %>%
  top_n(5)

violationCountiesNY <- ViolationCounties %>%
  filter(violationCounty == 'NY') %>%
  inner_join(violationCodes, by="violationCode") %>%
  arrange(desc(count)) %>%
  select(violationCounty, violationDefinition,count) %>%
  top_n(5)
                   
violationsCountiesTop5Each <- rbind(violationCountiesQ,violationCountiesST,violationCountiesK, violationCountiesNY, violationCountiesBX)        




ggplot(violationsCountiesTop5Each) +
  # add bar for each discipline colored by gender
  geom_bar(aes(x = violationCounty, y = count, fill = violationDefinition),
           stat = "identity", position = "dodge") +
  # name axes and remove gap between bars and y-axis
  scale_y_continuous("Violation Count", expand = c(0, 0),labels = comma) +
  scale_x_discrete("Counties in New York City",labels=c("Bronx", "Kings/Brooklyn","New York/Manhattan","Queens","Staten Island/Richmond")) +
  # remove grey theme
  theme_classic(base_size = 18) +
   labs(fill='Violation Types') +
  
  #ggtitle("Top 5 Parking Violation Types in Counties from New York")+
  # rotate x-axis and remove superfluous axis elements
  theme(
      axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "top",
      legend.direction='horizontal',
      legend.title=element_text(size=20), 
      legend.text=element_text(size=22),
      axis.text=element_text(size=20),
      axis.title=element_text(size=22,face="bold"))
  



                        

