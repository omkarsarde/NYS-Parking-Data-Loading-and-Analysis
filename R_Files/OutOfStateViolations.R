#
# Authors = (Omkar Sarde, Sharwari Salunkhe)
#

library(RMySQL)
sqlQuery <- function (query) {
  
  # creating DB connection object with RMysql package
  DB <- dbConnect(MySQL(), user="root", password="amrutha@94",
                  dbname="testSchema", host="localhost",port=3306)
  
  # close db connection after function call exits
  on.exit(dbDisconnect(DB))
  
  # send Query to obtain result set
  rs <- dbSendQuery(DB, query)
  
  # get elements from result sets and convert to dataframe
  result <- fetch(rs, -1)
  
  # return the dataframe
  return(result)
}
distinctStates = sqlQuery("select distinct(registrationState) from ParkingViolations.vehicleInfo;")
colors = c("blue", "yellow", "green", "violet",  "orange")
vehicleInfo <- sqlQuery(" select registrationState,count(plateId) as count from vehicleInfo group by registrationState  order by count desc limit 6;")
statesCount <- c(vehicleInfo[2,2],vehicleInfo[3,2],vehicleInfo[4,2],vehicleInfo[5,2],vehicleInfo[6,2])
states <- c(vehicleInfo[2,1],vehicleInfo[3,1],vehicleInfo[4,1],vehicleInfo[5,1],vehicleInfo[6,1])
states <- c('New Jersey','Pennsylvania','Connecticut','Florida','Massachusetts')
pie(statesCount,states,col = colors,main="Top 5 states with parking violations in NY(exluding NY)")
