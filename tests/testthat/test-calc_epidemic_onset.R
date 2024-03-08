# load the weather data to be formatted
# import BOM data file
brisvegas <-
  system.file("extdata", "bris_weather_obs.csv", package = "epiphytoolR")
bris <- data.table::fread(brisvegas)
# Format times
bris[,aifstime_utc := as.POSIXct(aifstime_utc,tz = "UTC")]

# fill time gaps
bris <- epiphytoolR::fill_time_gaps(bris,"aifstime_utc")

# replace dashes with zeros
bris[rain_trace == "-", rain_trace := "0"]
bris[, rain_trace := as.numeric(rain_trace)]
# get rainfall for each time
bris[, rain := rain_trace - data.table::shift(rain_trace, type = "lead")][rain < 0, rain := rain_trace ]

# order the data by time
bris <- bris[order(aifstime_utc)]

#impute temperature
bris[is.na(air_temp),
     air_temp := epiphytoolR::impute_diurnal(
       aifstime_utc,
       min_obs = 10,
       max_obs = 28,
       max_hour = 14,
       min_hour = 5
     )]
bris[is.na(rain), rain := 0]

test_that("Relative humidity formats",{

  bris_formated <- epiphytoolR::format_weather(
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
      data_check = c("temp","rain"),
      print_warnings = FALSE,
   )

   # fill NAs with the same relative humidity as the previous day
   bris_formated[,rh := fifelse(is.na(rh),shift(rh,n=24,type = "lag"),
                               rh)]

   expect_false(any(is.na(bris_formated$rh)))
})

test_that("epidemic onset produces expected outcome", {
  bris_formated <- epiphytoolR::format_weather(
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
    data_check = c("temp","rain"),
    print_warnings = FALSE,
  )
  bris_formated[,rh := fifelse(is.na(rh),shift(rh,n=24,type = "lag"),
                               rh)]

  # susceptible cultivar
  sus_out <- calc_epidemic_onset(c_closure = as.POSIXct("2023-06-01"),
                      weather = bris_formated,
                      cultivar_sus = 3)
  expect_type(sus_out,"double")
  expect_equal(sus_out, as.POSIXct("2023-07-04",tz = "UTC"))

  # resistant cultivar
  res_out <- calc_epidemic_onset(c_closure = as.POSIXct("2023-06-01"),
                      weather = bris_formated,
                      cultivar_sus = 5)
  expect_type(res_out,"double")
  expect_equal(res_out, 0.7017544,tolerance = 0.0000001)

})

test_that("different start dates provide different epidemic dates",{
  w_dat <- data.table(weathr)
  # Use POSIXct formatted time.
  w_dat[,Time := as.POSIXct(paste0(Datum, " ",Stunde,":00"),tz = "UTC")]
  w_dat[, c("lon","lat") := list(9.916,51.41866)]
  # weather is hourly and will error if we don't specify a wd standard deviation
  w_dat[, wd_std := 20]
  # set NA wind direction values to 20 degrees. Wind is not important for this model
  w_dat[,WR200 := runif(.N,min = 0,359)]
  # remove all data after September as it contains missing data
  w_dat <- w_dat[Datum < as.POSIXct("2022-10-01")]
  # set NA wind speed values to zero
  w_dat[is.na(WG200),WG200 := 0]


  w_dat <- epiphytoolR::format_weather(w_dat,
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

  for(i in 1:30){
    if(i == 1){
      out2 <- vector(mode = "character")
    }
    out <- calc_epidemic_onset(start = as.POSIXct("2022-04-25",tz = "UTC"),
                               end = as.POSIXct("2022-09-30",tz = "UTC"),
                               c_closure = as.POSIXct("2022-05-01")+(i*3*86400), # 86400 is the number of seconds in a day
                               weather = w_dat,
                               cultivar_sus = 3)

    out2 <- c(out2,as.character(out))

  }
  # cat(out2,sep = "\", \"")
  expect_equal(out2, c("2022-06-11", "2022-06-11", "2022-06-12", "2022-06-13",
                       "2022-06-15", "2022-06-20", "2022-06-25", "2022-06-27",
                       "2022-06-29", "2022-06-30", "2022-07-01", "2022-07-02",
                       "2022-07-08", "2022-07-12", "2022-07-19", "2022-07-21",
                       "2022-07-22", "2022-07-23", "2022-07-26", "2022-07-30",
                       "2022-07-30", "2022-07-31", "2022-08-01", "2022-08-02",
                       "2022-08-05", "2022-08-05", "2022-08-05", "2022-08-15",
                       "2022-08-17", "2022-08-18"))
})

