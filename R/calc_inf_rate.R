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
  b3 <- pbeta(b3,3,3)*220

  # set minimum and maximum infectious temperatures
  b1 <- (Tm - 5)/40
  # get beta-function for temperature
  b1 <- dbeta(b1,5,5,ncp = b3)
  # find maximum value in sequence to normalise
  b1_max <- max(dbeta(seq(0,50,0.01),5,5,b3))
  # normalise to 0 - 1
  b1 <- b1/b1_max

  #checks
  #plot(Tm,b1)
  #abline(v = 34)


  b2 <- abs(vpd - 0.5)/0.5
  b2 <- pbeta(b2,6,3)

  plot(vpd,b2)

  return(b1*b2)

}
