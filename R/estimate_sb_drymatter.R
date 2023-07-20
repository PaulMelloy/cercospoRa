#' Estimate sugar beat dry matter aculumation
#'
#'
#'
#' @param incid_rad incident photosynthetic radiation during crop cycle _n_. Assumed
#'  to be 0.48 (default)
#' @param RG Global incident radiation (RG) kilowatts hours per m2
#' @param LAI leaf area index for the crop cycle _n_. The ratio of total leaf area
#'  of plants divided by the land surface area. Typically between 0 and 9.
#' @param k Beer-Lambert extinction coefficient
#' @param RUE radiation use efficiency of sugar beet. Default = 3.36 as observed
#'  by Lemaire et. al (2009). Typical values for k are in the range of 0.5 to 0.9
#'
#' @return numeric, an estimation of total dry matter produced during a cycle per
#'  square meter
#' @export
#' @references Crop Modeling and Decision Support - A Morphogenetic Crop Model for
#'  Sugar-Beet (Beta vulgaris L.) S. Lemaire, F. Maupas, P. H. Cournede, P. de Reffye
#'
#' @examples
#' estimate_sb_drymatter(RG = 5, LAI = 0.8)
estimate_sb_drymatter <- function(RG,
                                  LAI,
                                  incid_rad = 0.48,
                                  k = 0.7,
                                  RUE  = 3.36){
  PARi_n <- incid_rad * RG * (1-exp(-k*LAI))
  return(PARi_n * RUE)
}
