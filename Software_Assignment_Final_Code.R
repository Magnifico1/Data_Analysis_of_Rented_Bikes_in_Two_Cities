library(tidyverse)
library(lubridate)
library(ggplot2)

#DATA WRANGLING

##Read in Seoul dataset
BikeSeoul<-read.csv("BikeSeoul.csv")
BikeSeoul <- 
  BikeSeoul %>% 
  
##Remove unused columns 
  select(-c(Visibility..10m., Dew.point.temperature.C., 
            Solar.Radiation..MJ.m2., Rainfall.mm., Snowfall..cm. )) %>%
  
##Filter out observations for which no bike count data was collected; remove functioning day column
  filter(Functioning.Day=="Yes") %>%
  select(-Functioning.Day) %>% 

##Change the name of the columns 
  rename(c("Count"=Rented.Bike.Count, "Temperature"=Temperature.C., 
           "Humidity"=Humidity..., "WindSpeed"=Wind.speed..m.s., 
           "Season"=Seasons)) %>%
  
##Convert Date to a date object
  mutate(Date=as.Date(Date,format=c("%d/%m/%Y"))) %>% 

##Create new variable FullDate
  mutate(FullDate=make_datetime(year(Date),month(Date),day(Date),
                                    hour=Hour,min=0,sec=0)) %>%
  
##Change the factor levels of Holiday to Yes / No
  mutate(Holiday=factor(Holiday,levels=c("Holiday","No Holiday"),
                        labels=c("Yes","No"))) %>%
  
##Change the order of Season factor levels 
  mutate(Season=factor(Season,levels=c("Spring", "Summer", "Autumn", "Winter"),
                       labels=c("Spring", "Summer", "Autumn", "Winter")))
  
##Read in DC dataset
BikeDC<-read.csv("BikeWashingtonDC.csv")
BikeDC<- 
  BikeDC %>% 
  
##Remove unused columns
  select(-c(instant, yr, mnth, weekday, workingday, 
            weathersit, atemp, casual, registered)) %>%
  
##Change names of columns to match the Seoul dataset's
  rename(c("Date"=dteday, "Count"=cnt, "Temperature"=temp, 
           "Humidity"=hum, "WindSpeed"=windspeed, 
           "Season"=season, "Holiday"=holiday, "Hour"=hr)) %>% 
  
##Convert Humidity to %, Temperature to C,WindSpeed to m/s
  mutate(Humidity=Humidity*100, Temperature=Temperature*(39--8)-8, 
         WindSpeed=WindSpeed*67*(1000/(60^2))) %>% 
  
##Change the factor levels of Season to match Seoul dataset's
  mutate(Season=factor(Season,levels=c(2,3,4,1),
                       labels=c("Spring", "Summer", "Autumn", "Winter"))) %>%
  
##Change the factor levels of Holiday to Yes / No
  mutate(Holiday=factor(Holiday,levels=c(1,0), labels=c("Yes","No"))) %>%
  
##Convert Date to a date object
  mutate(Date=as.Date(Date,format=c("%Y-%m-%d"))) %>% 
  
##Create FullDate variable
  mutate(FullDate=make_datetime(year(Date),month(Date),day(Date),
                                    hour=Hour,min=0,sec=0))

-------------------------------------------------------------------------------
#DATA VISUALISATION

##Air temperature over the course of a year
ggplot(BikeSeoul[year(BikeSeoul$Date)==2018,])+
  geom_line(aes(Date,Temperature))+
  stat_smooth(aes(Date,Temperature))+
  ggtitle("Seoul Temperature Variation in 2018")+
  theme(plot.title = element_text(hjust = 0.5))+
  ylab("Temperature (°C)")+
  scale_y_continuous(breaks=c(-20,-10,0,10,20,30,40))

ggplot(BikeDC[year(BikeDC$Date)==2012,])+
  geom_line(aes(Date,Temperature))+
  stat_smooth(aes(Date,Temperature))+
  ggtitle("Washington DC Temperature Variation in 2012")+
  theme(plot.title = element_text(hjust = 0.5))+
  ylab("Temperature (°C)")+
  scale_y_continuous(breaks=c(-10,0,10,20,30,40))+ylim(-10,40)

##Effect of Season on average number of rented bikes
ggplot(BikeSeoul)+geom_boxplot(aes(Count,colour=Season))+
  scale_color_manual(values=c("Green3", "Red","Purple","cyan3"))+
  coord_flip()+xlab("Number of Rented Bikes")+
  ggtitle("Seoul Bike Rental Demand by Season")+
  theme(plot.title = element_text(hjust = 0.5),axis.text.x=element_blank())+
  ylab("Season")

ggplot(BikeDC)+geom_boxplot(aes(Count,colour=Season))+
  scale_color_manual(values=c("Green3", "Red","Purple", "cyan3"))+
  coord_flip()+xlab("Number of Rented Bikes")+
  ggtitle("DC Bike Demand by Season")+
  theme(plot.title = element_text(hjust = 0.5),axis.text.x=element_blank())+
  ylab("Season")

##Effect of holidays on bike demand
ggplot(BikeSeoul)+geom_boxplot(aes(Holiday,Count))+
  ylab("Number of Rented Bikes")+
  ggtitle("Seoul Bike Rental Demand by Holiday")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(BikeDC)+geom_boxplot(aes(Holiday,Count))+
  ylab("Number of Rented Bikes")+
  ggtitle("DC Bike Rental Demand by Holiday")+
  theme(plot.title = element_text(hjust = 0.5))

##Effect of time of day on bike demand
ggplot(BikeSeoul)+geom_point(aes(Hour,Count,color=Hour))+
  xlab("Hour of Day")+ylab("Number of Rented Bikes")+
  ggtitle("Seoul Bike Rental Demand by Time of Day")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(BikeDC)+geom_point(aes(Hour,Count,color=Hour))+
  xlab("Hour of Day")+ylab("Number of Rented Bikes")+
  ggtitle("DC Bike Rental Demand by Time of Day")+
  theme(plot.title = element_text(hjust = 0.5))


##Association between bike demand and three meteorological variables
ggplot(BikeSeoul)+geom_point(aes(Temperature,Count,colour=Temperature))+
  geom_histogram(aes(Temperature),bins=35,alpha=0.5)+
  scale_color_gradient2(midpoint=mean(BikeSeoul$Temperature),
                        low="blue",mid="yellow3",high="red1",space ="Lab")+
  xlab("Temperature (°C)")+ylab("Number of Rented Bikes")+
  ggtitle("Seoul Bike Demand by Temperature")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(BikeSeoul)+geom_point(aes(WindSpeed,Count,colour=WindSpeed))+
  geom_histogram(aes(WindSpeed),bins=35,fill="red",alpha=0.5)+
  xlab("Windspeed (m/s)")+
  ylab("Number of Rented Bikes")+
  ggtitle("Seoul Bike Demand by Windspeed")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(BikeSeoul)+geom_point(aes(Humidity,Count,colour=Humidity))+
  geom_histogram(aes(Humidity),bins=25)+
  xlab("Humidity (%)")+ylab("Number of Rented Bikes")+
  ggtitle("Seoul Bike Demand by Humidity")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_color_gradient(low="grey", high="blue")

ggplot(BikeDC)+geom_point(aes(Temperature,Count,colour=Temperature))+
  geom_histogram(aes(Temperature),bins=65,alpha=0.5)+
  scale_color_gradient2(midpoint=mean(BikeSeoul$Temperature),
                        low="blue",mid="yellow3",high="red1",space ="Lab")+
  xlab("Temperature (°C)")+ylab("Number of Rented Bikes")+
  ggtitle("DC Bike Demand by Temperature")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(BikeDC)+geom_point(aes(WindSpeed,Count,colour=WindSpeed))+
  xlab("Windspeed (m/s)")+
  ylab("Number of Rented Bikes")+
  ggtitle("DC Bike Demand by Windspeed")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(BikeDC)+geom_point(aes(Humidity,Count,colour=Humidity))+
  xlab("Humidity (%)")+ylab("Number of Rented Bikes")+
  ggtitle("DC Bike Demand by Humidity")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_color_gradient(low="grey", high="blue")

-------------------------------------------------------------------------------
#STATISTICAL MODELLING

##Fit linear models with log count as outcome
Seoulfit<-lm(log(Count)~Season+Temperature+Humidity+WindSpeed,data=BikeSeoul)
summary(Seoulfit)

DCfit<-lm(log(Count)~Season+Temperature+Humidity+WindSpeed,data=BikeDC)
summary(DCfit)

##Display 97% confidence intervals for the estimated regression coefficients
confint(Seoulfit,level=.97)
confint(DCfit,level=.97)

##Testing model assumptions
plot(fitted(Seoulfit), log(BikeSeoul$Count))
plot(Seoulfit)
plot(fitted(DCfit), log(BikeDC$Count))
plot(DCfit)

##Predicted numbers of rented bikes
dfpred <- data.frame(Temperature = 0, WindSpeed = .5,
                     Humidity = 20, Season="Winter")
exp(predict(Seoulfit, newdata = dfpred,level=.9,interval='prediction'))
exp(predict(DCfit, newdata = dfpred,level=.9,interval='prediction'))
