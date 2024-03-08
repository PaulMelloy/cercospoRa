set.seed(69)

# ten minute increments for
date_t <- Sys.time() + seq(0, 179 * 60 * 10, (60 * 10))
Tm <- rnorm(180,20,10)
RH <- rep(rbeta(20,3,1)*100, each = 9)
rain <- rbinom(180,1,0.1) * runif(180,0.1,20)

test_that("calc_DIV works", {
  # individual vectors
  DIV1 <- calc_DIV(
    date_time = date_t,
    Tm = Tm,
    RH = RH,
    rain = rain
  )
  expect_equal(DIV1$DIV, c(0.5098039  , 0.1760586), tolerance = 0.000001)
  expect_type(DIV1,"list")
  expect_equal(dim(DIV1), c(2,4))
  expect_equal(colnames(DIV1), c("Year","Month","Day","DIV"))

  in_dat <- data.frame(
    date_time = date_t,
    temp = Tm,
    RH = RH,
    rain = rain
  )

  expect_error(calc_DIV(dat = in_dat),
               regexp = "'dat' data.frame must have colnames 'times','temp','rh','rain'")

  in_dat <- data.frame(
    times = date_t,
    temp = Tm,
    rh = RH,
    rain = rain
  )
  calc_DIV(dat = in_dat)

})

# define DIV calculation

dat <- data.table(Tm = rep(0:49, times = 50),
                  Rh = rep (51:100, each = 50))

dat[, DIV := list(temperature_index(Tm)*
                    moisture_index(Rh))]
# library(ggplot2)
# ggplot(dat, aes(x = Tm, y = Rh, z = DIV))+
#   geom_contour_filled()
