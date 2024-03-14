#' Calculate growth rate(r) and LAI0 at time t0
#'
#' @param param_rxt Output of the function \\link{calc_r_x0}, which produces a list containing parameters that are necessary to
#' calculate `c_closure`. These parameters are `r`, the growth rate, `x0`, the initial LAI value, and `t0`, the initial date.
#' and the associated dates
#' @param x1 LAI value at which 90% canopy closure is reached. It is fixed to 1.3 for sugar beet
#' @param k carrying capaciy, which is the maximum LAI that can be attained. This value can be cultivar-dependent. The default
#' is fixed to 6
#'
#' @return `c_closure` date at which 90% canopy closure is reached at each location.
#'
#' @export
#'
#'
#' @examples
#' epidemic_onset_param <- read_sb_growth_parameter(system.file("extdata", "uav_img",
#'                                                               package = "cercospoRa"),
#'                                                  10)
#' param_rxt <- calc_r_x0(epidemic_onset_param,
#'                        min_r = 0.02,
#'                        max_r = 0.05,
#'                        k = 6)
#' c_closure <- calc_c_closure(param_rxt,
#'                             x1 = 1.3,
#'                             k=6 )


calc_c_closure <- function(param_rxt,
                           x1 = 1.3,
                           k=6 ){
  x0 <- param_rxt$x0
  r <- param_rxt$r
  t0 <- param_rxt$t0
  c_closure <- as.numeric(t0)/(24*60*60) + round(log( x1*(k-x0)/(x0*(k-x1)))/r,0)
  return(c_closure)
}
