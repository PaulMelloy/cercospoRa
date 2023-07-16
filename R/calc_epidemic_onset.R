#' Calculate epidemic onset
#'
#' @param c_closure POSIXct formated date to start the model running the model
#'  This is usually at canopy closure (racca)
#' @param weather data.table, formated with `epiphytoolR::format_weather`
#' @param cultivar_sus character, susceptibiliy of the cultivar in "R" resistant,
#'  "S" susceptible, "MR" moderately resistant ect.
#'
#' @return numeric, proportion an epidemic indicating the progress to
#' @export
#'
#' @examples
calc_epidemic_onset <- function(c_closure = as.POSIXct("2023-06-01"),
                                weather,
                                cultivar_sus = 5){
  if(inherits(weather,"epiphy.weather") == FALSE){
    stop("'weather' has not been formatted with 'epiphytoolR::format_weather().")
  }

  w <- copy(weather[times >= c_closure])

  daily_inf_val <- calc_DIV(dat = w)

  sum(daily_inf_val$DIV_racca, na.rm = TRUE) / cultivar_sus


}
