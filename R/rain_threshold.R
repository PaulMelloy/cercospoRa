#' Evaluate rainfall threshold
#'
#' @param w data.table
#' @param hours integer, time period in days for which the rainfall threshold is
#'   calculated
#' @param rain_mm numeric, total rainfall needed in time period (`days`) for rainfall
#'   threshold to be met.
#'
#' @return A `epiphy.weather` object (an extension of \CRANpkg{data.table}) with
#'   an additional logical column `rain_threshold`.  Read more at `?(format_weather)`
#'   The added `rain_threshold` indicates whether the rainfall threshold was met.
#' @import data.table
#' @examples
#' scaddan <-
#'    system.file("extdata", "scaddan_weather.csv",package = "epiphytoolR")
#' weather_dat <- read.csv(scaddan)
#' weather_dat$Local.Time <-
#'    as.POSIXct(weather_dat$Local.Time, format = "%Y-%m-%d %H:%M:%S",
#'               tz = "UTC")
#'
#' weather <-
#'  epiphytoolR::format_weather(
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
#' #weather_out <- rain_threshold(weather)
#' #weather_out
rain_threshold <- function(w,
                           hours = 48,
                           rain_mm = 2) {
  # initialise global def for data.table variables
  rain <- NULL

  data.table::setDT(w)

  # for some reason it won't recognicse := as a function
  # w[, rain_threshold := .(data.table::frollsum(rain,hours,
  #                                              align = "right",
  #                                              na.rm = TRUE) >= rain_mm)]
  w$rain_threshold <- data.table::frollsum(w$rain,hours,
                                           align = "right",
                                           na.rm = TRUE) >= rain_mm
  return(w)
}
