# cercosporaR  

## RQs  

1) What is the ACTUAL spatial distribution (severity and location) of 
*Cercospora beticola* (raster maps, descriptive metrics (which?))?  
2) Does the cercosporaR model mimic the ACTUAL distribution?  
    - single vs multiple in-field environmental sensors  
3) Who do different RS (satellite/UAV) influence cercosporaR in its capability 
to mimic the ACTUAL spatial distribution?  

## Installation  

This package imports [`epiphytoolR`](https://github.com/PaulMelloy/epiphytoolR). 
To install this package run the following code in `R`
```
remotes::install_github(repo = "PaulMelloy/epiphytoolR", ref = "dev")
```
We recommend the development branch

Next install the package
```
remotes::install_github(repo = "PaulMelloy/cercosporaR")
```

## Getting started

### Format weather data  
```r
library(epiphytoolR)
# import example weather data
brisvegas <-
   system.file("extdata", "bris_weather_obs.csv", package = "epiphytoolR")
bris <- data.table::fread(brisvegas)

# Format times to POSIXct time with UTC timezone
bris[,aifstime_utc := as.POSIXct(aifstime_utc,tz = "UTC")]

# fill time gaps
bris <- fill_time_gaps(bris,"aifstime_utc")

# replace dashes with zeros
bris[rain_trace == "-", rain_trace := "0"]
bris[, rain_trace := as.numeric(rain_trace)]
# convert cumulative rainfall to periodic rainfall
bris[, rain := rain_trace - shift(rain_trace, type = "lead")][rain < 0, rain := rain_trace ]

# order the data by time
bris <- bris[order(aifstime_utc)]

#impute temperature
bris[is.na(air_temp), air_temp := impute_diurnal(aifstime_utc,
                                                 min_obs = 10,max_obs = 28,
                                                 max_hour = 14, min_hour = 5)]
# Assume NA rainfall entries = 0 rain
bris[is.na(rain), rain := 0]

# format weather so it is recognised by the model
# specify column names in data for each of the variables 
# see ?format_weather
bris_formated <- format_weather(
   w = bris,
   POSIXct_time = "aifstime_utc",
   time_zone = "UTC",
   temp = "air_temp",
   rh = "rel_hum",
   rain = "rain_trace",
   ws = "wind_spd_kmh",
   wd = "wind_dir_deg",
   station = "name",
   lon = "lon",
   lat = "lat",
   data_check = c("temp","rain")
)
```

### Calculate the proportional progress towards an epidemic  
```r
# susceptible cultivar
calc_epidemic_onset(c_closure = as.POSIXct("2023-06-01"),
                    weather = bris_formated,
                    cultivar_sus = 5)
# resistant cultivar                    
calc_epidemic_onset(c_closure = as.POSIXct("2023-06-01"),
                    weather = bris_formated,
                    cultivar_sus = 7)                    
                    
```
