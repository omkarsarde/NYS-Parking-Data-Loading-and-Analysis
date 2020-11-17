
library(RMySQL)
library(lubridate)
library(dplyr)
library(data.table)
library(bit64)
library(tidyr)
library(caTools)
library(plotly)


---
  # Authors = (Omkar Sarde, Sharwari Salunkhe)

  ---
  
  
  sqlQuery <- function (query) {
    # creating DB connection object with RMysql package
    DB <- dbConnect(
      MySQL(),
      user = "root",
      password = "password",
      dbname = "parkingviolations",
      host = "localhost",
      port = 3306
    )
    
    # close db connection after function call exits
    on.exit(dbDisconnect(DB))
    
    # send Query to obtain result set
    rs <- dbSendQuery(DB, query)
    
    # get elements from result sets and convert to dataframe
    result <- fetch(rs, -1)
    
    # return the dataframe
    return(result)
  }
  
  # collect data from mysql db
  fromSql <-
    sqlQuery(
      "select summonsId, vehiclePlateNumber, vehicleRegistrationState, issueDate, vehicleinfo.plateType, parkingviolation.violationCode, violationcode.fine_AllOtherAreas as Fine from parkingviolation
join vehicleinfo on
vehicleinfo.plateID = parkingviolation.vehiclePlateNumber and
vehicleinfo.registrationState = parkingviolation.vehicleRegistrationState
join violationcode on
parkingviolation.violationCode = violationcode.violationCode ;"
    )
  
  
  # collection of only important states and plate types
  # reduces data values by 5 million to approx 40.5 million
  # tdf <- mutate(df, issueDate = as.Date(issueDate, "%m/%d/%Y"))
  
  tdf<-fromSql
  plates <- c('PAS', 'COM', 'OMT', '999')
  states <- c('NY', 'NJ', 'PA', 'FL', 'MA', 'CT')
  tdf <- data.table(tdf)
  tdf <- tdf[tdf$plateType %in% plates]
  tdf <- tdf[tdf$vehicleRegistrationState %in% states]
  str(tdf)
  
  # random sampling to create data for mining
  # restricting size to 30 million due to system specs
  # applying encoding for categorical encoding
  data <- sample_n(tdf, 15000000)
  #data <- separate(data,
  #                 "issueDate",
  #                 c("Year", "Month", "Day"),
  #                 sep = "-")
  #
  
  # NY and top - 5 states with highest violation count after NY
  data$vehicleRegistrationState = factor(
    data$vehicleRegistrationState,
    levels = c('NY', 'NJ', 'PA' , 'FL', 'MA', 'CT'),
    labels = c(1, 2, 3, 4, 5, 6)
  )
  
  # 4 plate Types : passenger, commercial, omnibus Taxi, and blank plate types
  data$plateType = factor(
    data$plateType,
    levels = c('PAS', 'COM', 'OMT', '999'),
    labels = c(1, 2, 3, 4)
  )
  
  
  # combining data based on unique vehiclePlateNumber to find total fine
  # and frequency of violations for individual cars
  dataFreq <- data
  dataFreq <-
    as.data.table(data)[,
                        count := length(unique(summonsId)),
                        by = vehiclePlateNumber]
  
  dataFreq <- as.data.table(dataFreq)[,
                                      Fine := sum(Fine),
                                      by = vehiclePlateNumber]
  
  dataFreq <- unique(setDT(dataFreq), by = "vehiclePlateNumber")
  str(dataFreq)
  
  # Segregate Data for Multiple linear Regression
  # also separating Issue dates as Year Month Day in date formates
  dataToAnalyse <- sample_n(dataFreq,1500000)
  
  dataToAnalyse <- mutate(dataToAnalyse, issueDate = as.Date(issueDate, "%m/%d/%Y"))
  
  dataToAnalyse<- separate(dataToAnalyse,"issueDate",c("Year", "Month", "Day"),sep = "-")
  
  # multiple linear Regression
  # split training and testing data and train the model
  set.seed(99)
  datasetMLR <- dataToAnalyse[,c(3,5,7,9,10)]
  
  plates <- c('PAS', 'COM', 'OMT', '999')
  states <- c('NY', 'NJ', 'PA', 'FL', 'MA', 'CT')
  datasetMLR <- data.table(datasetMLR)
  datasetMLR <- datasetMLR[datasetMLR$plateType %in% plates]
  datasetMLR <- datasetMLR[datasetMLR$vehicleRegistrationState %in% states]
  
  # NY and top - 5 states with highest violation count after NY
  datasetMLR$vehicleRegistrationState = factor(
    datasetMLR$vehicleRegistrationState,
    levels = c('NY', 'NJ', 'PA' , 'FL', 'MA', 'CT'),
    labels = c(1, 2, 3, 4, 5, 6)
  )
  
  # 4 plate Types : passenger, commercial, omnibus Taxi, and blank plate types
  datasetMLR$plateType = factor(
    datasetMLR$plateType,
    levels = c('PAS', 'COM', 'OMT', '999'),
    labels = c(1, 2, 3, 4)
  )
  
  
  datasetMLR <- data.frame(datasetMLR)
  str(datasetMLR)
  split = sample.split(datasetMLR$Fine, SplitRatio = 0.8)
  training_set_fine = subset(datasetMLR, split == TRUE)
  test_set_fine = subset(datasetMLR, split == FALSE)
  regressor_fine = lm(formula = Fine ~ ., data = training_set_fine)
  summary(regressor_fine)
  
  # MLR with features : Count, Registration States and Plate Types
  colorsScale <- c('blue','red')
  result_fine_count_registration_plate <-
    plot_ly(
      data = training_set_fine,
      z = ~ Fine,
      x = ~ count,
      y = ~ vehicleRegistrationState,
      color = ~ plateType,
      colors = colorsScale,
      opacity = 0.5
    ) %>%
    add_markers(marker = list(size = 2))
  
  # visualize the regression
  result_fine_count_registration_plate
  
  
  # MLR with features : Count, Month and Plate Types
  colorsScale <- c('blue', 'red')
  result_fine_count_month_plate <-
    plot_ly(
      data = training_set_fine,
      z = ~ Fine,
      x = ~ count,
      y = ~ Month,
      color = ~ plateType,
      colors = colorsScale,
      opacity = 0.5
    ) %>%
    add_markers(marker = list(size = 2))
  
  # visualize the regression
  result_fine_count_month_plate
  
  
  
  
  # Segregating data for clustering
  dataTocluster <- dataFreq
  dataToCluster <- setDT(dataTocluster)[,paste0("dates",1:3):=tstrsplit(issueDate,"/")]
  dataTocluster <- setnames(dataTocluster,c("dates1","dates3"),c("Months","Years"))
  
  kmeansClusterData <- dataTocluster
  
  kmeansClusterData$Months <- factor(kmeansClusterData$Months,
                                     levels= c("01","02","03","04","05","06","07","08","09","10","11","12"),
                                     labels = c(1:12))
  
  kmeansClusterData$Years <- factor(kmeansClusterData$Years,
                                    levels= c("2016","2017","2018","2019","2020"),
                                    labels = c(1:5))
  
  # NA check as we did data encoding earlier
  kmeansClusterData <- na.omit(kmeansClusterData)
  
  # Kmeans for Years and Fine as a cluster
  yearFineCluster <- select(kmeansClusterData,Years, Fine)
  
  # Elbow method visualization function
  visualize_elbow <- function(data) {
    set.seed(59)
    wcss <- vector()
    for (i in 1:10)
      wcss[i] <- sum(kmeans(data, i)$withinss)
    plot(
      1:10,
      wcss,
      type = 'b',
      main = paste('Elbow method for finding clusters'),
      xlab = 'num clusters',
      ylab = 'wcss'
    )
  }
  
  # visualize the elbow for cluster
  visualize_elbow(yearFineCluster)
  
  # visualize K means
  kmeans <- kmeans(yearFineCluster,4, iter.max = 100, nstart = 10)
  yearFineCluster$cluster <- as.character(kmeans$cluster)
  p <-
    ggplot() + geom_point(
      data = yearFineCluster,
      size = 2 ,
      mapping = aes(x = Years,
                    y = Fine,
                    colour = cluster)
    )
  p + xlab("FISCAL YEARS: 2017 TO 2020") + ylab("FINE in USD")
  
  