#' Calculate epidemic onset
#'
#' @param start posixct, start date in which to begin calculating the epidemic
#'  onset, if not specified, the first date in the weather data will be used.
#' @param end posixct, end date, last date to complete calculating the epidemic
#'  onset, if not specified, the last date in the weather data will be used.
#' @param c_closure POSIXct formatted date to start the model running the model
#'  This is usually at canopy closure (racca)
#' @param weather data.table, formatted with `epiphytoolR::format_weather`
#' @param cultivar_sus character, susceptibility of the cultivar in "R" resistant,
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
  if(missing(start)) start <- as.Date(weather$times[1])
  if(missing(end)) end <- as.Date(last(weather$times))

  w <- copy(weather[times > as.POSIXct(start) &
                times < (as.POSIXct(end) + 3600),][times >= as.POSIXct(c_closure)])

  daily_inf_val <- calc_DIV(dat = w)

  div_cs <- daily_inf_val[first(which(cumsum(DIV) >cultivar_sus)),
                          as.POSIXct(paste(Year,Month,Day,sep = "-"), tz = "UTC")]

  div_cs_r <- daily_inf_val[first(which(cumsum(DIV_racca) >cultivar_sus)),
                          as.POSIXct(paste(Year,Month,Day,sep = "-"), tz = "UTC")]

  if(length(div_cs) == 0) div_cs <- last(daily_inf_val$DIV) / cultivar_sus
  if(length(div_cs_r) == 0) div_cs_r <- last(daily_inf_val$DIV_racca) / cultivar_sus

  return(list(wolf_date = div_cs[1],
              racca_date = div_cs_r[1]))

}
