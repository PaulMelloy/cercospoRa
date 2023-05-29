#' Calculate Sugarbeet Growing degree-days
#'
#' @param max_tm numeric, maximum daily temperature
#' @param min_tm numeric, minimum daily temperature
#' @param lower_th numeric, lowest temperature which sugar beet grow at (Celcius)
#' @param upper_th numeric, highest temperature which sugar beet grow at (Celcius)
#' @param tm_optim numeric, optimum temperature for fastest growth
#' @param hourly logical, if `TRUE` the function assumes the max_tm and min_tm are
#'  hourly maximums or minimums
#'
#' @return Sum of the growing degree days
#' @export
#'
#' @examples
#' daily_min <- c(5,7,9,1,-5,-2,0)
#' daily_max <- c(25,37,29,11,15,12,10)
#' calc_sugarbeet_gdd(daily_min, daily_max)
calc_sugarbeet_gdd <- function(max_tm, min_tm,
                               lower_th = 1.1,
                               upper_th =30,
                               tm_optim = 26,
                               hourly = FALSE){

  if(length(max_tm) != length(min_tm)){
    stop("length of daily maximum 'max_tm' and daily minumum 'min_tm temperatures need to be the same")
  }
  dat <-data.frame(min_t = min_tm,
                 max_t = max_tm)

  if(hourly){
    HTT <- apply(dat,1,function(x){
      minT <- as.numeric(x["min_t"])
      maxT <- as.numeric(x["max_t"])
      meanT <- mean(minT,maxT)

      if(minT < lower_th) return(0)
      if(maxT > upper_th) return(0)
      if(minT > lower_th &
         maxT < upper_th) {
        out <- (
          (meanT - lower_th)/
            (tm_optim - lower_th)
        ) * ((
          (upper_th - meanT)/
            (upper_th - tm_optim)^((upper_th - tm_optim)/
                                     tm_optim - lower_th))*
            (tm_optim - lower_th)
        )
        return(out)
        # beta formula from https://www.nature.com/articles/s41598-018-28392-z
      }

    })

    return(sum(HTT))
  }else{
    GDD <- apply(dat,1,
                 function(x){
                   minT <- as.numeric(x["min_t"])
                   maxT <- as.numeric(x["max_t"])

                   if(minT < lower_th |
                      maxT < lower_th) return(lower_th)
                   if(maxT > upper_th) return(upper_th)

                   return(mean(c(minT,maxT)) - lower_th)
                 })
    return(GDD)
    # function given from https://ndawn.ndsu.nodak.edu/help-sugarbeet-growing-degree-days.html
  }

}
