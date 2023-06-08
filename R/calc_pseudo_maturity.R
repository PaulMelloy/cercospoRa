#' Calculate pseudomata maturity
#'
#' @param weather A `epiphy.weather` object (an extension of \CRANpkg{data.table})
#'  with weather data formated with the `epiphytoolR::format_weather()` function
#' @param lower_Tm_thres numeric, lower temperature threshold, which pseduomata don't
#'  mature
#' @param rain_thresh numeric, minimum rainfall required to initiate pseudomata
#'  maturity
#'
#' @return
#' @export
#'
#' @examples
#' scaddan <-
#'    system.file("extdata", "scaddan_weather.csv",package = "epiphytoolR")
#' weather_dat <- read.csv(scaddan)
#' weather_dat$Local.Time <-
#'    as.POSIXct(weather_dat$Local.Time, format = "%Y-%m-%d %H:%M:%S",
#'               tz = "UTC")
#'
#' weather <- epiphytoolR::format_weather(
#'    w = weather_dat,
#'    POSIXct_time = "Local.Time",
#'    ws = "meanWindSpeeds",
#'    wd_sd = "stdDevWindDirections",
#'    rain = "Rainfall",
#'    temp = "Temperature",
#'    wd = "meanWindDirections",
#'    lon = "Station.Longitude",
#'    lat = "Station.Latitude",
#'    station = "StationID",
#'    time_zone = "UTC"
#' )
#'
#' calc_pseudo_maturity(weather)
#'
calc_pseudo_maturity <-
  function(weather,
           lower_Tm_thres = 10,
           rain_thresh = 2) {

    weather <- rain_threshold(weather, hours = 48,
                              rain_mm = rain_thresh)

    return(sum(weather$rain_threshold, na.rm = TRUE))

  }
