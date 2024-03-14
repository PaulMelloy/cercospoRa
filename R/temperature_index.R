#' Get temperature index
#'
#' Temperature index is a proportional representation of the latent period.
#' Temperatures at or above the optimum temperature for the disease cycle will
#' yield 1 and the lower the temperature the infinitely longer the latent period.
#'
#' For equations and original documentation, see \insertCite{wolf_factors_2005}{cercospoRa}
#'  and \insertCite{wolf_zum_2001}{cercospoRa}
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

  out <- sapply(Tm,FUN = function(Tm_1){
    tm_ind <- latent_period(opt_Tm)/latent_period(Tm_1)
    if(tm_ind > 1) tm_ind <- 1
    if(tm_ind < 0) tm_ind <- 0

    return(tm_ind)
  })
  return(out)
}
