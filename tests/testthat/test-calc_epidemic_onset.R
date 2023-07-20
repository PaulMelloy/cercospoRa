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

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
