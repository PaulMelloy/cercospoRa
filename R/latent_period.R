#' Calculate Cercospora latent period
#'
#' @param Tm numeric, Average temperature in degrees Celsius for a hour of the day
#' @param ref character, method for calculating latent period. Default is `"wolf"`
#' also available `"jarroudi"`. See references for where formulas were used
#'
#' @return numeric, Latent period for a given hour. `ref = "jarroudi"` returns
#'  latent period in days.
#' @references \insertRef{wolf_factors_2005}{cercosporaR}; equation 4
#'  \insertRef{el_jarroudi_weather-based_2021}{cercosporaR}; equation 1
#'
#'
latent_period <- function(Tm, ref = "wolf"){
  if(ref = "wolf"){
  lp <-
    sapply(Tm, function(Tm) {
      7 + 26 * exp(-0.35 * (Tm - 10))
    })
  }
  if(ref = "jarroudi"){
    lp <-
      1/(0.00442 * Tm - 0.0238)
  }

  return(lp)
}



#' Get temperature index
#'
#' Temperature index is a proportional representation of the latent period.
#' Temperatures at or above the optimum temperature for the disease cycle will
#' yield 1 and the lower the temperature the infinitely longer the latent period.
#'
#' For equations and original documentation, see \insertCite{wolf_factors_2005}{cercosporaR}
#'  and \insertCite{wolf_zum_2001}{cercosporaR}
#'
#' @param Tm numeric, temperature for any given hour
#' @param opt_Tm numeric, the lowest temperature optimum at which all temperatures
#'  above will have the same (fastest) latent period.
#'
#' @return numeric, proportion representing the speed of the latent period in relation
#'  to the temperature optimum
#' @importFrom Rdpack reprompt
#' @references
#'    \insertAllCited{}
temperature_index <- function(Tm, opt_Tm = 21){

  out <- sapply(Tm,FUN = function(Tm1){
    tm_ind <- latent_period(opt_Tm)/latent_period(Tm1)
    if(tm_ind > 1) tm_ind <- 1
    if(tm_ind < 0) tm_ind <- 0

    return(tm_ind)
  })
  return(out)
}


#' Relative humidity index
#'
#' Confirms the humidity threshold has been met by returning a 1 or not met by
#'  returning a 0. See \insertCite{wolf_factors_2005}{cercosporaR}
#'
#' @param RH numeric, relative humidity as a percentage
#' @param rh_thresh numeric, humidity threshold where if humidity is below this
#'  no progress towards the latent period is made.
#' @param rain numeric, rainfall in millimetres
#'
#' @return numeric, either a 1 or 0
#' @noRd
#' @references
#'    \insertAllCited{}
moisture_index <- function(RH, rain = 0, rh_thresh = 70){
  dat2 <- data.table::data.table(RH = RH,
                                 rain = rain)
  rh_ind <- apply(dat2, 1, function(d2) {
    rain <- d2["rain"]
    RH <- d2["RH"]

    if (is.na(rain)){
      rain <- 0}

    # need to scale the threshold for more realistic values
    scale_rh_thresh <- (exp((140-rh_thresh)/21.7))/25

    rh_ind <- data.table::fcase(rain >= 0.1, 1/(1+exp((88-RH)/(2.5 * scale_rh_thresh))),
                                RH > rh_thresh, 1/(1+exp((88-RH)/(2.5 * scale_rh_thresh))),
                                default =  0)

    return(rh_ind)
  })
  return(rh_ind)
}

