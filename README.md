# cercospoRa  

`cercospoRa` is a mechanistic epidemiological model for estimating epidemics of 
_Cercospora beticola_ in sugar beat farms, available as an R package.  

## Installation  

This package imports [`epiphytoolR`](https://github.com/PaulMelloy/epiphytoolR). 
To install this package run the following code in `R`.  
```
remotes::install_github(repo = "PaulMelloy/epiphytoolR")
```
Next install the package  

```
remotes::install_github(repo = "PaulMelloy/cercospoRa")
```

## Getting started

### Format weather data  
```r
library(epiphytoolR)
library(cercospoRa)

# Format weather data
head(cercospoRa::weathr)

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

# format weather data so it is recognised by the model
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
*Warnings are produced here due to missing wind direction data* 
*This model does not need wind direction so this is not problematic for how it runs*  

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
*There are some warnings here due to missing humidity data, see below for more explaination*

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
the method described in Wolf and Verreet (2005) \insertCite{wolf_factors_2005}{cercospoRa} 
`DIV` and Racca and Jörg (2007) \insertCite{racca_cercbet_2007}{cercospoRa} (`DIV_racca`)

**Note:** Missing humidity values do not prevent the model from running and these
days are assumed to not progress the model. The Racca and Jörg model returns `NA` values 
and the Wolf model returns `0` as seen in the `calc_DIV(dat = bris_formated)` function 
output.  

The method for Racca and Jörg (2007) is optimised for in crop weather data and 
Wolf and Verreet (2005) is optimised for weather data recorded at 2 meters proximal 
to the crop.  

## References  
\insertAllCited{}
