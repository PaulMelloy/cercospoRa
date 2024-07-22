test_that("calc_DIV works", {
  # individual vectors
  DIV1 <- calc_DIV(
    date_time = date_t,
    Tm = Tm1,
    RH = RH1,
    rain = rain1
  )
  expect_equal(DIV1$DIV, c(0.8445079, 0.8196010 ,0.8513760), tolerance = 0.00001)
  expect_type(DIV1,"list")
  expect_equal(dim(DIV1), c(3,4))
  expect_equal(colnames(DIV1), c("Year","Month","Day","DIV"))

  in_dat <- data.frame(
    date_time = date_t,
    temp = Tm1,
    RH = RH1,
    rain = rain1
  )

  expect_error(calc_DIV(dat = in_dat),
               regexp = "'dat' data.frame must have colnames 'times','temp','rh','rain'")

  in_dat <- data.frame(
    times = date_t,
    temp = Tm1,
    rh = RH1,
    rain = rain1
  )
  #calc_DIV(dat = in_dat)

})

# define DIV calculation

# dat <- data.table(Tm = rep(0:49, times = 50),
#                   Rh = rep (51:100, each = 50))
#
# dat[, DIV := list(temperature_index(Tm)*
#                     moisture_index(Rh))]
# library(ggplot2)
# ggplot(dat, aes(x = Tm, y = Rh, z = DIV))+
#   geom_contour_filled()
