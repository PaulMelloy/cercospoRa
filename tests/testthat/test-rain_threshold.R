test_that("example works", {
  scaddan <-
      system.file("extdata", "scaddan_weather.csv",package = "epiphytoolR")
  weather_dat <- read.csv(scaddan)
  weather_dat$Local.Time <-
    as.POSIXct(weather_dat$Local.Time, format = "%Y-%m-%d %H:%M:%S",
               tz = "UTC")

  weather <- epiphytoolR::format_weather(
    w = weather_dat,
    POSIXct_time = "Local.Time",
    ws = "meanWindSpeeds",
    wd_sd = "stdDevWindDirections",
    rain = "Rainfall",
    temp = "Temperature",
    wd = "meanWindDirections",
    lon = "Station.Longitude",
    lat = "Station.Latitude",
    station = "StationID",
    time_zone = "UTC")

  # test rain threshold
   # weather_out <- rain_threshold(weather)

})
