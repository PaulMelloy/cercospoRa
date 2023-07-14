calc_epidemic_onset <- function(c_closure = as.POSIXct("2023-06-01"),
                                weather,
                                cultivar_sus){
  if(inherits(weather,"epiphy.weather") == FALSE){
    stop("'weather' has not been formatted with 'epiphytoolR::format_weather().")
  }

  w <- weather[times >= c_closure]

  daily_inf_val <- calc_DIV(dat = weather)

  sum(daily_inf_val$DIV_racca)


}
