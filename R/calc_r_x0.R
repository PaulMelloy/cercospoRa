#' Calculate growth rate(r) and LAI0 at time t0
#'
#' @param param_r Output of the function \\link{read_sb_growth_parameter}, which
#'  produces a list containing the LAI images and the associated dates
#' @param min_r minimum growth rate for sugar beet. Default `min_r` is fixed to 0.02 to ensure that the growth rate at the
#' inflexion point of the sigmoid is at least 1 unit of LAI per month
#' @param max_r manimum growth rate for sugar beet. Default `max_r` is fixed to 0.05 to ensure that the growth rate at the
#' inflexion point of the sigmoid is at most 2.5 units of LAI per month
#' @param k carrying capaciy, which is the maximum LAI that can be attained. This value can be cultivar-dependent. The default
#' is fixed to 6
#'
#' @return `param_rxt:` list containing parameters that are necessary to calculate `c_closure`. These parameters are `r`, the
#' growth rate, `x0`, the initial LAI value, and `t0`, the initial date.
#'
#' @export
#'
#' @examples
#' epidemic_onset_param <- read_sb_growth_parameter(system.file("extdata", "uav_img",
#'                                                              package = "cercospoRa"),
#'                                                  10)
#' param_rxt <- calc_r_x0(epidemic_onset_param,
#'                        min_r = 0.02,
#'                        max_r = 0.05,
#'                        k = 6)
calc_r_x0 <- function(param_r,
                      min_r = 0.02,
                      max_r = 0.05,
                      k = 6){
  tm <- as.POSIXct(names(param_r), tz = "UTC")
  tm <- as.numeric(tm)/(24*60*60)
  t0 <- tm[1]

  r <- param_r[[1]]
  x0 <- param_r[[1]]


  for(i in 1:dim(param_r)[1]){
    for(j in 1:dim(param_r)[2]){
      N <- as.numeric(param_r[i,j,])
      dataij <- data.frame(tm, N)
      dataij <- stats::na.omit(dataij)

      if(!is.na(N[1])){
        if(nrow(dataij) == 1){
          r[i,j] <- min_r
        }else if (nrow(dataij) > 1){
          fit_rx <-
            minpack.lm::nlsLM(N ~ k/(1 + ((k-x_ij)/x_ij)*exp(-r_ij*(tm-t0))),
                              start = list(x_ij = 1,
                                           r_ij = 0.025),
                              lower = c(1e-6,
                                        1e-6),
                              algorithm = "port",
                              data = dataij)
          x_ij <- fit_rx$m$getAllPars()[1]
          r_ij <- fit_rx$m$getAllPars()[2]

          r[i,j] <- r_ij
          x0[i,j] <- x_ij
        }
      }
    }
  }

  try(r[r<min_r] <- min_r)
  try(r[r>=max_r] <- max_r)

  param_rxt <- list(r=r,
                    x0=x0,
                    t0=param_list$tm[1])
  return(param_rxt)
}
