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

# Inspect raw weather station data
head(cercospoRa::weathr)
```

`weathr` is a data.table containing weather data recorded at a sugarbeat field 
trial observing the spread and severity of *C. beticola*.

```r
# make a copy of the data
wthr <- data.table(weathr)

# Format times to POSIXct time with UTC timezone
wthr[,Time := as.POSIXct(paste0(Datum, " ",Stunde,":00"),tz = "UTC")]

# Nominate Latitude and Longitude location of the weather station. 
# While not needed in cercospoRa some plant disease models will use location to 
#  decide the closest weather station to pull weather from
wthr[, c("lon","lat") := list(9.916,51.41866)]

# weather is hourly and will error if we don't specify a standard deviation of 
#  weather direction. This is intentional to force the user to decide how variable
#  the wind direction data could be.
wthr[, wd_std := 20]

# remove all data after September as it contains missing data
wthr <- wthr[Datum < as.POSIXct("2022-10-01")]

# set NA wind speed values to zero
wthr[is.na(WG200),WG200 := 0]

# set NA wind direction values to 20 degrees. Wind is not important for this model
wthr[is.na(WR200),WR200 := 20]

# format_weather() is a function from epiphytoolR that formats weather data to 
#  hourly and checks for missing data or any issues that may cause downstream faults
#  in the model.
wthr <- 
  epiphytoolR::format_weather(wthr,
                              POSIXct_time = "Time",
                              time_zone = "UTC",
                              temp = "T200",
                              rain = "N100",
                              rh = "F200",
                              wd = "WR200",
                              ws = "WG200",
                              station = "Station",
                              lon = "lon",
                              lat = "lat",
                              wd_sd = "wd_std",
                              data_check = FALSE # this stops the function from checking for faults
                         )
```

### Calculate the proportional progress towards an epidemic  
```r
# susceptible cultivar
calc_epidemic_onset(c_closure = as.POSIXct("2022-07-01"),
                    weather = wthr,
                    cultivar_sus = 3)
# resistant cultivar                    
calc_epidemic_onset(c_closure = as.POSIXct("2022-07-01"),
                    weather = wthr,
                    cultivar_sus = 5)                    
                    
```
This returns a POSIXct date for the onset of an epidemic for the susceptible and
more resistant cultivar.
If the input weather data does not provide a window where a epidemic onset date 
is met, the proportional progress towards an epidemic is returned.

`calc_epidemic_onset()` is a wrapper for `calc_DIV()` which returns a data.table 
detailing the daily contribution towards the "daily infection values" (Wolf and Verreet, 2005). 
For more detailed output of daily infection values call `calc_DIV()`

### Calculate daily infection values  
```r
calc_DIV(dat = wthr)
```
This produces a `data.table` detailing the daily infection value for each day using
the method described in Wolf and Verreet (2005) 

**Note:** Missing humidity values do not prevent the model from running and these
days are assumed to not progress the model. The Racca and Jörg model returns `NA` values 
and the Wolf model returns `0` as seen in the `calc_DIV(dat = bris_formated)` function 
output.  

## References  
Wolf, P. F., & Verreet, J. A. (2005). A model for simulating the infection of sugar beet leaves by Cercospora beticola. Plant Pathology, 54(3), 333-343.
