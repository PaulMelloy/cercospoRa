#' Calculate pseudomata maturity
#'
#' @param weather A `epiphy.weather` object (an extension of \CRANpkg{data.table})
#'  with weather data formated with the `epiphytoolR::format_weather()` function
#' @param lower_Tm_thres
#' @param rain_thresh
#'
#' @return
#' @export
#'
#' @examples
calc_pseudo_maturity <-
  function(weather,
           lower_Tm_thres = 10,
           rain_thresh = 2) {

    weather <- rain_threshold(weather, days = 2,
                              rain_mm = rain_thresh)

  }
