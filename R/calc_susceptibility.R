#' Calculate cDIV threshold for sugar beet cultivars
#'
#' @param bbch_scale numeric, BBCH scale (1-9) of the sugar beet cultivars.
#'  1 is the lowest susceptibility and 9 is the highest susceptibility.
#'
#' @returns numeric, cDIV threshold for the start of the epidemic
#'
#' @examples
#' calc_susceptibility(bbch_scale = 4)
#' calc_susceptibility(bbch_scale = 6)
#'
calc_susceptibility <- function(bbch_scale = 4){
  if(bbch_scale < 1 | bbch_scale > 9){
    stop("BBCH scale must be between 1 (lowest susceptibility) and 9, (highest
         susceptibility)")
  }
  # Table 1: sugarbeet cultivar susceptibility (Wolf and Vereet, 2005)
  dat <- data.frame(cultivar = c(rep("Ribella", 13),
                          rep("Patricia",11),
                          rep("Corinna", 16),
                          rep("Tatjana", 3),
                          rep("Cyntia", 2),
                          rep("Achat", 2),
                          rep("Elan", 3),
                          rep("Steffi", 4),
                          rep("Meta", 6),
                          rep("Evita", 3),
                          rep("Hilma", 3),
                          rep("Orbis",3)),
             bbch = c(rep(4, 13),
                      rep(4, 11),
                      rep(4, 16),
                      rep(4, 3),
                      rep(4, 2),
                      rep(4, 2),
                      rep(5, 3),
                      rep(5, 4),
                      rep(6, 6),
                      rep(5, 3),
                      rep(5, 3),
                      rep(5, 3)),
             resistance = c(rep("High", 13),
                            rep("High", 11),
                            rep("High", 16),
                            rep("High", 3),
                            rep("High", 2),
                            rep("High", 2),
                            rep("Low", 3),
                            rep("Low", 4),
                            rep("Low", 6),
                            rep("Low", 3),
                            rep("Low", 3),
                            rep("Low", 3))
             )
  # Find coefficient of the linear model between low and high susceptibility
  sus_mod <- stats::lm(bbch ~ resistance, data = dat)
  #coef(sus_mod)[2]

  # Table 2 values from Wolf and Vereet paper
  # Find the difference between minimum cDIV values of resistant and
  #  susceptible cultivars
  min_resistant <- c(14.51, 13.84, 12.63)
  min_suscept <- c(10.07, 9.25, 7.75)
  min_diff <- min_resistant - min_suscept

  # find average change per scale value of susceptibility
  sus_coef <- mean(min_diff)/coef(sus_mod)[2]

  names(sus_coef) <- NULL
  # find the cDIV threshold for the given bbch scale
  cDIV_threshold <- 14.4724 - ((bbch_scale-4) * sus_coef)

  return(cDIV_threshold)

}
