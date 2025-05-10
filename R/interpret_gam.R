interpret_gam <- function(mod,
                          words = 1,
                          rounding = 2,
                          coeff = "(Intercept)",
                          sig = FALSE) {

  if(sig){
    out <- switch(words,
                  0 = round(unname(summary(mod)$p.table[,4][coeff]),rounding),
                  1 = ifelse(summary(mod)$p.table[,4][coeff] >0.05,
                             "not significant",
                             "significant"))
    }
  }else{

  out <- switch(words,
                0 = round(unname(mod$coefficients[coeff]),rounding),
                1 = ifelse(mod$coefficients[coeff] > 0, "more", "less"),
                2 = ifelse(mod$coefficients[coeff] > 0, "greater", "fewer"),
                3 = ifelse(mod$coefficients[coeff] > 0, "higher", "lower"))
  }

  return(out)

}
