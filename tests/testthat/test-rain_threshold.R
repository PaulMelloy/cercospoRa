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
    time_zone = "UTC",data_check = FALSE)

  # test rain threshold
    weather_out <- rain_threshold(weather)
    expect_s3_class(weather_out,c("epiphy.weather", "data.table"))
    expect_true("rain_threshold" %in% colnames(weather_out))
    expect_equal(dim(weather_out), c(4393,17))
    expect_equal(dim(weather_out[is.na(rain_threshold) == FALSE,
                                 ][rain_threshold == TRUE,]), c(1750,17))

})
