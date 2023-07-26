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
calc_epidemic_onset <- function(start,
                                end,
                                c_closure,
                                weather,
                                cultivar_sus = 5){
  rh <- times <- NULL
  if(inherits(weather,"epiphy.weather") == FALSE){
    stop("'weather' has not been formatted with 'epiphytoolR::format_weather().")
  }

  w <- copy(weather[times > as.POSIXct(start) &
                times < (as.POSIXct(end) + 3600),][times >= as.POSIXct(c_closure)])

  daily_inf_val <- calc_DIV(dat = w)

  div_cs <- daily_inf_val[which(cumsum(DIV) >cultivar_sus),
                          as.POSIXct(paste(Year,Month,Day,sep = "-"), tz = "UTC")]

  div_cs_r <- daily_inf_val[which(cumsum(DIV_racca) >cultivar_sus),
                          as.POSIXct(paste(Year,Month,Day,sep = "-"), tz = "UTC")]

  return(list(wolf_date = div_cs[1],
              racca_date = div_cs_r[1]))

}
