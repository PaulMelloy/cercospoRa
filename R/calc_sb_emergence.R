#' Estimate sugarbeat emergence
#'
#' @description
#' This function estimates the time required for sugarbeat emergence as described
#' by \insertCite{rimaz_predicting_2020}{cercosporaR}
#'
#'
#' @param Tm numeric, average hourly temperature between sowing and emergence in Celsius.
#'  Or a vector of hourly of temperature means can also be provided.
#' @param Tm_base numeric, lowest temperature which contributes to the development
#'  of the seedling and emergence. Default 6$^o$C
#' @param Tm_crit numeric, critical (Highest) temperature which contributes to
#'  the development of the seedling and emergence. Ideal development temperature
#'  is described as between 24 and 28 degrees \insertCite{rimaz_predicting_2020}{cercosporaR}
#' @param mu1 model parameter, This is defined by soil properties, such as, soil
#'  moisture, soil particle size and sowing depth. By default we use soil type 3
#'  described in the paper \insertCite{rimaz_predicting_2020}{cercosporaR},
#'  Daneshkadeh soil Seri.
#' @param mu2 model parameter, See `mu1` description
#' @param alfa model parameter, See `mu1` description
#' @param bta model parameter, See `mu1` description
#' @param sowing_depth numeric, given in centimetres. Also considered to be the
#'  internode length. Default = 5
#' @param bulk_density numeric, in grams per cm-3. Soil bulk density is defined by
#'  the particles size and pore size.
#' @param seed_density numeric, in grams per cm-3. Default defined in publication
#' @param soil_water_content numeric, usually between 0.55 (drier) and 0.7 (saturated)
#' @param soil_particle_diameter numeric, diameter of soil particle size. This is
#'  not described and guessed. No units were provided either.
#'
#' @return numeric, the estimated days to emergence in days. always returns a single
#'  number
#' @export
#' @references \insertAllCited{}
#'
#' @examples
#' calc_sb_emergence(27)
#' calc_sb_emergence(20:40)
calc_sb_emergence <- function(Tm,
                              sowing_depth = 5,
                              bulk_density = 1.28,
                              seed_density = 2.65,
                              soil_water_content = 0.7,
                              soil_particle_diameter = 0.01,
                              mu1 = -4.8,
                              mu2 = -8.1,
                              alfa = 0.89,
                              bta = 0.56,
                              Tm_base = 4,
                              Tm_crit = 38,
                              na.rm = FALSE
                              ) {
  Tm[Tm <= Tm_base] <- Tm_base + 0.01
  Tm[Tm >= Tm_crit] <- Tm_crit - 0.01

  A <- exp(mu1) * ((Tm - Tm_base)^alfa) * ((Tm_crit - Tm)^bta)
  B <- exp(mu2) * ((Tm - Tm_base)^alfa) * ((Tm_crit - Tm)^bta)
  IL <- sowing_depth
  # IER The length of the internodes which is the planting depth
  IER <- A - B * IL
  # time of emergence t_g
  t_g <- IL/IER

  # equation 5
  # where qb and qs are the soil bulk and grain density (g/cm3) that was considered 2.65 (g/cm3) in this experiment.
  s0 <- 1- (bulk_density/seed_density)

  # Equations 6, 7, 8, 9 in publication are ignored as these moderate the emergence
  # time depending on the particle size, sowing depth and/or soil moisture. The base
  # values is the average for the soil being used. If the soil particles are larger than
  # average average emergence time advances as a propotion of the base ie > 1.
  # Drier gives a lower proportiong < 1, and larger sowing depth slowes the function?

  # the 0.47 moderates the output so it reflects the figure 3
  # return the mean of a input vector
  days2emerge <- round(mean(t_g * 0.47, na.rm = na.rm),2)
  return(days2emerge)
}
