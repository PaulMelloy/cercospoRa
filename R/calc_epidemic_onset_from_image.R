#' Calculate epidemic onset from image
#'
#' @param start posixct, start date in which to begin calculating the epidemic
#'  onset, if not specified, the first date in the weather data will be used.
#' @param end posixct, end date, last date to complete calculating the epidemic
#'  onset, if not specified, the last date in the weather data will be used.
#' @param c_closure map of canopy closure dates formatted as number of days since
#' 1970-01-01. It defines the date to start running the model (Wolf)
#' @param weather data.table, formatted with `epiphytoolR::format_weather`
#' @param cultivar_sus character, susceptibility of the cultivar in "R" resistant,
#'  "S" susceptible, "MR" moderately resistant ect.
#'
#' @return `$wolf_date:` If the input weather is conducive for epidemic, the function returns a
#'  POSIX_ct date when epidemic commences. If no epidemic occurs, a numeric,
#'  proportion indicating the progress an epidemic is returned
#'
#' @export
#'
#' @examples
#' wethr <- read.csv(system.file("extdata", "clean_weather.csv",
#'                   package = "cercospoRa"))
#' wethr <- epiphytoolR::format_weather(wethr,time_zone = "UTC")
#'
#' epidemic_onset_param <- read_sb_growth_parameter(system.file("extdata", "uav_img",
#'                                                                 package = "cercospoRa"),
#'                                                    10)
#' param_rxt <- calc_r_x0(epidemic_onset_param,
#'                        min_r = 0.02,
#'                        max_r = 0.05,
#'                        k = 6)
#' c_closure <- calc_c_closure(param_rxt,
#'                             x1 = 1.3,
#'                             k=6 )
#'
#' epidemic_onset_map <- calc_epidemic_onset_from_image(start = as.POSIXct("2022-04-25",tz = "UTC"),
#'                                                      end = as.POSIXct("2022-09-30",tz = "UTC"),
#'                                                      c_closure = c_closure,
#'                                                      weather = wethr)
#'
#' plot(epidemic_onset_map)
calc_epidemic_onset_from_image <- function(start,
                                           end,
                                           c_closure,
                                           weather,
                                           cultivar_sus = 5){
  Ep_onset <- c_closure
  for(i in 1:dim(c_closure)[1]){
    for(j in 1:dim(c_closure)[2]){
      this_canopy_closure <- as.numeric(c_closure[i,j])
      this_canopy_closure <- as.Date.numeric(round(this_canopy_closure),
                                             origin = '1970-01-01')
      if(is.na(this_canopy_closure)){
      }else{
        This_epidemic_onset <- calc_epidemic_onset(start = as.POSIXct("2022-06-01",
                                                                      tz = "UTC"),
                                                   end = as.POSIXct("2022-09-30",
                                                                    tz = "UTC"),
                                                   c_closure = as.POSIXct(this_canopy_closure,
                                                                          tz = "UTC"),
                                                   weather = weather,
                                                   cultivar_sus = cultivar_sus)
        Ep_onset[i,j] <- as.numeric(This_epidemic_onset)/(24*60*60)
      }
    }
  }
  return(terra::rast(Ep_onset))
}
