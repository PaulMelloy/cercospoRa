#' Calculate sporulation rate
#'
#' @details
#'  Calculate the sporulation rate of *Cercospora berticola*.
#'  This function is an attempt to copy the sporulation rate described by
#'  \insertCite{racca_cercbet_2007}{cercosporaR}.
#'  The optimum conditions for sporulation is relative humidity above 95% and
#'  temperatures between 23$^o$C and 28$^o$C
#'
#' @param Tm numeric, Temperature
#' @param RH numeric, Relative humidity, when vpd is not available function
#'  will calculate internally
#'
#' @return numeric probability of infection between 0 and 1
#' @export
#' @references
#'     \insertRef{racca_cercbet_2007}{cercosporaR}
#'
#' @examples
#' calc_spore_rate(25,0.2)
#'
#' temp <- seq(5,35, by = 1)
#' RH <- seq(90,100, by = 0.3)
#'
#' s_rate <-
#'   outer(temp,RH,function(xi,ji){
#'     calc_spore_rate(Tm = xi, RH = ji)
#'      })
#' persp(temp,RH,s_rate, theta = 315, phi = 20, ticktype = "detailed")
#'
calc_spore_rate <- function(Tm, RH) {
  # if lengths are the same of Tm and RH apply over the vectors
  if (length(Tm) == length(RH)) {

    # create data.frame with values
    Dt <- data.frame(Tm = Tm,
                     RH = RH)
    # apply over each row
    SR_out <- apply(Dt, 1, function(d) {
      out <- calc_SR(Tm = as.numeric(d["Tm"]),
                     RH = as.numeric(d["RH"]))
      return(out)

    })
  } else{
    # do single way
    SR_out <- calc_SR(Tm = Tm, RH = RH)
  }
  return(SR_out)
}


#' Internal: Calculate sporulation rate
#'
#' This function is wrapped by `calc_spore_rate``
#'
#' @param Tm See `calc_spore_rate()` documentation
#' @param RH See `calc_spore_rate()` documentation
#'
#' @return See `calc_spore_rate()` documentation
#' @noRd
calc_SR <- function(Tm, RH){
  # RH <- seq(100,90,-0.2)
  # RH <- 100

  RH[RH < 92] <- 92

  # Tm <- seq(0,50,0.02)

  # set minimum and maximum infectious temperatures
  b1 <- (Tm - 5)/30
  # get beta-function for temperature
  b1 <- stats::dbeta(b1,5,3,0.7)
  # find maximum value in sequence to normalise
  b1_max <- max(stats::dbeta(seq(0,50,0.01),1.8,2,7))
  # normalise to 0 - 1
  b1 <- b1/b1_max

  #checks
  #plot(Tm,b1)
  #abline(v = 34)


  b2 <- abs(RH - 92)/8
  b2 <- stats::pbeta(b2,5,3.5)

    return(b1*b2)

}
