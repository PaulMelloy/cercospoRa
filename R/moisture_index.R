#' Relative humidity index
#'
#' Confirms the humidity threshold has been met by returning a 1 or not met by
#'  returning a 0. See \insertCite{wolf_factors_2005}{cercospoRa}
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
