# cercosporaR  

## RQs  

1) What is the ACTUAL spatial distribution (severity and location) of 
*Cercospora beticola* (raster maps, descriptive metrics (which?))?  
2) Does the cercosporaR model mimic the ACTUAL distribution?  
    - single vs multiple in-field environmental sensors  
3) Who do different RS (satellite/UAV) influence cercosporaR in its capability 
to mimic the ACTUAL spatial distribution?  
4) Can we improve on existing decision support models by Wolf **OR** Racca by using
LAI to determine canopy closure.  

## Approach  

 We will need to verify the models in the repository which were informed by publications
 by Wolf et. al () and Racca et. al (), have been coded correctly.  
 
 1. Develop a plant growth model using growing degree days to estimate Leaf Area 
 Index (LAI).  
   a. Controlling for row spacing and solar radiation may improve estimates.  
 2. Use a remote sensing approach to estimate LAI.  
   a. Also obtain NDVI as a possible co-variate.  
   b. Is it possible to quantify evapotranspiration to evaluate plant function and 
   biomass sequestration?  
 3. Compare estimates from 1. (agnostic plant growth model), with estimates from 2.
 (informed model).
   a. Can discrepancies be correlated to disease incidence or severity?  
   b. Will differences provide a probability of infection?  
 4. Multiply risk difference probability against published negative prognosis model
 risk to obtain a "posterior risk".  
 5. Compare "posterior risk" to remote sensing measurements of risk to validate 
 method detailed between 1 - 4.

### Research questions  

 1. Can we improve the negative prognosis models reported by Wolf and Verreet (2005)
 \insertCite{wolf_factors_2005}{cercosporaR} Racca and Jörg (2007) \insertCite{racca_cercbet_2007}{cercosporaR}?  
 2. Can we correlate a plant growth model with a plant growth signal (LAI)?  
 3. Can the difference between modeled plant growth and remote sensing measurements 
 indicate disease?  
 4. Can we correlate the risk estimate from Wolf and Verreet (2005)
 \insertCite{wolf_factors_2005}{cercosporaR} Racca and Jörg (2007) \insertCite{racca_cercbet_2007}{cercosporaR}
 with the difference between (1) and (2)?  
 
 Test these research questions on 
    - 20 m high accuracy drone data.  
    - 50m  drone data.  
    - 120m drone data.  
    - Spot8 satellite data.  
    - Sentinal 2 satellite data.  
    - Landsat satellite data.  

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
library(cercosporaR)
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
bris[, rain := rain_trace - data.table::shift(rain_trace, type = "lead")][rain < 0, rain := rain_trace ]

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
                    cultivar_sus = 3)
# resistant cultivar                    
calc_epidemic_onset(c_closure = as.POSIXct("2023-06-01"),
                    weather = bris_formated,
                    cultivar_sus = 5)                    
                    
```
**wolf_date**
In the susceptible cultivar the Wolf method reaches an epidemic on the "2023-07-04 UTC".
In the resistant cultivar progress to an epidemic is only 68.17%.  

**racca_date**
The Racca method ignores cultivar susceptibility and returns the incidence of leaves
infected as a percentage. 
When this percentage exceeds 5% the date for which 5% infection occurs is returned.  

`calc_epidemic_onset()` is a wrapper for `calc_DIV()` which returns a data.table 
detailing the daily contribution towards the "daily infection values" (Wolf and Verreet, 2005) or "daily leaf incidence" (Racca and Jörg, 2007).
For more detailed outputs call `calc_DIV()`

### Calculate daily infection values  
```r
calc_DIV(dat = bris_formated)
```
This produces a `data.table` detailing the daily infection value for each day using
the method described in Wolf and Verreet (2005) \insertCite{wolf_factors_2005}{cercosporaR} 
`DIV` and Racca and Jörg (2007) \insertCite{racca_cercbet_2007}{cercosporaR} (`DIV_racca`)


The method for Racca and Jörg (2007) is optimised for in crop weather data and 
Wolf and Verreet (2005) is optimised for weather data recorded at 2 meters proximal 
to the crop.  

## References  
\insertAllCited{}
