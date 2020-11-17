#
# Authors = (Omkar Sarde, Sharwari Salunkhe)
# This file to create an analysis of average number of violations during different time intervals across a day 
#

library(lubridate)
library(RMySQL)
library(ggplot2)
library(cowplot)
# Get violation times in last 3 years i.e 2017,2018,2019

violationAtTimes <- sqlQuery("select violationTime, count(summonsId)
from ParkingViolations.parkingviolation
where YEAR(STR_TO_DATE(issueDate,'%m/%d/%Y')) >= '2017' and YEAR(STR_TO_DATE(issueDate,'%m/%d/%Y')) <= '2019' 
group by violationTime;")

violationAtTimesFormat <- violationAtTimes %>%
filter(`count(summonsId)` > 300)

violationAtTimesFormat$Hours <- substr(violationAtTimesFormat$violationTime,1,2)
violationAtTimesFormat$AP <-  substr(violationAtTimesFormat$violationTime,5,5)
violationAtTimesGrouped <- aggregate(violationAtTimesFormat$`count(summonsId)`
          , by=list(violationAtTimesFormat$Hours,violationAtTimesFormat$AP), FUN=sum) 
violationAtTimesGrouped$combined <- paste(violationAtTimesGrouped$Group.1 , violationAtTimesGrouped$Group.2,'M')
violationAtTimesGrouped$x <- round(violationAtTimesGrouped$x / 1095)
violationAtTimesGrouped <- violationAtTimesGrouped %>%
  arrange(`Group.2`,`Group.1`)
violationAtTimesGroupedA <- violationAtTimesGrouped  %>% filter(`Group.2` == 'A')
violationAtTimesGroupedP <- violationAtTimesGrouped  %>% filter(`Group.2` == 'P')

xlabelsA = c('01 AM','02 AM','03 AM','04 AM','05 AM','06 AM','07 AM','08 AM','09 AM','10 AM','11 AM','12 AM')
xlabelsB = c('01 PM','02 PM','03 PM','04 PM','05 PM','06 PM','07 PM','08 PM','09 PM','10 PM','11 PM','12 PM')

 p1 <- ggplot(violationAtTimesGroupedA) +
         # add bar for each discipline colored by gender
         geom_bar(aes(x=`combined`,  y=`x`),
                  stat = "identity", position = "dodge") +
scale_y_continuous("", expand = c(0, 0),labels = scales::comma) +
  scale_x_discrete("",labels=xlabelsA) +
          # scale_fill_discrete("Part of the day",labels=c("Morning","Afternoon"),)+
           theme_classic(base_size = 10) +
          # ggtitle("Average number of Parking Violation Tickets issued during each hour")+
           # rotate x-axis and remove superfluous axis elements
           theme(
           #  legend.position = "top",
           #  legend.title=element_blank(),
             axis.line = element_blank(),
             axis.ticks.x = element_blank(),
             axis.text=element_text(size=20),
             axis.title=element_text(size=25,face="bold")
             ,plot.margin = unit(c(1,1,1,1),"cm")) 
 
p2 <- ggplot(violationAtTimesGroupedP) +
   # add bar for each discipline colored by gender
   geom_bar(aes(x=`combined`,  y=`x`),
            stat = "identity", position = "dodge") +
   scale_y_continuous("",expand = c(0, 0),labels = scales::comma) +
   scale_x_discrete("",labels=xlabelsB) +
   # scale_fill_discrete("Part of the day",labels=c("Morning","Afternoon"),)+
   theme_classic(base_size = 10) +
  
   # ggtitle("Average number of Parking Violation Tickets issued during each hour")+
   # rotate x-axis and remove superfluous axis elements
   theme(
     #  legend.position = "top",
     #  legend.title=element_blank(),
     axis.line = element_blank(),
     axis.ticks.x = element_blank(),
     axis.text=element_text(size=20)
     ,plot.margin = unit(c(1,1,1,1),"cm"))  


plot_grid(p1,NULL, p2,NULL, labels=c("", ""), ncol = 2)+ #perhaps reduce this for a bit more space
  draw_label("Time Durations", x=0.25, y=  0, vjust=-0.5, angle= 0, size=25) +
  draw_label("Average Number of Parking Violations", x=  0, y=0.5, vjust= 1.5, angle=90,size=25)
  