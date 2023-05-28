# Exploratory_Data_Analysis_of_Rented_Bikes_in_Two_Cities

Rental bike sharing systems have been introduced in many cities worldwide to provide an accessible and sustainable mode of transport. These datasets contain the number of bikes rented at each hour in Seoul, South Korea (BikeSeoul.csv) and Washington, D.C., USA (BikeWashingtonDC.csv), together with corresponding meteorological and holiday data.

We will use these two cities as examples to explore the relationships between bike usage, weather, time of day and holidays. Understanding these relationships is important to eventually build appropriate statistical models to predict bike demand at various times of the year. These predictions can then be used, for example, to schedule bike maintenance.

The two datasets for the two cities contain the following variables:

BikeSeoul.csv:

Date - Day / Month / Year
Rented Bike count - Number of bikes rented in that hour
Hour - Hour of the day
Temperature - Air temperature in degree Celsius
Humidity - As a %
Windspeed - In m/s
Visibility - In 10m
 units (i.e. visibility = 2000, means a 20km
 visibility)
Dew point temperature - In degree Celsius
Solar radiation - In MJ/m2
Rainfall - In mm
Snowfall - In cm
Seasons - Winter, Spring, Summer, Autumn
Holiday - Holiday / No holiday
Functional Day - Yes / No bike count data collected

BikeWashingtonDC.csv:

instant - Unique record index
dteday - Day / Month / Year
season - Season (1: Winter, 2: Spring, 3: Summer, 4: Autumn)
yr - Year (0: 2011, 1:2012)
mnth - Month
hr - Hour
holiday - 0: no holiday, 1: holiday
weekday - Day of the week
workingday - 0: holiday / weekend, 1: otherwise
weathersit - Weather condition
clear, few clouds, partly cloudy
mist & cloudy, mist & broken clouds, mist & few clouds, mist
light snow, light rain & thunderstorm & scattered clouds, light rain & scattered clouds
Heavy rain & ice pellets & thunderstorm & mist, snow & fog
temp : Normalised air temperature in degree Celsius. The values are computed via t−tmintmax−tmin
 where tmin=−8∘C
 and tmax=+39∘C
atemp: Normalised feeling temperature in degree Celsius. The values are computed via t−tmintmax−tmin
, where tmin=−16∘C
 and tmax=+50∘C
hum: Normalised humidity. The values are divided by 100
windspeed: Normalised wind speed. The values are divided by 67km/h
 (max)
casual: Number of bikes rented by casual users
registered: Number of bikes rented by registered users
cnt: Total number of bikes rented in that hour (i.e. casual + registered)
