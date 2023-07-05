#' Calculate Cercospora latent period
#'
#' @param Tm numeric, Average temperature in degrees Celsius for a hour of the day
#'
#' @return numeric, Latent period for a given hour
#' @references \insertRef{@wolf_factors_2005}{cercosporaR} equation 4 (Wolf 2001)
#'
#' @examples
#' latent_period(25)
latent_period <- function(Tm){
  lp <- 7 + 26 * exp(-0.35*(Tm - 10))
  return(lp)
}
