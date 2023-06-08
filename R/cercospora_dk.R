#' Dispersal kernal for Cercospora berticola
#'
#' @param x lateral coordinates of the location to evaluate the dispersal kernel
#' @param y longitude of coordinates of the location to evaluate the dispersal kernel
#' @param sigma the standard deviation of the Gaussian component
#' @param lambda parameter controlling the exponential decay component
#'
#' @return numeric estimating the distance of the spore travel
#' @export
#'
#' @examples
cercospora_dk <- function(x, y, sigma, lambda) {
  # x and y are the coordinates of the location to evaluate the dispersal kernel
  # sigma is the standard deviation of the Gaussian component
  # lambda is the parameter controlling the exponential decay component

  # Calculate the Gaussian component
  gaussian <-
    stats::dnorm(x, mean = 0, sd = sigma) *
    stats::dnorm(y, mean = 0, sd = sigma)

  # Calculate the exponential component
  exponential <- stats::dexp(sqrt(x^2 + y^2), rate = lambda)

  # Combine the two components to get the final dispersal kernel
  return(gaussian * exponential)
}
