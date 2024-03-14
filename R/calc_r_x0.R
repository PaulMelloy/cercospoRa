#' Calculate growth rate(r) and LAI0 at time t0
#'
#' @param param_list Output of the function \\link{read_sb_growth_parameter}, which produces a list containing the LAI images
#' and the associated dates
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
calc_r_x0 <- function(param_list,
                      min_r = 0.02,
                      max_r = 0.05,
                      k = 6){
  t <- as.numeric(param_list$t)/(24*60*60)
  t0 <- t[1]
  imgs <- param_list$imgs

  r <- imgs[[1]]
  x0 <- imgs[[1]]


  for(i in 1:dim(imgs)[1]){
    for(j in 1:dim(imgs)[2]){
      N <- as.numeric(imgs[i,j,])
      dataij <- data.frame(t, N)
      dataij <- stats::na.omit(dataij)

      if(!is.na(N[1])){
        if( dim(dataij)[1] == 1){
          r[i,j] <- min_r
        }else if (dim(dataij)[1] > 1){
          fit_rx <-
            minpack.lm::nlsLM(N ~ k/(1 + ((k-x_ij)/x_ij)*exp(-r_ij*(t-t0))),
                              start = list(x_ij = 1,
                                           r_ij = 0.025),
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
                    t0=param_list$t[1])
  return(param_rxt)
}
