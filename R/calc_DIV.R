#' Calculate daily infection values
#'
#' This function calculates the daily infection values for *Cercospora berticola*
#'  on sugar beet. Functions were adapted from \insertCite{wolf_factors_2005}{cercosporaR}
#'  and \insertCite{wolf_zum_2001}{cercosporaR}
#'
#' @param date_time POSIX_ct, date time the weather recording was taken
#' @param Tm numeric, temperature, in celcius' at time increment in `date_time`
#' @param RH numeric, relative humidity (%) at time increment in `date_time`
#' @param rain numeric, volume of rain in millimeters recorded between time recordings
#' @param dat data.frame, containing column names "times","temp","rh","rain" with
#'  each of the respective arguments for input. provided as a convenience
#'
#' @return data.table, with probability of infection for each day, between 0 and 1
#'  Undertaken with two methods by Wolf \insertCite{wolf_factors_2005}{cercosporaR}
#'  under the `DIV` column and method by Racca et. al \insertCite{racca_cercbet_2007}{cercosporaR}
#'  described in the `DIV_racca` column.
#' @export
#' @references \insertAllCited{}
#'
#' @examples
#' date_t <- Sys.time() + seq(0, 179 * 60 * 10, (60 * 10))
#' Tm <- rnorm(180,20,10)
#' RH <- runif(180,min = 40,90)
#' rain <- rbinom(180,1,0.1) * runif(180,0.1,20)
#'
#' DIV1 <- calc_DIV(
#' date_time = date_t,
#' Tm = Tm,
#' RH = RH,
#' rain = rain
#' )
calc_DIV <- function(date_time, Tm,RH, rain,dat){
  # declare non-globals
  times <- temp <- rh <- NULL

  # check if dat is not supplied and create new data.table
  if(missing(dat)){
    if(missing(rain)) rain <- rep(0,length(RH))
    dat <- data.table::data.table(times = date_time,
                                  temp = Tm,
                                  rh = RH,
                                  rain = rain)
  }
  if(all(c("times","temp","rh","rain") %in% colnames(dat)) == FALSE){
    stop("'dat' data.frame must have colnames 'times','temp','rh','rain'")
  }

  data.table::setDT(dat)
  # Add columns for time increments for aggregation
  dat[,c("Year",
         "Month",
         "Day",
         "Hour") := list(data.table::year(times),
                         data.table::month(times),
                         data.table::mday(times),
                         data.table::hour(times))]
  # Aggregate to hourly
  dat <- dat[, c("temp",
                 "rh",
                 "rain") := list(mean(temp),
                                 mean(rh),
                                 sum(rain)),
             by = c("Year","Month","Day","Hour")
             ]

  dat[, c("Tm_index",
          "moist_ind",
          "s_rate",
          "inf_rate") := list(temperature_index(temp),
                              moisture_index(rh,rain),
                              calc_spore_rate(temp,rh),
                              calc_inf_rate(temp, RH = rh))]

  DIV <- dat[, list(DIV = mean(fifelse(Tm_index == 0 | moist_ind == 0,
                                  0, (Tm_index * moist_ind))),
                    DIV_racca = mean(Tm_index *
                                       s_rate *
                                       inf_rate)),
             by = c("Year","Month","Day")]

  return(DIV)
}
