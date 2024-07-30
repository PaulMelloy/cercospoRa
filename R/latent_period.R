#' Calculate Cercospora latent period
#'
#' @details Calculates the latent period for *Cercospora beticola* infections on
#' sugar beet. Note the published formula in \insertCite{wolf_factors_2005}{cercospoRa}
#' contains an error in the exponent. e(0.35 x (Tm - 10)) should be
#' e(-0.35 x (Tm - 10)). See issue #22 on github for additional information.
#'
#' @param Tm numeric, Average temperature in degrees Celsius for a hour of the day
#' @param ref character, method for calculating latent period. Default is `"wolf"`
#' also available `"jarroudi"`. See references for where formulas were used
#'
#' @return numeric, Latent period for a given hour. `ref = "jarroudi"` returns
#'  latent period in days.
#' @references \insertRef{wolf_factors_2005}{cercospoRa}; equation 4
#'  \insertRef{el_jarroudi_weather-based_2021}{cercospoRa}; equation 1
latent_period <- function(Tm, ref = "wolf"){
  if(ref == "wolf"){
  lp <-
    sapply(Tm, function(Tm) {
      7 + 26 * exp(-0.35 * (Tm - 10))
    })
  }
  if(ref == "jarroudi"){
    lp <-
      sapply(Tm,function(Tm){
      lper <-
        1/(0.00442 * Tm - 0.0238)
      if(lper < 0) lper <- 0
      return(lper)
    })
  }

  return(lp)
}
