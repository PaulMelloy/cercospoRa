#' Calculate infection rate
#'
#' @details
#'  Calculate the infection rate of *Cercospora berticola* in sugar beet leaves.
#'  This function is an attempt to copy the infection rate described by Racca and
#'  Jorg (2007).
#'
#' @param Tm numeric, Temperature
#' @param vpd numeric, Vapour pressure deficit
#' @param RH numeric, (optional) Relative humidity, when vpd is not available function
#'  will calculate internally
#'
#' @return numeric probability of infection between 0 and 1
#' @export
#' @references
#'     \insertRef{@racca_cercbet_2007}{cercosporaR}
#'
#' @examples
#' calc_inf_rate(25,0.2)
#'
#' temp <- seq(5,45, by = 1)
#' VPD <- seq(0,0.3, by = 0.01)
#'
#' i_rate <-
#'   outer(temp,VPD,function(xi,ji){
#'     calc_inf_rate(Tm = xi, vpd = ji)
#'      })
#' persp(temp,VPD,i_rate, theta = 160, ticktype = "detailed")
#'
calc_inf_rate <- function(Tm, vpd, RH = NA){
  if(is.na(RH) == FALSE){
    if(missing(vpd)) stop("No inputs detected for 'vpd' or 'RH' arguments. Please
                          Use one of these arguments for calculating the infection rate")
    vpd <- epiphytoolR::calc_vpd(RH = RH,
                                 Tm = Tm)
  }

  # vpd <- seq(0,1.5,0.01)
  # vpd <- 0.0

  vpd[vpd > 0.5] <- 0.5

  # Tm <- seq(0,50,0.02)

  b3 <- vpd/0.5
  b3 <- stats::pbeta(b3,2,6) * 10
  #plot(vpd,b3)

  # set minimum and maximum infectious temperatures
  b1 <- (Tm - b3 - 5)/40
  # get beta-function for temperature
  b1 <- stats::dbeta(b1,3+b3,3+b3)
  # find maximum value in sequence to normalise
  b1_max <- max(stats::dbeta(seq(0,50,0.01),3+b3,3+b3))
  # normalise to 0 - 1
  b1 <- b1/b1_max

  #checks
  #plot(Tm,b1)
  #abline(v = 34)


  b2 <- abs(vpd - 0.5)/0.5
  b2 <- stats::pbeta(b2,6,1.8)

  #plot(vpd,b2)

  return(b1*b2)

}
